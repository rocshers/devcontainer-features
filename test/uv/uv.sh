#!/bin/bash

set -e

source dev-container-features-test-lib

check "uv" uv --version | grep 0.7.3

reportResults