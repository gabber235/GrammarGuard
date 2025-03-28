# GrammarGuard

**Enhance, rewrite, and format selected text from anywhere on macOS.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

GrammarGuard is a macOS application built with Flutter, designed to seamlessly integrate into your writing workflow. It
runs discreetly in the background, ready to help you improve any text you select, anywhere on your system.

Forget the copy-paste-edit-copy-back routine. With GrammarGuard, simply select text in any application, press a
shortcut, and instantly get suggestions for:

* Correcting spelling and grammar.
* Rewriting text with adjustable intensity – from subtle polishing to significant rephrasing.
* Optionally adding Markdown or LaTeX formatting.

GrammarGuard appears in a convenient floating window, allowing for quick refinements without disrupting your focus.

**Note:** Initial development is focused exclusively on **macOS** due to the reliance on OS-specific features for text
capture and window management.

## Features

* **System-Wide Text Capture (macOS):** Grabs the currently selected text when triggered.
* **(Fallback):** Can potentially operate on clipboard content if no text is selected.
* **Background Operation:** Runs unobtrusively until needed.
* **Floating Window UI:** Appears on top of other windows for easy access upon activation.
* **Global Shortcut Activation:** Trigger GrammarGuard with `Alt+Shift+G` (configurable in future versions).
* **Spelling & Grammar Correction:** Fixes common writing errors.
* **Flexible Rewriting:** Control the degree of change using intuitive controls (e.g., a slider or presets, manageable
  via shortcuts).
    * *Low Strictness:* Minor tweaks, synonym swaps, basic fluency improvements.
    * *High Strictness:* Significant rephrasing, altering sentence structure/tone while preserving core meaning.
* **Formatting Options:** Optionally enable Markdown or LaTeX syntax integration (toggleable via shortcuts).
* **Quick Copy:** Easily copy the improved text to your clipboard.
* **(Potential Future Feature):** Direct insertion/replacement of the selected text in the source application (complex,
  OS-dependent).

## How It Works

1. **Background Listener:** GrammarGuard runs in the background, listening for the global keyboard shortcut (
   `Alt+Shift+G`).
2. **Text Capture:** When the shortcut is pressed, GrammarGuard attempts to retrieve the currently selected text using
   macOS accessibility APIs or other platform-specific methods. (If no text is selected, it might check the clipboard
   content as a fallback.)
3. **Floating Window:** A floating window appears instantly on top of your current application, displaying the captured
   text.
4. **Processing:** The text is sent to a processing backend (likely an external LLM API like OpenAI, Gemini, Claude,
   etc.) based on your settings.
5. **Refinement & Display:** GrammarGuard shows the original text and the AI-generated suggestions. You can adjust
   strictness and formatting options using keyboard shortcuts within the window.
6. **Output:** Review the suggestions and press a shortcut (e.g., `Cmd+C` or Enter) to copy the desired version to the
   clipboard.
7. **Dismissal:** The floating window can be dismissed easily (e.g., pressing `Esc` or clicking outside).

## Screenshots / Demo

<!-- Add screenshots or GIFs of the application in action here -->

* [Screenshot showing text selected in an app and the GrammarGuard floating window appearing]
* [Screenshot showing the strictness/formatting options within the floating window]
* [GIF demonstrating the Alt+Shift+G -> Refine -> Copy workflow]

## Installation (macOS)

**(Instructions specific to macOS distribution)**

**Building from Source (Recommended for Development):**

1. Ensure you have Flutter installed for macOS
   development: [https://docs.flutter.dev/desktop#macos](https://docs.flutter.dev/desktop#macos)
2. Clone the repository: `git clone https://github.com/gabber235/GrammarGuard.git`
3. Navigate to the project directory: `cd GrammarGuard`
4. Install dependencies: `flutter pub get`
5. Enable macOS desktop support if not already: `flutter config --enable-macos-desktop`
6. Run the application: `flutter run -d macos`

**(Instructions for installing a packaged `.app` file will be added here once available)**

* Download the latest `GrammarGuard.dmg` or `GrammarGuard.zip` from
  the [Releases page](https://github.com/gabber235/GrammarGuard/releases).
* Open the DMG/ZIP file.
* Drag `GrammarGuard.app` to your `/Applications` folder.
* You may need to grant Accessibility permissions in `System Settings > Privacy & Security > Accessibility` for
  GrammarGuard to capture selected text. The app should prompt you if needed.

## Usage

1. Launch GrammarGuard. It should run in the background (confirm via Activity Monitor or a potential menu bar icon).
2. Select text in any application.
3. Press `Alt+Shift+G`.
4. The GrammarGuard floating window appears with your selected text.
5. Use shortcuts within the window to:
    * Adjust rewriting strictness (e.g., `Cmd+Up/Down Arrow`).
    * Toggle Markdown/LaTeX formatting (e.g., `Cmd+M`, `Cmd+L`).
    * Cycle through suggestions if multiple are provided.
6. Review the improved text.
7. Press `Cmd+C` (or maybe `Enter`) to copy the refined text to your clipboard.
8. Press `Esc` or click outside the window to dismiss GrammarGuard.
9. Paste the improved text (`Cmd+V`) into your original application or elsewhere.

## Configuration

* **API Keys:** You will likely need to configure API keys for the AI service used for rewriting. This will be managed
  within the application's settings (accessible perhaps via a menu bar icon or a dedicated settings window).
* **Keyboard Shortcuts:** Future versions aim to allow customization of the main trigger shortcut and in-window
  shortcuts.

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository (`https://github.com/gabber235/GrammarGuard/fork`).
2. Create a new branch (`git checkout -b feature/your-feature-name`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature/your-feature-name`).
6. Open a Pull Request against the `main` branch of `https://github.com/gabber235/GrammarGuard`.

Please ensure your code adheres to the project's coding standards and includes tests where applicable. Report bugs or
suggest features using the [GitHub Issues tab](https://github.com/gabber235/GrammarGuard/issues).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for
details. <!-- Make sure you add a LICENSE file -->