#!/bin/bash

set -e

source dev-container-features-test-lib

check "graphviz" dot -V

reportResults