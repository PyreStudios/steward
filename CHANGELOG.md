# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- Description in Pubspec.yaml

## [0.0.3] - 2021-04-17
### Added
- Added support for middleware functions
- Added the requestLogger middleware that ships with Drengr
- Tests around the router, middleware, and controllers.

### Fixed
- Drengr CLI new was not adding imports to the generated controller

## [0.0.2] - 2021-04-11
### Added
- Initial public release of Drengr. It's still light with much more to come, but the current pieces work well.
- Add support for Mustache templates and view binding from controllers.
- Add support for wiring up controllers to the router.
