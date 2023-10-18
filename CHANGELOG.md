# Changelog

All notable changes to this project will be documented in this file.

## [1.0.3] - 2023-10-17

### Added:

+ Send new metric events HOST_APP_OPEN & RECCO_SDK_OPEN.
+ Support for styles specified via BE.

### Changed

+ Updated OpenAPI generated code to use generator version 7.0.1.

### Fixed

+ Bookmarks never get transparency now, mimicking Android.

## [1.0.2] - 2023-09-06

### Improvements: 
+ Now you can pass along a logging function that will report some Recco internal errors to integrators.

## [1.0.1] - 2023-08-19

### Improvements: 
+ Throw SDK not initialized error when calling login or logout before initializing the sdk
+ Added font selection.
+ Changed BE environment.

### Fixes:
+ Customizable images now function as intended
+ Showcase app includes some bug fixes.

## [1.0.0] - 2023-08-02

- Initial version deployed.
