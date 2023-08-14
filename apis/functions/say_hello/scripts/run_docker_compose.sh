#!/bin/bash

cd functions/say_hello

docker-compose -f ./docker-compose.yaml up -d --build --force-recreate

cd ../
