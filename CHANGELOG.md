# Changelog

## [1.3.0](https://github.com/gabber235/GrammarGuard/compare/v1.2.2...v1.3.0) (2026-11-05)


### Features

* **bar:** color the provider apart from the price ([78848ff](https://github.com/gabber235/GrammarGuard/commit/78848ffeb0391a9d5d21295ee239bfbecad30faa))
* **bar:** show and search the provider of each model ([4e09b0c](https://github.com/gabber235/GrammarGuard/commit/4e09b0c845a97e9af04fbad4d4ef165e3696030c))
* **history:** choose how many rewrites to keep ([a1aa205](https://github.com/gabber235/GrammarGuard/commit/a1aa20528a0c670ac055418f3c7556888aae3ced))
* **keys:** one command table, a Keys view and a choose first shortcut ([9f0270b](https://github.com/gabber235/GrammarGuard/commit/9f0270b7c41ab46f8a6780899c2e779fb6c4fe75))
* **settings:** save an API key by itself and check it with the service ([3ea3bea](https://github.com/gabber235/GrammarGuard/commit/3ea3bea9933830498b346a229142a5f7406fe1d8))


### Bug fixes

* **bar:** say per million in the price instead of a tooltip ([4361874](https://github.com/gabber235/GrammarGuard/commit/4361874fb3e6090864a7958c7980663929e2cd4e))
* **footer:** count a new rewrite's time from its start ([6dcc9ca](https://github.com/gabber235/GrammarGuard/commit/6dcc9caaa40f127aba911808415b6bbf9e068e80))
* **keys:** keep shortcuts, saved keys and the preview through what the review found ([09e28d1](https://github.com/gabber235/GrammarGuard/commit/09e28d1f556aa436b0b3e3c8177eb4835c9e32b8))
* **llm:** reload model lists when the window comes to the front ([#35](https://github.com/gabber235/GrammarGuard/issues/35)) ([3cc978e](https://github.com/gabber235/GrammarGuard/commit/3cc978eb05e5973049a2038dd35f277bbb9b73d3))
* **settings:** edit instructions in the window instead of a dialog ([fe16d1b](https://github.com/gabber235/GrammarGuard/commit/fe16d1bff4a2b47d5da0956489e45f6ccc777a9d))
* **settings:** keep double clicks and retyping away from the new views ([6dcc909](https://github.com/gabber235/GrammarGuard/commit/6dcc909ad3c89210d3d9992645ce024f94f90f73))
* **settings:** make the history limit and Keys page match the settings around them ([ef974ae](https://github.com/gabber235/GrammarGuard/commit/ef974ae96370acf40a8fd1126898eafe25ffe275))
* **settings:** pick a searchable list's row with a mouse click ([8f64a33](https://github.com/gabber235/GrammarGuard/commit/8f64a33d4a510b7069599d57592e584f983123df))

## [1.2.2](https://github.com/gabber235/GrammarGuard/compare/v1.2.1...v1.2.2) (2026-10-30)


### Bug fixes

* **assistant:** render Markdown in the answers ([#25](https://github.com/gabber235/GrammarGuard/issues/25)) ([3fc41e0](https://github.com/gabber235/GrammarGuard/commit/3fc41e0af7357698eab5dca4fc1ee88a46a75511))

## [1.2.1](https://github.com/gabber235/GrammarGuard/compare/v1.2.0...v1.2.1) (2026-10-30)


### Bug fixes

* **assistant:** change existing profiles instead of adding new ones ([#17](https://github.com/gabber235/GrammarGuard/issues/17)) ([47f4a52](https://github.com/gabber235/GrammarGuard/commit/47f4a52c0d161d5c1657060527dc8471ab448983))
* **review:** highlight a wrapping change per line ([#20](https://github.com/gabber235/GrammarGuard/issues/20)) ([ecd86cd](https://github.com/gabber235/GrammarGuard/commit/ecd86cd91c2122fb19604b25aa337cc3ff68171b))
* **review:** show a result without changes instead of an error box ([#22](https://github.com/gabber235/GrammarGuard/issues/22)) ([a83104d](https://github.com/gabber235/GrammarGuard/commit/a83104dbbb2b27e349fe0865695b8e046866f7cd))
* **settings:** accept F keys as the shortcut without a modifier ([#21](https://github.com/gabber235/GrammarGuard/issues/21)) ([14f71cd](https://github.com/gabber235/GrammarGuard/commit/14f71cd79c6bfb9bcf325d2c9bb009804d39f214))
* show the window when the app is opened, not only by the hotkey ([#23](https://github.com/gabber235/GrammarGuard/issues/23)) ([3a0a182](https://github.com/gabber235/GrammarGuard/commit/3a0a18230a998d7a382b75b5ca5488d813e8c33b))

## [1.2.0](https://github.com/gabber235/GrammarGuard/compare/v1.1.1...v1.2.0) (2026-10-25)


### Features

* **linux:** support the global shortcut, selection reading and paste back on Wayland ([#14](https://github.com/gabber235/GrammarGuard/issues/14)) ([63799bf](https://github.com/gabber235/GrammarGuard/commit/63799bf554d8402485b207e7b035586e21633add))

## [1.1.1](https://github.com/gabber235/GrammarGuard/compare/v1.1.0...v1.1.1) (2026-10-25)


### Bug fixes

* **linux:** restore keyboard input and the tray on Wayland ([#12](https://github.com/gabber235/GrammarGuard/issues/12)) ([9e4bc32](https://github.com/gabber235/GrammarGuard/commit/9e4bc32841be9d9335e0c6952b3b56d5d4bc0eae))

## [1.1.0](https://github.com/gabber235/GrammarGuard/compare/v1.0.0...v1.1.0) (2026-10-21)


### Features

* **library:** recover from a broken library.yaml in one click ([9000082](https://github.com/gabber235/GrammarGuard/commit/90000824fc7e92731944c2334ec309a69dcbb04c))
* **settings:** pick the assistant model and an instruction's group in place ([16e3410](https://github.com/gabber235/GrammarGuard/commit/16e3410e96444812dcc4c165278abb84adba76b4))


### Bug fixes

* **library:** say plainly when a comma cut a text short ([c1af4b9](https://github.com/gabber235/GrammarGuard/commit/c1af4b9154ffcb49932b638a8c134ec8c3d8ea05))
* **llm:** never offer embedding models ([45b868d](https://github.com/gabber235/GrammarGuard/commit/45b868d1663bdb578d7f49059289e5302a868b80))
* **macos:** sign local builds with the developer's team again ([4ad75d5](https://github.com/gabber235/GrammarGuard/commit/4ad75d5f56092af5e3e63e162f8d63231c63229d))

## 1.0.0 (2026-10-21)


### ⚠ BREAKING CHANGES

* GrammarGuard is rebuilt around one instruction library, profiles and an in-place review ([#2](https://github.com/gabber235/GrammarGuard/issues/2)). The old styling options and rewrite settings are gone; setup starts from the bundled library. API keys saved by the old version keep working.

### Features

* rebuild around instructions, profiles and an in-place review ([#2](https://github.com/gabber235/GrammarGuard/issues/2)) ([8349233](https://github.com/gabber235/GrammarGuard/commit/8349233d50b9774baa8226237a5a563b967c585e))
* read and paste selected text natively on every desktop ([713bb8b](https://github.com/gabber235/GrammarGuard/commit/713bb8b153e5f7b9d2c09e85ed743293915dcc1f))
* give GrammarGuard its own icon and name on every platform ([a9d6619](https://github.com/gabber235/GrammarGuard/commit/a9d661986dd5372a31e1a0246dcde75bf29d774d))
* **nix:** install GrammarGuard and start it at login with Nix ([d765b90](https://github.com/gabber235/GrammarGuard/commit/d765b90f0bc551a6d04788e465cff4a807c0732a))


### Bug fixes

* keep the rail's pill still when writing ends ([3df5a74](https://github.com/gabber235/GrammarGuard/commit/3df5a749872fadc3620637bbef4da16f4a4bfb06))
