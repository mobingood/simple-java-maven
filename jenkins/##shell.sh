##shell

#!/bin/bash

# Set variables
SOURCE_FILE="/path/to/source/file"
DESTINATION_DIR="/path/to/destination"

CLEANUP_DIR="/path/to/cleanup"
DAYS_OLD=7  # Files older than this will be deleted

APP_DIR="/path/to/application"
GIT_BRANCH="main"

echo "Starting the script..."

# 1. Copy file
echo "Copying file..."
cp "$SOURCE_FILE" "$DESTINATION_DIR" && echo "File copied successfully!"

# 2. Find and clean disk files
echo "Cleaning up old files..."
find "$CLEANUP_DIR" -type f -mtime +$DAYS_OLD -exec rm -f {} \;
echo "Cleanup complete!"

# 3. Deploy application
echo "Deploying application..."
cd "$APP_DIR" || { echo "Application directory not found!"; exit 1; }
git pull origin "$GIT_BRANCH" && echo "Git pull successful!"

# Restart application (adjust command based on your application type)
echo "Restarting application..."
pkill -f my_application || echo "No running process found."
nohup ./my_application > app.log 2>&1 &

echo "Deployment complete!"


Symbol	Meaning
$?	Exit status of the last executed command (0 = success, non-zero = failure).
$#	Number of positional parameters (arguments passed to the script).
$*	All arguments passed to the script as a single string.
$@	All arguments passed to the script as an array (each retains its identity).
$1, $2, ...	Positional parameters (first, second argument, etc.).
$$	Process ID (PID) of the current script.
$!	Process ID of the last background command.
$-	Current shell options.



#!/bin/bash

# Find all log files smaller than 10MB
find . -type f -name "log" -size -10M | while read file; do
    echo "Processing file: $file"

    # Search for 'error' and count occurrences
    count=$(grep -c "error" "$file")
    
    if [ "$count" -gt 0 ]; then
        echo "Found $count occurrences of 'error' in $file"

        # Show line numbers where 'error' occurs
        grep -n "error" "$file"

        # Replace 'error' with 'win' in the file
        sed -i 's/error/win/g' "$file"
        echo "Replaced 'error' with 'win' in $file"
    else
        echo "No 'error' found in $file"
    fi

    echo "---------------------------------"
done
