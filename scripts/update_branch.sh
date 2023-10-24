#!/bin/bash

# Get input branch name from user
echo "Enter the name of the remote branch to pull changes from:"
read branch_name

# Specify the folder to exclude from the pull
exclude_folder="_env_vars"

# Temporarily move the folder to a backup location
mv $exclude_folder /tmp/$exclude_folder

# Pull changes from the remote branch, forcefully taking remote changes in case of conflicts
git fetch origin $branch_name:$branch_name
git reset --hard $branch_name

# Move the excluded folder back to its original location
mv /tmp/$exclude_folder .

echo "Changes from remote branch '$branch_name' pulled successfully except for '$exclude_folder'."
