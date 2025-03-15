#!/bin/bash

# Check if python3 is available in PATH
check_python() {
    if command -v python3 &> /dev/null; then
        echo "python3 is available"
        return 0
    else
        echo "Error: python3 must be available to proceed"
        return 1
    fi
}

# Discover and set up Homebrew [intended for local builds only]
discover_homebrew() {
    local brew_dirs=(
        "/home/linuxbrew/.linuxbrew"
        "$HOME/.linuxbrew"
        "/opt/homebrew"
        "/usr/local"
    )

    for dir in "${brew_dirs[@]}"; do
        if [[ -f "$dir/bin/brew" ]]; then
            BREW_HOME="$dir"
            echo "brew found in ${BREW_HOME}"
            eval "$("$BREW_HOME/bin/brew" shellenv)"
            return 0
        fi
    done

    echo "Error: Homebrew not found in standard locations. Please install it."
    return 1
}

# Find .venv [intended for local builds only] 

activate_venv() {
    local search_dirs=("$(pwd)" "$HOME")

    for basedir in "${search_dirs[@]}"; do
        local venv_dir="${basedir}/.venv"
        echo "Searching for .venv in ${basedir}"
        if [[ -d "${venv_dir}" ]]; then
            source "${venv_dir}/bin/activate"
            echo "Activated virtual environment at ${venv_dir}"
            return 0
        fi
    done

    echo "Warning: No Python virtual environment found. This script may fail if dependencies are not installed."
    return 0  # Not a critical failure
}

# Function to check and install missing requirements from requirements.txt [local builds and to ensure really installed in GH Actions]

check_and_install_requirements() {
    if [[ ! -f "requirements.txt" ]]; then
        echo "Warning: requirements.txt not found. Skipping package check."
        return 0
    fi

    echo "Checking required Python packages..."
    
    local missing_packages=()
    while read -r package; do
        if [[ -n "$package" && ! "$package" =~ ^# ]]; then  # Ignore comments and empty lines
            if ! python3 -c "import pkg_resources; pkg_resources.require('$package')" &> /dev/null; then
                missing_packages+=("$package")
            fi
        fi
    done < requirements.txt

    if [[ ${#missing_packages[@]} -eq 0 ]]; then
        echo "All required packages are installed."
        return 0
    else
        echo "Installing missing packages: ${missing_packages[*]}"
        pip install "${missing_packages[@]}"
        if [[ $? -ne 0 ]]; then
            echo "Error: Failed to install required packages."
            return 1
        fi
    fi
}

main() {
    check_python || exit 1
    discover_homebrew || exit 1
    activate_venv  # Virtual environment is optional, so no exit here
    check_and_install_requirements || exit 1

    echo "python3 found in $(which python3)"
    echo "Setup completed successfully."
    MAIN=cv-main
    source data/personal-settings.sh
}

# Run main function
main

