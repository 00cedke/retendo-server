#!/usr/bin/env bash

print_blue() {
    echo -e "\033[1;36m$1\033[0m"
}

print_red() {
    echo -e "\033[0;31m$1\033[0m"
}

set -eu

env_dir="./env"

if [ -d "$env_dir" ]; then
    for file in "$env_dir"/*.local.env; do
        if [ -f "$file" ]; then
            print_blue "Deleting all environments.."
            rm "$file"
        fi
    done
else
    print_red "The $env_dir directory does not exist."
fi

# -- Credits: MatthewL246 --
generate_password() {
    length=$1
    head /dev/urandom | LC_ALL=C tr -dc "a-zA-Z0-9" | head -c "$length"
}

generate_hex() {
    length=$1
    head /dev/urandom | LC_ALL=C tr -dc "A-F0-9" | head -c "$length"
}

echo "Setting up local environment variables.."

account_aes_key=$(generate_hex 64)
echo "ACT_CONFIG_AES_KEY=$account_aes_key" >> ./env/account.local.env

minio_secret_key=$(generate_password 32)
echo "MINIO_ROOT_PASSWORD=$minio_secret_key" >> ./env/minio.local.env
echo "ACT_CONFIG_S3_ACCESS_SECRET=$minio_secret_key" >> ./env/account.local.env

echo "Successfully set up all environment."