# Changelog

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
