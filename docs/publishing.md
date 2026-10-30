# Publishing

A release starts when the release pull request that release-please keeps open is merged (see CONTRIBUTING.md).
`.github/workflows/release.yml` then builds every platform, attaches the files to the GitHub release, and
publishes them:

| Channel | How it updates | Needs |
|---|---|---|
| GitHub release | Automatic: all files, the changelog | Nothing |
| Nix flake (`nix/release.json`) | Automatic: a pin commit on `main` | `NIX_PIN_DEPLOY_KEY` (deploy key on this repository, allowed past the `main` ruleset) |
| Homebrew tap ([gabber235/homebrew-tap](https://github.com/gabber235/homebrew-tap)) | Automatic | `HOMEBREW_TAP_DEPLOY_KEY` |
| Scoop bucket ([gabber235/scoop-bucket](https://github.com/gabber235/scoop-bucket)) | Automatic | `SCOOP_BUCKET_DEPLOY_KEY` |
| AUR (`grammarguard-bin`) | Automatic once set up | `AUR_SSH_PRIVATE_KEY`, see below |
| winget (`Gabber235.GrammarGuard`) | Automatic after the first version is accepted | `WINGET_TOKEN`, see below |
| nixpkgs | By hand, see below | A nixpkgs pull request |

The macOS app is signed with one self-signed certificate (`MACOS_SELF_SIGNED_P12` and
`MACOS_SELF_SIGNED_PASSWORD`). Keep a copy of the certificate outside GitHub: a new certificate makes every
user grant the Accessibility permission again.

To rebuild and republish a release (for example after adding a secret), run the Release workflow by hand with
its tag.

## AUR

1. Create an account at <https://aur.archlinux.org/register> and add the release key's public half under
   "My Account", SSH Public Key.
2. Save the private half as the `AUR_SSH_PRIVATE_KEY` secret.
3. Run the Release workflow by hand with the latest tag. The first run creates `grammarguard-bin`.

## winget

The first version of a package is reviewed by a moderator; later versions are submitted automatically by
`vedantmgoyal9/winget-releaser`.

1. Create a classic token with the `public_repo` scope at <https://github.com/settings/tokens> and save it as
   the `WINGET_TOKEN` secret. (winget-pkgs does not accept pull requests from fine-grained tokens.)
2. Submit the first version from a Windows machine, with the manifests in `packaging/winget`:

   ```powershell
   winget validate --manifest packaging\winget
   winget install --manifest packaging\winget
   wingetcreate submit --token <token> packaging\winget
   ```

3. On the pull request, sign Microsoft's Contributor License Agreement when the bot asks.

## nixpkgs

`packaging/nixpkgs/package.nix` is a ready package for `pkgs/by-name/gr/grammarguard/package.nix`. Before
opening the pull request, add yourself to `maintainers/maintainer-list.nix` and to `meta.maintainers`, and
build it with `nix-build -A grammarguard`. nixpkgs reviewers expect the pull request and its description to
come from the maintainer. On Linux they may ask for a source build with `buildFlutterApplication`. Once
merged, nixpkgs' update bot proposes new versions.
