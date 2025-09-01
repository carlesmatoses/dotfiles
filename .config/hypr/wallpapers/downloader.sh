
#!/bin/bash

# Path to the text file containing image URLs (one per line)
URL_FILE="urls.txt"

# Destination folder for downloaded images
DEST_FOLDER="./"

# Create the folder if it doesn't exist
mkdir -p "$DEST_FOLDER"

# Read each line (URL) from the file and download it
while IFS= read -r url; do
    if [ -n "$url" ]; then
        wget -q -P "$DEST_FOLDER" "$url"
        # Alternatively, using curl:
        # curl -s -O --output-dir "$DEST_FOLDER" "$url"
    fi
done < "$URL_FILE"

echo "Download complete. Images saved to $DEST_FOLDER"
