
# Aqua Security MicroScanner Orb for CircleCi

    Development Status
    This Orb is in development stage and therefore not available in a production Orb repository. You can use the following development repository link: `aquasecurity/microscanner@dev:0.0.1` for testing.

## What is the MicroScanner Orb?

Aqua Security's MicroScanner enables you check your container images for vulnerabilities. If your image has any known high-severity issue, MicroScanner can fail the image build, making it easy to include as a step in your CI/CD pipeline.

The MicroScanner itself is a small, easy to implement container vulnerabilty scanning tool. It has been embedded in the MicroScanner Orb to be called upon during more complex workflows. The MicroScanner has two modes: community and enterprise. This Orb allows for both modes. When used with a communitry mode scanning token as described on the MicroScanner GitHub site token holders may run 100 scans a month  When an Enterprise Aqua Console is specified, the MicroScanner will utilize a more granular, configurable scan policy.

> Note: The freely-available Community Edition is aimed at individual developers and open source projects who may not have control over the full CI/CD pipeline. The <a href="https://www.aquasec.com/use-cases/continuous-image-assurance/">Aqua Security commercial solution</a> is designed to be hooked into your CI/CD pipeline after the image build is complete, and/or to scan images from a public or private container registry.

> Another note: this freely-available Community Edition of MicroScanner scans for vulnerabilities in the image's installed packages. Aqua's commercial customers have access to [additional Enterprise Edition scanning features](#aqua-security-edition-comparison), such as scanning with a customized vulnerability policy, vulnerable files, PII and other sensitive data included in a container image.

The MicroScanner Orb is an easy way to get started creating free, automated vulnerability assessment reports. These reports are posted to CircleCi's build artifact area.


## How to use the Aqua MicroScanner Orb in your config.yml

Register for a MicroScanner token as described on the MicroScanner GitHub page. https://microscanner.aquasec.com/signup

### Create a context in the CircleCi portal and assign the required variables

Navigate to Org Settings > Context and create a context

<p align="left">
  <img alt="Create a context" src="https://github.com/aquasecurity/circleci-orb-microscanner/blob/master/images/context1.png">
</p>

Within your new context create an environment variable named "AQUA_TOKEN"

<p align="left">
  <img alt="Add AQUA_TOKEN env var" src="https://github.com/aquasecurity/circleci-orb-microscanner/blob/master/images/contextEnvVar.png">
</p>

### Add required configuration to your build configuration

The following `.circleci/config.yml` is an example of a docker build configuration based on https://circleci.com/docs/2.0/building-docker-images/

```bash
# CircleCI build config example for implementation of the Aqua Security MicroScanner
# https://github.com/aquasecurity/microscanner

version: 2.1

orbs:
  microscanner: aquasecurity/microscanner@dev:0.0.1

jobs:
  docker-build:
    executor: microscanner/default
    steps:
      - checkout
      - run: docker build -t circleci/node:latest .

workflows:
  scan-image:
    jobs:
      - docker-build
      - microscanner/scan-image:
          requires:
            - docker-build
          context: microscanner
          image: circleci/node:latest

```

Add the first 2 lines of the following example to the beginning of 
your `.circleci/config.yml` and set the CircleCI `version` to the minimum version `2.1`.

```shell
orbs:
  microscanner: aquasecurity/microscanner@dev:0.0.1
 ...
```

Then add a CircleCi executor.

```shell
 ...
jobs:
  docker-build:
    executor: microscanner/default
 ...
```

The final step is to add a workflow that triggers the vulnerability scan.

```shell
 ...
workflows:
  scan-image:
    jobs:
      - docker-build
      - microscanner/scan-image:
          requires: 
            - docker-build
          context: microscanner
          image: circleci/node:latest
```




##### nexus-orb/install
This will install groovy and the Nexus client into your build system. You only need to run
this once per build even if you publish multiple artifacts.

##### nexus-orb/archive
This will upload your artifacts to Nexus Repository Manager.
* **filename**: path to the file to publish. This is typically the same value as the `path` used in
the `store_artifacts` step in the code example above.
* **attributes**: List of component and asset attributes. Component attributes are prefixed with `-C` and asset attributes
 with `-A`. This is passed directly to Nexus Repository Manger so many additional 
 attributes to the ones used in the example above can be used as well.

#### CircleCi Context support
`username`, `password`, and possibly `serverurl` should not be hardcoded in your build files.
If you create a CircleCi context with the environment variables below you can remove them from
your `.circleci/config.yml` file.
* **username:** `NEXUS_RM_USERNAME`
* **password:** `NEXUS_RM_PASSWORD`
* **serverurl:** `NEXUS_RM_SERVERURL`