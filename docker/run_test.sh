#!/usr/bin/env bash

interactive=false
while getopts i option; do
  case "${option}" in
    i) interactive=true;;
  esac
done

if [ $interactive = true ]
  then
    docker compose -p exhibits-test -f compose.test.yaml run webapp bash
  else
    docker compose -p exhibits-test -f compose.test.yaml run webapp bundle exec rspec
fi
docker compose -p exhibits-test -f compose.test.yaml down --remove-orphans
