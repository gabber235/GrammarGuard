#!/usr/bin/env bash
# Screens and films of the app for people to look at. The frames come from
# test/media/media_test.dart (`media` in devenv); this turns them into WebP and,
# in CI, publishes them to the `ui-media` branch for pull requests and the
# README.
#
#   tool/media.sh encode               build/media -> build/media/web
#   tool/media.sh publish <path>       build/media/web -> ui-media:<path>
#   tool/media.sh unpublish <path>     removes ui-media:<path>
#   tool/media.sh comment <pr> <base>  posts or updates the pull request's
#                                      comment (needs GH_TOKEN, GITHUB_REPOSITORY)
#
# The ui-media branch never merges and keeps a single commit, so the
# repository does not grow with every screenshot.
set -euo pipefail

media=build/media
web=$media/web
branch=ui-media
marker="<!-- ui-media -->"

encode() {
  rm -rf "$web"
  mkdir -p "$web/screens" "$web/films"
  for png in "$media"/screens/*.png; do
    cwebp -quiet -q 90 "$png" -o "$web/screens/$(basename "${png%.png}").webp"
  done
  for dir in "$media"/films/*/; do
    local name frames last delay
    name=$(basename "$dir")
    delay=$(cat "$dir/delay")
    frames=("$dir"*.png)
    last=${frames[${#frames[@]}-1]}
    unset "frames[${#frames[@]}-1]"
    # The last frame holds, so each loop shows the result before starting over.
    img2webp -loop 0 -lossy -q 80 -m 4 -d "$delay" "${frames[@]}" -d 1500 "$last" -o "$web/films/$name.webp" >/dev/null
  done
}

# Replaces <path> on the ui-media branch with [source] (nothing: removes it)
# and force pushes the branch as one fresh commit.
replace() {
  local path=$1 source=${2:-} tree
  tree=$(mktemp -d)
  if git fetch -q origin "$branch" 2>/dev/null; then
    git worktree add -q --detach "$tree" FETCH_HEAD
  else
    git worktree add -q --detach "$tree"
    git -C "$tree" rm -q -r --cached . && find "$tree" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
  fi
  rm -rf "${tree:?}/$path"
  if [[ -n $source ]]; then
    mkdir -p "$tree/$path"
    cp -R "$source/." "$tree/$path"
  fi
  git -C "$tree" add -A
  local commit
  commit=$(git -C "$tree" -c user.name="github-actions[bot]" -c user.email="github-actions[bot]@users.noreply.github.com" \
    commit-tree "$(git -C "$tree" write-tree)" -m "UI media for pull requests and the README")
  git -C "$tree" push -q -f origin "$commit:refs/heads/$branch"
  git worktree remove --force "$tree"
}

# The pull request's comment: changed screens before and after, every film,
# then every screen. "Changed" means the committed CI golden changed; the
# "before" image is the one published from main.
comment() {
  local pr=$1 base=$2 sha
  sha=$(git rev-parse --short HEAD)
  local raw="https://github.com/$GITHUB_REPOSITORY/raw/$branch"
  local after="$raw/pr/$pr" before="$raw/readme"
  local changed
  changed=$(git diff --name-only "origin/$base...HEAD" -- 'test/goldens/goldens/ci/*.png' | xargs -rn1 basename | sed 's/\.png$//')

  {
    echo "$marker"
    echo "## How it looks now"
    echo
    if [[ -z $changed ]]; then
      echo "No screen changed in this pull request."
    else
      echo "| Screen | Before (main) | After |"
      echo "|---|---|---|"
      for name in $changed; do
        echo "| ${name//_/ } | <img src=\"$before/screens/$name.webp?v=$sha\" width=\"360\"> | <img src=\"$after/screens/$name.webp?v=$sha\" width=\"360\"> |"
      done
    fi
    echo
    echo "<details><summary>Motion</summary>"
    echo
    for film in "$web"/films/*.webp; do
      local name
      name=$(basename "${film%.webp}")
      echo "**${name//_/ }**"
      echo
      echo "<img src=\"$after/films/$name.webp?v=$sha\" width=\"720\">"
      echo
    done
    echo "</details>"
    echo
    echo "<details><summary>Every screen</summary>"
    echo
    for screen in "$web"/screens/*.webp; do
      local name
      name=$(basename "${screen%.webp}")
      echo "**${name//_/ }**"
      echo
      echo "<img src=\"$after/screens/$name.webp?v=$sha\" width=\"720\">"
      echo
    done
    echo "</details>"
    echo
    echo "<sub>Rendered from $sha by the UI media workflow.</sub>"
  } >"$media/comment.md"

  local id
  id=$(gh api "repos/$GITHUB_REPOSITORY/issues/$pr/comments" --paginate \
    --jq "map(select(.body | startswith(\"$marker\"))) | first | .id // empty" | head -n1)
  if [[ -n $id ]]; then
    gh api -X PATCH "repos/$GITHUB_REPOSITORY/issues/comments/$id" -F body=@"$media/comment.md" >/dev/null
  else
    gh api "repos/$GITHUB_REPOSITORY/issues/$pr/comments" -F body=@"$media/comment.md" >/dev/null
  fi
}

case ${1:-} in
  encode) encode ;;
  publish) replace "$2" "$web" ;;
  unpublish) replace "$2" ;;
  comment) comment "$2" "$3" ;;
  *)
    sed -n '2,13p' "$0"
    exit 1
    ;;
esac
