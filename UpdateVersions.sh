#!/bin/bash

# Prompt user for new versions
read -p "Enter new version for BidmadSDK: " BIDMADSDK_VERSION
read -p "Enter new version for OpenBiddingHelper: " OPENBIDDINGHELPER_VERSION
read -p "Enter new version for BidmadAdapterDynamic: " BIDMADADAPTERDYNAMIC_VERSION

# Update versions in files
sed -i.bak -E "s/(pod 'BidmadSDK', ')[^']+'/\1$BIDMADSDK_VERSION'/" Podfile README.md README[EN].md
sed -i.bak -E "s/(pod 'OpenBiddingHelper', ')[^']+'/\1$OPENBIDDINGHELPER_VERSION'/" Podfile README.md README[EN].md
sed -i.bak -E "s/(pod 'BidmadAdapterDynamic', ')[^']+'/\1$BIDMADADAPTERDYNAMIC_VERSION'/" Podfile README.md README[EN].md

# Remove backup files (optional)
rm -f Podfile.bak README.md.bak README[EN].md.bak

echo "Versions updated successfully!"

