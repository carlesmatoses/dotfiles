
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
        # Strip any query string/fragment so the saved filename is clean
        # (e.g. Reddit preview links end in "?width=...&s=<hash>")
        clean_url="${url%%#*}"
        clean_url="${clean_url%%\?*}"
        clean_name=$(basename "$clean_url")

        if [ ! -e "$DEST_FOLDER/$clean_name" ]; then
            wget -q -O "$DEST_FOLDER/$clean_name" "$url" || rm -f "$DEST_FOLDER/$clean_name"
        fi
    fi
done < "$URL_FILE"

echo "Download complete. Images saved to $DEST_FOLDER"
