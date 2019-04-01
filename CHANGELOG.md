# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- Release the files in this archive under the [MIT License](LICENSE).

## [0.7.1] - 2018-07-03
### Changed
- Stop rewriting of internal topics for sys-users to keep context (e.g. realmId).

## [0.7.0] - 2018-06-29
### Changed
- Rewriting of topic from internal to external form on deliver will be done by
  the new adapter plugin ([#5])
- Adjustment of webhooks to comply to url structure of new platform service ([#7]).

[#5]: https://github.com/RealMQ/broker/issues/5
[#7]: https://github.com/RealMQ/broker/issues/7

## [0.6.0] - 2018-05-01
### Changed
- Rename gfcc to realmq. ([#1])

[#1]: https://github.com/realmq/broker/issues/1

## [0.5.0] - 2018-04-23
### Changed
- Reenable `on_deliver` webhook for topic rewriting ([#gfcc-2])
- Allow sys users to subscribe on `$RMQ` topics

[#gfcc-2]: https://gitlab.com/gfcc/broker-adapter/issues/2

## [0.4.0]
### Added
- Configuration options for TLS connections ([#gfcc/green-field-49])

### Changed
- Upgraded VerneMQ to version 1.3.1 ([#gfcc-1])

### Fixed
- Generation of vernemq process environment variables

[#gfcc-1]: https://gitlab.com/gfcc/broker/issues/1
[#gfcc/green-field-49]: https://gitlab.com/gfcc/green-field/issues/49

## [0.3.0] - 2017-06-02
### Changed
- Merge with base image
- Upgrade to VerneMQ version 1.1.0
- Remove `on_deliver` hook due performance issues

## [0.2.1] - 2017-03-06
### Changed
- Switch to base image version 0.2.2

## [0.2.0] - 2016-12-23
### Changed
- Use build in webhooks to connect to broker-adapter instead of lua plugins

## [0.1.0] - 2016-11-30
### Added
- Initial setup


[Unreleased]: https://github.com/realmq/broker/compare/0.7.1...HEAD
[0.7.1]: https://github.com/realmq/broker/compare/0.7.0...0.7.1
[0.7.0]: https://github.com/realmq/broker/compare/0.6.0...0.7.0
[0.6.0]: https://github.com/realmq/broker/compare/0.5.0...0.6.0
[0.5.0]: https://github.com/realmq/broker/compare/0.4.0...0.5.0
[0.4.0]: https://github.com/realmq/broker/compare/0.3.0...0.4.0
[0.3.0]: https://github.com/realmq/broker/compare/0.2.1...0.3.0
[0.2.1]: https://github.com/realmq/broker/compare/0.2.0...0.2.1
[0.2.0]: https://github.com/realmq/broker/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/realmq/broker/compare/6b8862c5...0.1.0
