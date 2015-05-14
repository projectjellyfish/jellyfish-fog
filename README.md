# Jellyfish Fog

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
AWS_ACCESS_KEY_ID        = key
AWS_SECRET_ACCESS_KEY_ID = secret
MOCK_FOG                 = true
```

which can be set using the `.env` file or explicitly by the hosted environment (e.g. Heroku).

**Key Descriptions**:
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY_ID` are used by Fog to authenticate to AWS when provisioning and retiring
assets.

- If `MOCK_FOG` is not set to `false`, Fog will simulate provisioning and retirement rather than actually interacting with AWS. The AWS keys are still required but their values do not matter.

## License

See [LICENSE](https://github.com/projectjellyfish/jellyfish-fog/blob/master/LICENSE)


Copyright 2015 Booz Allen Hamilton