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

Add the following keys which can be set using the `.env` file or explicitly by the hosted environment (e.g. Heroku):

```
# GENERAL
JELLYFISH_MOCK_FOG                  = true

# AWS SPECIFIC
JELLYFISH_AWS_ACCESS_KEY_ID           = key
JELLYFISH_AWS_SECRET_ACCESS_KEY_ID    = secret

# AZURE SPECIFIC
JELLYFISH_AZURE_SUB_ID                = azure_subscription_id
JELLYFISH_AZURE_PEM_PATH              = azure_certificate.pem
JELLYFISH_AZURE_API_URL               = https://management.core.windows.net

# VMWARE SPECIFIC
JELLYFISH_VMWARE_USERNAME             = vmware_user
JELLYFISH_VMWARE_PASSWORD             = vmware_password
JELLYFISH_VMWARE_SERVER               = vmware_server
JELLYFISH_VMWARE_EXPECTED_PUBKEY_HASH = vmware_pubkey_hash


```


**Key Descriptions**:
- If `JELLYFISH_MOCK_FOG` is not set to `false`, Fog will simulate provisioning and retirement rather than actually interacting with the cloud service providers. All keys are required in mock mode, but they can specify dummy data.

- `JELLYFISH_AWS_ACCESS_KEY_ID` and `JELLYFISH_AWS_SECRET_ACCESS_KEY_ID` are the public and private keys used by Fog to authenticate to AWS when provisioning and retiring assets.

- `JELLYFISH_AZURE_SUB_ID` is the Azure subscription id used for provisioning

- `JELLYFISH_AZURE_PEM_PATH` is location of the client certificate pem file usd to authenticate with Azure. See [here](http://azure.microsoft.com/en-us/documentation/articles/cloud-services-python-how-to-use-service-management) for how to generate.

- `JELLYFISH_AZURE_API_URL` is the API endpoint used for Azure provisioning

- `JELLYFISH_VMWARE_USERNAME` is the vSphere user

- `JELLYFISH_VMWARE_PASSWORD` is the vSphere password

- `JELLYFISH_VMWARE_SERVER` is the vSphere server

- `JELLYFISH_VMWARE_EXPECTED_PUBKEY_HASH` is the public key hash of the vSphere environment. Can be obtained by passing a dummy value and checking error logs. See [here](https://gist.github.com/jedi4ever/1216529#file-gistfile1-txt-L77-L79) for details.

## License

See [LICENSE](https://github.com/projectjellyfish/jellyfish-fog/blob/master/LICENSE)


Copyright 2015 Booz Allen Hamilton
