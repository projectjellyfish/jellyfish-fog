# Jellyfish Fog

Adds infrastructure, database, and storage product types to Jellyfish, and enables their provisioning on cloud service providers (AWS, Azure, DigitalOcean and VMWare) via the [Fog](http://fog.io) gem.

## Setup

Add the following keys to your ENV:

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

See LICENSE


Copyright 2015 Booz Allen Hamilton