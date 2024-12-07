#!/usr/bin/env bash

print_blue() {
    echo -e "\033[1;36m$1\033[0m"
}

print_red() {
    echo -e "\033[0;31m$1\033[0m"
}

run_verbose() {
    if [[ -n "$show_verbose" ]]; then
        "$@"
    else
        "$@" >/dev/null
    fi
}

print_blue "Resetting all submodules..."
run_verbose git submodule sync
run_verbose git submodule foreach "git reset --hard"
run_verbose git submodule foreach "git clean -fd"
run_verbose git submodule update --init --checkout
if [[ -n "$update_remote" ]]; then
    print_blue "Updating submodules from their remotes.."
    git submodule update --remote
fi

patch_count=0
error_count=0
for dir in "$git_base_dir/patches/"*; do
    if [[ -d "$dir" ]]; then
        subdir=$(basename "$dir")

        cd "$git_base_dir/repos/$subdir"

        for patch in "$git_base_dir/patches/$subdir"/*; do
            if [[ -n "$update_remote" ]]; then
                print_blue "Applying patch $patch..."
                if ! git apply --index "$patch"; then
                    print_red "Failed to apply patch $patch! Attempting 3-way merge..."
                    if ! git apply --3way "$patch"; then
                        print_red "There are merge conflicts with the patch that need to be resolved manually."
                    else
                        print_blue "Successfully applied the patch with a 3-way merge. Make sure to re-generate the patch."
                    fi
                    error_count=$((error_count + 1))
                fi
            else
                if_verbose "Applying patch $patch"
                git apply "$patch"
            fi
            patch_count=$((patch_count + 1))
        done
    fi
done

if [[ "$error_count" -gt 0 ]]; then
    print_red "Failed to apply $error_count patches out of $patch_count."
    exit 1
fi

print_blue "Successfully applied $patch_count patches."