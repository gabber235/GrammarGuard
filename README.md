# GrammarGuard

**Enhance, rewrite, and format selected text from your desktop.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

GrammarGuard is a Flutter desktop application for macOS, Linux, and Windows. It
runs discreetly in the background, ready to help you improve any text you select, anywhere on your system.

Forget the copy-paste-edit-copy-back routine. With GrammarGuard, simply select text in any application, press a
shortcut, and instantly get suggestions for:

* Correcting spelling and grammar
* Rewriting text with adjustable intensity – from subtle polishing to significant rephrasing
* Adding Markdown or LaTeX formatting

GrammarGuard supports multiple AI providers, including **OpenAI (GPT models)**, **Google AI (Gemini)**, **Anthropic (Claude)**, and **Ollama (local models)**, allowing you to choose the best model for your needs. It appears in a convenient floating window, allowing for quick refinements without disrupting your focus.

On macOS it behaves as a floating palette that hides when it loses focus. On Linux and Windows it stays in a normal window so it remains accessible even when a global shortcut is unavailable.

![GrammarGuard in action](readme/showoff.png)

## Features

* **System-Wide Text Capture:** Grabs text from your clipboard when triggered
* **Multi-Provider Support:** Choose between OpenAI, Google (Gemini), Anthropic (Claude), Ollama Local, and Ollama Cloud models.
* **Model Selector:** Easily switch between different AI models and see their token pricing.
* **Quick Provider Switching:** Seamlessly switch between local (Ollama Local) and cloud (Ollama Cloud) providers based on your needs.
* **Background Operation:** Runs unobtrusively until needed
* **Floating Window UI:** Appears on top of other windows for easy access upon activation
* **Global Shortcut Activation:** Trigger GrammarGuard with `Alt+Shift+G` on macOS, Windows, and Linux X11
* **Text Rewriting with Multiple Intensities:**
    * *Fix Only:* Basic grammar and spelling corrections
    * *Polish:* Minor tweaks and fluency improvements
    * *Enhance:* Moderate improvements to clarity and style
    * *Rewrite:* Significant rephrasing while preserving meaning
* **Formatting Options:** Toggle Markdown or LaTeX syntax integration
* **Diff View:** Toggle between original and rewritten text to see changes
* **Keyboard Shortcuts:** Quick access to all features
* **Beautiful UI:** Light and dark themes with Catppuccin color scheme
* **Secure API Key Storage:** Safely stores your API keys for cloud providers (OpenAI, Gemini, Claude). Ollama runs locally and requires no API keys.

## How It Works

1. **Background Listener:** On macOS, GrammarGuard listens for `Alt+Shift+G` while running in the background. Windows and Linux X11 use the shortcut to focus the window.
2. **Text Capture:** When the shortcut is pressed, GrammarGuard retrieves text from your clipboard
3. **Floating Window:** A floating window appears instantly on top of your current application, displaying the captured text
4. **Processing:** The text is sent to your chosen AI provider and model for processing based on your selected intensity and formatting options
5. **Refinement & Display:** GrammarGuard shows the original text and the AI-generated suggestions
6. **Output:** Review the suggestions and press `Enter` to copy the desired version to your clipboard
7. **Dismissal:** On macOS, the floating window can be dismissed by pressing `Esc` or clicking outside. On Linux and Windows, close the window normally.

## Keyboard Shortcuts

* `Alt+Shift+G`: Show/hide on macOS; focus the window on Windows and Linux X11
* `1-4`: Set rewrite intensity (1=fix only, 2=polish, 3=enhance, 4=rewrite)
* `S`: Show model selector
* `C`: Show provider configuration
* `M`: Toggle Markdown formatting
* `L`: Toggle LaTeX formatting
* `H`: Toggle diff view
* `R`: Toggle rendering mode
* `↑/↓` or `J/K`: Scroll text
* `U/D`: Scroll text by half page
* `Enter`: Copy improved text to clipboard
* `Esc`: Dismiss window

## Building from source

Install Flutter 3.47 or newer with Dart 3.13 or newer, then run `flutter pub get` in the project directory.

### macOS

**Building from Source (Recommended for Development):**

