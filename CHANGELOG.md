# Changelog

All notable changes to this project will be documented in this file.

## [1.3.0] - 2024-02-02

### Added:
- Support for podcasts and video recommendations. 
- Support for embedded audio in articles.

### Fixed
- Now recommendation questionnaires work as expected. 

## [1.2.0] - 2024-01-15

### Added:

- Support questionnaires as new type of recommendation.

### Changed

- Update questionnaires card visuals.
- Remove old analytics metrics.

## [1.1.0] - 2023-12-13

### Added:

+ Support dynamic image URLs with standardised sizes

### Fixed

+ Close button on DashboardView fullscreen error has been removed to avoid redundancy.


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
