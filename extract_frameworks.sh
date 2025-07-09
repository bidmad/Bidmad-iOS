#!/bin/bash

# Script to extract framework files from Pods directory and create embedded frameworks
# Usage: ./extract_frameworks.sh [framework_name]
# If no framework name is provided, it will process all frameworks found

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to find framework files in Pods directory
find_frameworks() {
    local target_framework="$1"
    local frameworks_found=()
    
    # Find all .framework directories in ios-arm64 folders
    while IFS= read -r -d '' framework_path; do
        # Extract framework name from path
        framework_name=$(basename "$framework_path" .framework)
        
        # If a specific framework is requested, only process that one
        if [[ -n "$target_framework" && "$framework_name" != "$target_framework" ]]; then
            continue
        fi
        
        frameworks_found+=("$framework_path")
    done < <(find Pods -path "*/ios-arm64/*.framework" -type d -print0)
    
    # Return the array by printing each element on a separate line
    printf '%s\n' "${frameworks_found[@]}"
}

# Function to create embedded framework
create_embedded_framework() {
    local source_framework="$1"
    local framework_name=$(basename "$source_framework" .framework)
    local output_dir="UnrealEngineBuild"
    local embedded_framework_name="$output_dir/${framework_name}.embeddedframework"
    
    print_status "Creating embedded framework for $framework_name..." >&2
    
    # Create UnrealEngineBuild directory if it doesn't exist
    if [[ ! -d "$output_dir" ]]; then
        print_status "Creating $output_dir directory" >&2
        mkdir -p "$output_dir"
    fi
    
    # Remove existing embedded framework if it exists
    if [[ -d "$embedded_framework_name" ]]; then
        print_warning "Removing existing $embedded_framework_name directory" >&2
        rm -rf "$embedded_framework_name"
    fi
    
    # Create embedded framework directory
    mkdir -p "$embedded_framework_name"
    
    # Copy framework contents
    print_status "Copying framework contents..." >&2
    cp -R "$source_framework" "$embedded_framework_name/"
    if [[ $? -ne 0 ]]; then
        print_error "Failed to copy framework contents from $source_framework to $embedded_framework_name" >&2
        exit 2
    fi
    
    print_success "Created embedded framework: $embedded_framework_name" >&2
    echo "$embedded_framework_name"
}

# Function to zip embedded framework
zip_embedded_framework() {
    local embedded_framework="$1"
    local framework_name=$(basename "$embedded_framework" .embeddedframework)
    local zip_name="${framework_name}.embeddedframework.zip"
    local output_dir="UnrealEngineBuild"
    
    print_status "Creating zip file: $zip_name in $output_dir"
    
    # Create UnrealEngineBuild directory if it doesn't exist
    if [[ ! -d "$output_dir" ]]; then
        print_status "Creating $output_dir directory"
        mkdir -p "$output_dir"
    fi
    
    local zip_path="$output_dir/$zip_name"
    
    # Remove existing zip if it exists
    if [[ -f "$zip_path" ]]; then
        print_warning "Removing existing $zip_path"
        rm -f "$zip_path"
    fi
    
    # Create zip file in UnrealEngineBuild directory
    # Change to the output directory to create the zip with relative paths
    cd "$output_dir"
    zip -r "$zip_name" "$(basename "$embedded_framework")" > /dev/null
    cd - > /dev/null
    
    if [[ $? -eq 0 ]]; then
        print_success "Created zip file: $zip_path"
        echo "$zip_path"
    else
        print_error "Failed to create zip file: $zip_path"
        exit 3
    fi
}

# Main execution
main() {
    local target_framework="$1"
    
    print_status "Starting framework extraction process..."
    
    # Check if Pods directory exists
    if [[ ! -d "Pods" ]]; then
        print_error "Pods directory not found. Please run this script from the project root directory."
        exit 1
    fi
    
    # Clear UnrealEngineBuild folder if it exists
    if [[ -d "UnrealEngineBuild" ]]; then
        print_status "Clearing existing UnrealEngineBuild folder..."
        rm -rf "UnrealEngineBuild"
    fi
    
    # Find frameworks
    frameworks=()
    while IFS= read -r framework_path; do
        frameworks+=("$framework_path")
    done < <(find_frameworks "$target_framework")
    
    if [[ ${#frameworks[@]} -eq 0 ]]; then
        if [[ -n "$target_framework" ]]; then
            print_error "No framework found with name: $target_framework"
        else
            print_error "No frameworks found in Pods directory"
        fi
        exit 1
    fi
    
    print_status "Found ${#frameworks[@]} framework(s) to process"
    
    # Process each framework
    for framework_path in "${frameworks[@]}"; do
        framework_name=$(basename "$framework_path" .framework)
        print_status "Found framework: $framework_name at $framework_path"
        print_status "Processing framework: $framework_name"
        
        # Create embedded framework
        embedded_framework=$(create_embedded_framework "$framework_path")
        
        # Zip the embedded framework
        zip_file=$(zip_embedded_framework "$embedded_framework")
        
        print_success "Successfully processed $framework_name"
        print_status "Output files:"
        print_status "  - Embedded framework: $embedded_framework"
        print_status "  - Zip file: $zip_file"
        echo ""
        print_status "Finished processing $framework_name. Moving to next framework."
    done
    
    print_success "Framework extraction process completed!"
}

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 