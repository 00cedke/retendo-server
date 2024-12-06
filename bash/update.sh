#!/usr/bin/env bash

print_blue() {
    echo -e "\033[1;36m$1\033[0m"
}

git pull

print_blue "Successfully updated the repository."