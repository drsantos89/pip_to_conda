#!/bin/bash

# Print the path to the pip executable
echo "Pip path: $(which pip)"

# Print the name of the active environment
echo "Active environment: $(basename $CONDA_PREFIX)"

# Get the list of packages installed with pip in the conda environment
pip_packages=$(pip list --format=freeze | grep -v '^\-e' | cut -d = -f 1)

# Install each package with conda and uninstall the pip version if the installation succeeds
for package in $pip_packages; do
    # Print the current package being processed
    echo "Processing package: $package"

    # Try to install the package with conda
    if conda install -y $package; then
        # If the installation succeeds, print a message and uninstall the pip version of the package
        echo "Successfully installed with conda: $package"
        pip uninstall -y $package
        echo "Removed pip package: $package"
     else
        # If the installation fails, print an error message
        echo "Error: conda install failed for package: $package"
        pip uninstall -y $package
    fi
done