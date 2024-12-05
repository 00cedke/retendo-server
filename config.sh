#!/usr/bin/env bash

print_blue() {
    echo -e "\033[1;36m$1\033[0m"
}

git config --local submodule.recurse true

./bash/environment.sh

docker compose pull
docker compose build
docker compose up -d --build

print_blue "The Retendo Network server has been started successfully."