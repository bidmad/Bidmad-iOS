#!/bin/bash

# Function to extract Podfile content between target and end
extract_podfile_content() {
    # Extract content between 'target' and 'end' lines
    sed -n '/^target/,/^end$/p' "Podfile" | \
    # Remove the target and end lines themselves
    sed '1d' | sed '$d' | \
    # Remove comment lines
    grep -v "^[[:space:]]*#" | \
    # Remove empty lines
    grep -v "^[[:space:]]*$"
}

# Function to update README file
update_readme() {
    local readme_file=$1
    local start_marker="# 사용하시는 최소 iOS 버전을 아래 라인에 기입해주세요"
    local end_marker="end"
    
    # Create a temporary file
    local temp_file=$(mktemp)
    
    # Extract content before the Podfile section
    sed -n "1,/$start_marker/p" "$readme_file" > "$temp_file"
    
    # Add platform line
    echo 'platform :ios, "12.0"' >> "$temp_file"
    echo "" >> "$temp_file"
    
    # Add target line
    echo 'target "BidmadSDKTest" do' >> "$temp_file"
    echo "" >> "$temp_file"
    
    # Add pod dependencies
    extract_podfile_content >> "$temp_file"
    
    # Add end
    echo "" >> "$temp_file"
    echo "end" >> "$temp_file"
    
    # Add remaining content after the Podfile section
    sed -n "/$end_marker/,\$p" "$readme_file" | sed '1d' >> "$temp_file"
    
    # Replace original file with updated content
    mv "$temp_file" "$readme_file"
}

# Function to update English README file
update_readme_en() {
    local readme_file=$1
    local start_marker="# Please set the minimum iOS version here"
    local end_marker="end"
    
    # Create a temporary file
    local temp_file=$(mktemp)
    
    # Extract content before the Podfile section
    sed -n "1,/$start_marker/p" "$readme_file" > "$temp_file"
    
    # Add platform line
    echo 'platform :ios, "12.0"' >> "$temp_file"
    echo "" >> "$temp_file"
    
    # Add target line
    echo 'target "BidmadSDKTest" do' >> "$temp_file"
    echo "" >> "$temp_file"
    
    # Add pod dependencies
    extract_podfile_content >> "$temp_file"
    
    # Add end and post_install
    echo "" >> "$temp_file"
    echo "end" >> "$temp_file"
    
    # Add remaining content after the Podfile section
    sed -n "/$end_marker/,\$p" "$readme_file" | sed '1d' >> "$temp_file"
    
    # Replace original file with updated content
    mv "$temp_file" "$readme_file"
}

# Check if Podfile exists
if [ ! -f "Podfile" ]; then
    echo "Error: Podfile not found in current directory"
    exit 1
fi

# Check if README files exist
if [ ! -f "README.md" ] || [ ! -f "README[EN].md" ]; then
    echo "Error: One or both README files not found"
    exit 1
fi

# Create backups of README files
cp "README.md" "README.md.backup"
cp "README[EN].md" "README[EN].md.backup"

echo "Updating README.md..."
update_readme "README.md"

echo "Updating README[EN].md..."
update_readme_en "README[EN].md"

echo "README files have been updated. Backups have been created at:"
echo "README.md.backup"
echo "README[EN].md.backup"
echo ""
echo "Please review the changes in both README files."