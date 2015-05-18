# Jellyfish Fog

[![Code Climate](https://codeclimate.com/repos/555a0675695680378e0027e6/badges/43ed237afc55c67eb2ef/gpa.svg)](https://codeclimate.com/repos/555a0675695680378e0027e6/feed)
[![Test Coverage](https://codeclimate.com/repos/555a0675695680378e0027e6/badges/43ed237afc55c67eb2ef/coverage.svg)](https://codeclimate.com/repos/555a0675695680378e0027e6/coverage)

Adds infrastructure, database, and storage product types to [Project Jellyfish API](https://github.com/projectjellyfish/api), and enables their provisioning on cloud service providers ([AWS](http://aws.amazon.com), [Azure](http://azure.microsoft.com/en-us), [DigitalOcean](https://www.digitalocean.com) and [VMWare](https://www.vmware.com/products/vrealize-suite)) via the [Fog](http://fog.io) gem.

## Installation

### Setup Gemfile

Include `jellyfish-fog` from GitHub in parent Gemfile:
```
gem 'jellyfish-fog', git: 'git://github.com/projectjellyfish/jellyfish-fog.git
```

Or include it locally:
```
  gem 'jellyfish-fog', path: '../jellyfish-fog'
```

And run `bundle install`.

### Setup Env Vars

Add the following keys:

```
JELLYFISH_AWS_ACCESS_KEY_ID        = key
JELLYFISH_AWS_SECRET_ACCESS_KEY_ID = secret
JELLYFISH_MOCK_FOG                 = true
```

which can be set using the `.env` file or explicitly by the hosted environment (e.g. Heroku).

**Key Descriptions**:
- `JELLYFISH_AWS_ACCESS_KEY_ID` and `JELLYFISH_AWS_SECRET_ACCESS_KEY_ID` are used by Fog to authenticate to AWS when provisioning and retiring
assets.

- If `JELLYFISH_MOCK_FOG` is not set to `false`, Fog will simulate provisioning and retirement rather than actually interacting with AWS. The AWS keys are still required but their values do not matter.

## License

See [LICENSE](https://github.com/projectjellyfish/jellyfish-fog/blob/master/LICENSE)


Copyright 2015 Booz Allen Hamilton
