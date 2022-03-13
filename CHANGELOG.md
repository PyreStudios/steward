# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Support for the app to take in an environment variable which is used to help determine if stacktraces should be written via HTTP when failures are caught. The plan is to ultimately incorporate this into more functionality in the future.

## [0.1.7] - 2022-03-09
### Added
- Support for optional trailing slash support in router matching.
- Support for case insensitive pattern matching for router matching.

### Changed
- Bump version of Bosun dependency.

## [0.1.6] - 2022-03-06
### Fixed
- Dont try to JSONify primitives on their own.
- Catch errors at the framework layer and dont crash the server)
    - There's a lot of further improvement to be made here. See https://github.com/PyreStudios/steward/issues/16 for more information.

## [0.1.5] - 2022-03-05
### Fixed
- Changed the JSON detection mechanism to be less picky.
## [0.1.4] - 2022-03-05
### Fixed
- JSON-ify the body even if the content type is already set

## [0.1.3] - 2022-03-05
### Fixed
- Resolved an issue that was preventing the previous change from running. My bad.

## [0.1.2] - 2022-03-05
### Fixed
- Resolved an issue that was preventing Futures of Futures (and so on) from serializing properly

## [0.1.1] - 2022-02-10
### Changed
- Added support for passing in a host to the router, default to AnyIPv4

## [0.1.0] - 2022-02-2
### Changed
- Steward is now async based!

## [0.0.8] - 2022-02-02
### Added
- Support for @Path decorator to be used on controllers.

### Fixed
- Steward's new command should now place dart files in the correct place

## [0.0.7]
### Added
- Infer content type from response body if none is provided.

## [0.0.6] - 2022-01-26
### Fixed
- An issue with config reader types not working as expected.

## [0.0.5] - 2022-01-26
### Added
- CORS middleware

### Changed
- Refactor and clean up a lot of the app and router code.

## [0.0.4] - 2021-12-18
### Added
- Tests around HEAD, PUT, PATCH, and DELETE in the router
- You can now simply import `package:steward/steward.dart` to bring the entire steward suite into scope. This is the intended way to use steward.
- Added tests for the new controller patterns.
- Added Injectable annotation and HTTP Verb annotations for controllers.

### Changed
- Description in Pubspec.yaml
- Router package now exports the request and response classes as well, since theyre coupled.
- Simplified the generated seed-code to use the simplified imports changes captured in #4
- Controllers function completely differently now. Controllers are mounted into the router which reflectively generates routes from member annotations. Additionally, controllers reflectively have DI items injected via the @Injectable annotation during this time as well.
- Migrated what little CLI we already have to Bosun to provide a better CLI experience.


## [0.0.3] - 2021-04-17
### Added
- Added support for middleware functions
- Added the requestLogger middleware that ships with Steward
- Tests around the router, middleware, and controllers.

### Fixed
- Steward CLI new was not adding imports to the generated controller

## [0.0.2] - 2021-04-11
### Added
- Initial public release of Steward. It's still light with much more to come, but the current pieces work well.
- Add support for Mustache templates and view binding from controllers.
- Add support for wiring up controllers to the router.
