#!/bin/bash

# Define the command for cleaning up unused Docker resources
# 'docker system prune' removes all stopped containers, unused networks,
# dangling images, and build cache.
# The -a flag also removes all unused images (not just dangling ones).
# The -f flag forces the removal without a confirmation prompt.

CLEANUP_COMMAND="docker system prune -a -f"

echo "Attempting to clear Docker cache and unused resources..."

# Execute the cleanup command
$CLEANUP_COMMAND

# Check the exit status of the command
if [ $? -eq 0 ]; then
    echo "Docker cleanup successful."
else
    echo "Docker cleanup failed or was interrupted."
fi