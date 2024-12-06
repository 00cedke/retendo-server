#!/usr/bin/env bash

print_blue() {
    echo -e "\033[1;36m$1\033[0m"
}

git config --local submodule.recurse true

print_blue "Update the repository.."
./update.sh

print_blue "Set up environments.."
./environment.sh

print_blue "Pulling.."
docker compose pull

print_blue "Building.."
docker compose build

print "Starting.."
docker compose up -d --build

print_blue "The Retendo Network server has been started successfully."