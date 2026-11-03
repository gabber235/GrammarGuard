# GrammarGuard

## Keeping the look

The app's look is finished and deliberate. New UI must read as if it was always there.

- When adding or changing UI, first find the closest existing screen and copy its pattern: its rows, labels, spacing and controls. On a settings page that means `ListTile` rows in a `Panel`, and a `SectionLabel` above a `Panel`, not inside it.
- Build from `lib/ui/surfaces.dart` and `InlinePicker`. Do not add a new kind of control or style for one feature.
- When a feature replaces a control, keep the row it lived in. Change as little of the screen as the feature allows.
- Do not change an existing icon, label or position unless the task asks for it.
- When no existing pattern fits, show the options and ask before building.
- Before reporting UI work, run `media` and open each changed screen in `build/media/web/screens` next to the same or nearest screen from `main`. The goldens in `test/goldens/goldens/ci` draw text as blocks, so they cannot show whether a screen feels the same.
