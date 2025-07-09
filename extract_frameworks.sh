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

# Function to check if framework is dynamic
is_dynamic_framework() {
    local framework_path="$1"
    local binary_path="$framework_path/$(basename "$framework_path" .framework)"
    
    if [[ -f "$binary_path" ]]; then
        local file_type=$(file "$binary_path" 2>/dev/null)
        if [[ "$file_type" == *"dynamically linked shared library"* ]]; then
            return 0  # True - is dynamic
        fi
    fi
    return 1  # False - is static or unknown
}

# Function to check if framework is static
is_static_framework() {
    local framework_path="$1"
    local binary_path="$framework_path/$(basename "$framework_path" .framework)"
    
    if [[ -f "$binary_path" ]]; then
        local file_type=$(file "$binary_path" 2>/dev/null)
        if [[ "$file_type" == *"current ar archive"* ]]; then
            return 0  # True - is static
        fi
    fi
    return 1  # False - is dynamic or unknown
}

# Function to find and copy bundle files for static frameworks
copy_bundle_for_static_framework() {
    local framework_path="$1"
    local embedded_framework_path="$2"
    
    if ! is_static_framework "$framework_path"; then
        return 0  # Not a static framework, skip
    fi
    
    local framework_name=$(basename "$framework_path" .framework)
    local pod_name=""
    
    # Extract pod name from framework path
    # Example: Pods/Ads-Global/SDK/PAGAdSDK.xcframework/ios-arm64/PAGAdSDK.framework
    # We need to find the pod directory (Ads-Global in this case)
    local path_parts=($(echo "$framework_path" | tr '/' ' '))
    for i in "${!path_parts[@]}"; do
        if [[ "${path_parts[$i]}" == "Pods" && $((i+1)) -lt ${#path_parts[@]} ]]; then
            pod_name="${path_parts[$((i+1))]}"
            break
        fi
    done
    
    if [[ -z "$pod_name" ]]; then
        print_warning "Could not determine pod name for $framework_name" >&2
        return 1
    fi
    
    # Look for bundle in the pod directory and its subdirectories
    local bundle_found=false
    
    # First try direct path: Pods/PodName/FrameworkName.bundle
    local bundle_path="Pods/$pod_name/$framework_name.bundle"
    if [[ -d "$bundle_path" ]]; then
        bundle_found=true
    else
        # Search in subdirectories of the pod
        while IFS= read -r -d '' found_bundle; do
            if [[ "$found_bundle" == *"/$framework_name.bundle" ]]; then
                bundle_path="$found_bundle"
                bundle_found=true
                break
            fi
        done < <(find "Pods/$pod_name" -name "$framework_name.bundle" -type d -print0 2>/dev/null)
    fi
    
    if [[ "$bundle_found" == true ]]; then
        print_status "Found bundle for static framework $framework_name: $bundle_path" >&2
        
        # Create Resources directory in embedded framework
        local resources_dir="$embedded_framework_path/Resources"
        mkdir -p "$resources_dir"
        
        # Copy bundle to Resources directory
        cp -R "$bundle_path" "$resources_dir/"
        if [[ $? -eq 0 ]]; then
            print_success "Copied bundle to $resources_dir/$framework_name.bundle" >&2
        else
            print_error "Failed to copy bundle for $framework_name" >&2
            return 1
        fi
    else
        print_status "No bundle found for static framework $framework_name" >&2
    fi
    
    return 0
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

# Function to copy dynamic frameworks
copy_dynamic_frameworks() {
    local frameworks=("$@")
    local dynamic_frameworks_dir="UnrealEngineBuild/DynamicFrameworks"
    
    print_status "Checking for dynamic frameworks..."
    
    # Create DynamicFrameworks directory if it doesn't exist
    if [[ ! -d "$dynamic_frameworks_dir" ]]; then
        print_status "Creating $dynamic_frameworks_dir directory"
        mkdir -p "$dynamic_frameworks_dir"
    fi
    
    local dynamic_count=0
    
    for framework_path in "${frameworks[@]}"; do
        if is_dynamic_framework "$framework_path"; then
            local framework_name=$(basename "$framework_path" .framework)
            local target_path="$dynamic_frameworks_dir/$framework_name.framework"
            
            print_status "Found dynamic framework: $framework_name"
            
            # Remove existing copy if it exists
            if [[ -d "$target_path" ]]; then
                print_warning "Removing existing $target_path"
                rm -rf "$target_path"
            fi
            
            # Copy the dynamic framework
            cp -R "$framework_path" "$target_path"
            if [[ $? -eq 0 ]]; then
                print_success "Copied dynamic framework: $framework_name"
                ((dynamic_count++))
            else
                print_error "Failed to copy dynamic framework: $framework_name"
            fi
        fi
    done
    
    if [[ $dynamic_count -gt 0 ]]; then
        print_success "Copied $dynamic_count dynamic framework(s) to $dynamic_frameworks_dir"
    else
        print_status "No dynamic frameworks found"
    fi
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
    
    # Copy bundle files for static frameworks
    copy_bundle_for_static_framework "$source_framework" "$embedded_framework_name"
    
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
    
    # Copy dynamic frameworks first
    copy_dynamic_frameworks "${frameworks[@]}"
    echo ""
    
    # Process each framework for embedded framework creation
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