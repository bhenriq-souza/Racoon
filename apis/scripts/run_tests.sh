#!/bin/bash

cd apis

echo "Working folder is" $(pwd)

echo "Start running tests for APIs..."

# for dir in functions/*; do
#     if  ! [ -d "$dir/tests" ]; then
#         echo "$dir API doesn't have any test. Skipping..."
#         continue
#     fi

#     echo "Running tests for $dir API..."

#     coverage run -m pytest
# done

coverage run -m pytest

echo "Finished running tests for APIs."

echo "Running reports"

coverage report -m

coverage html

cd ../