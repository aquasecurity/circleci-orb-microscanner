###
### DO NOT USE THIS IMAGE IN PRODUCTION !!!
### The mercurial package that is downgraded is subject to https://security-tracker.debian.org/tracker/CVE-2017-17458
### This image is meant to be used only as a demonstration of the Aqua Security MicroScanner Orb.
###

FROM oraclelinux:7-slim

# ensure that the build agent doesn't override the entrypoint
LABEL com.circleci.preserve-entrypoint=true

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/sh"]