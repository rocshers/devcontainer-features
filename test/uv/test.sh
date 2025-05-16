#!/bin/bash

set -e

source dev-container-features-test-lib

check "uv" uv --version | grep uv

reportResults