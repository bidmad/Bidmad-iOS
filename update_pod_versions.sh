#!/bin/bash

# Function to get latest version from pod trunk info
get_latest_version() {
    local pod_name=$1
    # Get all versions and sort them to get the latest
    local latest_version=$(pod trunk info "$pod_name" 2>/dev/null | \
        grep -A 100 "Versions:" | \
        grep -o '[0-9]\+\.[0-9]\+\(\.[0-9]\+\)*' | \
        sort -V | \
        tail -n 1)
    
    if [ -z "$latest_version" ]; then
        echo "Error: Could not get version info for $pod_name"
        return 1
    fi
    
    echo "$latest_version"
}

# Function to update dependency version in Podfile
update_dependency_version() {
    local pod_name=$1
    local new_version=$2
    
    # Extract current version exactly as it appears in the Podfile
    # Handle both pod "Name", "version" and pod "Name/Subspec", "version" formats
    local current_version=$(grep -o "pod \"$pod_name\", \"[^\"]*\"" "Podfile" | \
        sed "s/pod \"$pod_name\", \"//" | \
        sed "s/\"//")
    
    if [ -z "$current_version" ]; then
        echo "Error: Could not find current version for $pod_name"
        return 1
    fi
    
    # For adapters, we need to handle the version format correctly
    if [[ "$pod_name" == *"Adapter"* ]]; then
        # Extract the base version (up to the first .11.0 or .11.1)
        local base_version=$(echo "$current_version" | sed -E 's/([0-9]+\.[0-9]+\.[0-9]+(\.[0-9]+)?)\.[0-9]+\.[0-9]+$/\1/')
        local suffix=$(echo "$current_version" | grep -o '\.[0-9]\+\.[0-9]\+$')
        
        # Only append suffix if the new version doesn't already have it
        if [ ! -z "$suffix" ] && [[ ! "$new_version" =~ \.[0-9]+\.[0-9]+$ ]]; then
            new_version="${new_version}${suffix}"
        fi
    fi
    
    if [ "$current_version" != "$new_version" ]; then
        echo "Updating $pod_name from $current_version to $new_version"
        sed -i '' "s/pod \"$pod_name\", \"$current_version\"/pod \"$pod_name\", \"$new_version\"/g" "Podfile"
    else
        echo "$pod_name is already at latest version $current_version"
    fi
}

# Function to extract dependencies from Podfile
extract_dependencies() {
    # Extract all pod lines and get the pod names
    # This handles both simple dependencies and subspecs
    # Skip lines that are commented out or empty
    grep -v "^[[:space:]]*#" "Podfile" | \
    grep -o "pod \"[^\"]*\"" | \
    sed "s/pod \"//" | \
    sed "s/\"//" | \
    grep -v "^[[:space:]]*$" | \
    grep -v "Flutter"  # Exclude Flutter dependency if present
}

# Check if Podfile exists
if [ ! -f "Podfile" ]; then
    echo "Error: Podfile not found in current directory"
    exit 1
fi

echo "Extracting dependencies from Podfile..."
dependencies=($(extract_dependencies))

if [ ${#dependencies[@]} -eq 0 ]; then
    echo "Error: No dependencies found in Podfile"
    exit 1
fi

echo "Found ${#dependencies[@]} dependencies to check"
echo "----------------------------------------"

# Create a backup of the Podfile
cp "Podfile" "Podfile.backup"

# Track if any updates were made
updates_made=false

# Check and update each dependency
for dep in "${dependencies[@]}"; do
    echo "Checking $dep..."
    # For subspecs, use the main pod name for version check
    search_name=$(echo "$dep" | cut -d'/' -f1)
    new_version=$(get_latest_version "$search_name")
    
    if [ $? -eq 0 ] && [ ! -z "$new_version" ]; then
        if update_dependency_version "$dep" "$new_version"; then
            updates_made=true
        fi
    else
        echo "Warning: Skipping $dep due to error getting version info"
    fi
    echo "----------------------------------------"
done

if [ "$updates_made" = true ]; then
    echo "Dependencies have been updated. A backup of the original Podfile has been created at:"
    echo "Podfile.backup"
    echo ""
    echo "Please review the changes and test the updated dependencies before committing."
    echo "After reviewing, you can run 'pod install' to update your dependencies."
else
    echo "All dependencies are already at their latest versions."
    # Remove backup if no updates were made
    rm "Podfile.backup"
fi 