1. Ensure you have Flutter installed for macOS development: [https://docs.flutter.dev/desktop#macos](https://docs.flutter.dev/desktop#macos)
2. Clone the repository: `git clone https://github.com/gabber235/GrammarGuard.git`
3. Navigate to the project directory: `cd GrammarGuard`
4. Enable macOS desktop support if not already: `flutter config --enable-macos-desktop`
5. Run the application: `flutter run -d macos`

### Linux

Install the [Flutter Linux toolchain](https://docs.flutter.dev/platform-integration/linux/setup), GTK 3 development files, `libsecret-1-dev`, and `libkeybinder-3.0-dev`. A desktop keyring service such as GNOME Keyring or KWallet is needed to store API keys. Then run `flutter run -d linux` or `flutter build linux` on a Linux host.

The global shortcut uses Keybinder and is available in X11 sessions. Wayland sessions keep the normal window accessible and do not register the global shortcut.

### Windows

Install the [Flutter Windows toolchain](https://docs.flutter.dev/platform-integration/windows/setup) with Visual Studio's Desktop development with C++ workload and the C++ ATL libraries required by `flutter_secure_storage`. Then run `flutter run -d windows` or `flutter build windows` on a Windows host.

## First-Time Setup

1. Launch GrammarGuard.
2. The first time you open the app, or if no providers are configured, you'll be taken to the provider configuration screen.
3. Press `C` at any time to open the configuration screen.
4. Select a provider (e.g., OpenAI, Gemini, Claude, or Ollama) and enter your API key or configure your local server.
5. You can configure multiple providers. The app will securely store your API keys. For Ollama, configure your local server URL (default: http://localhost:11434).
6. Once at least one provider is configured, you're ready to go!

## Ollama Setup

GrammarGuard supports two Ollama providers:

### Ollama Local (Default)

Ollama Local allows you to run AI models directly on your machine, providing privacy and eliminating the need for API keys.

**Installing Ollama**

1. Download and install Ollama from [https://ollama.com](https://ollama.com)
2. Start Ollama by running `ollama serve` in your terminal (or it may start automatically)
3. Download a model, for example: `ollama pull llama3.2` or `ollama pull mistral`

**Configuring Ollama Local in GrammarGuard**

1. In GrammarGuard, press `C` to open the configuration screen
2. Select "Ollama Local" from the provider list
3. Configure your server URL (default: `http://localhost:11434`)
4. Click "Test Connection" to verify Ollama is running
5. Click "Refresh Models" to load available models from your Ollama installation
6. Save your configuration

**Benefits of Local Models**

* **Privacy:** All processing happens locally on your machine
* **No API costs:** No per-token charges or usage limits
* **Offline capability:** Works without internet connection
* **Model flexibility:** Choose from various open-source models

### Ollama Cloud

Ollama Cloud provides access to Ollama's cloud-hosted models. You can provide an API key when your endpoint requires authentication.

**Configuring Ollama Cloud in GrammarGuard**

1. In GrammarGuard, press `C` to open the configuration screen
2. Select "Ollama Cloud" from the provider list
3. Enter the server URL (default: `https://ollama.com`)
4. Optionally enter your API key if you have one configured
5. Click "Test Connection" to verify the connection
6. Click "Refresh Models" to load available models
7. Save your configuration

**Note:** Local models may be slower than cloud providers depending on your hardware, but offer complete privacy and control.

## Usage

1. Launch GrammarGuard. It will run in the background
2. Copy text from any application
3. Press `Alt+Shift+G` on macOS, Windows, or Linux X11, or open the normal window on Linux Wayland
4. The GrammarGuard window appears with your text
5. Use keyboard shortcuts to:
    * Press `S` to select your desired AI model.
    * Adjust rewriting intensity (1-4)
    * Toggle Markdown/LaTeX formatting (M/L)
    * Toggle diff view (H)
    * Toggle rendering mode (R)
6. Review the improved text
7. Press `Enter` to copy the refined text to your clipboard
8. On macOS, press `Esc` or click outside the window to dismiss GrammarGuard; on Linux and Windows, close the window normally
9. Paste the improved text into your original application

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository (`https://github.com/gabber235/GrammarGuard/fork`)
2. Create a new branch (`git checkout -b feature/your-feature-name`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add some feature'`)
5. Push to the branch (`git push origin feature/your-feature-name`)
6. Open a Pull Request against the `main` branch

Please ensure your code adheres to the project's coding standards and includes tests where applicable. Report bugs or suggest features using the [GitHub Issues tab](https://github.com/gabber235/GrammarGuard/issues).
