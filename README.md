# platform-code-test

A live coding to test for potential platform engineers.

## Requirements

* [tfenv](https://github.com/tfutils/tfenv)

## Setup

AWS creds need to be setup outside of this repo, a simple way is to use env vars like so:

```BASH
# File w/Access Keys
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_REGION="eu-west-1"
```

Then you can source this file before running any commands.

## Usage

A simple [Makefile](Makefile) is provided for running some common commands:

```BASH
# Run terraform plan, runs against production by default
make tf-plan
# Run terraform apply
make tf-apply
# Run terraform cmds against the common env
make tf-plan ENV=common
make tf-apply ENV=common
```

## Environments

### Production

This is where the candidate will be working during the test, it should be destroyed and recreated between tests.

### Common

This contains resources that should persist between tests, will need to be applied before the production env
