#!/bin/bash

set -e 

echo "LOG - Performing tests."

python -m unittest discover tests -v

echo "LOG - All tests successful."