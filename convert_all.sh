#!/bin/bash

set -euo pipefail

# Directory containing the Python script
WORKSPACE_DIR="/workspace/tensorrtx/yolov8"

# Check if directory exists
if [ ! -d "$WORKSPACE_DIR" ]; then
    echo "Error: Directory $WORKSPACE_DIR does not exist"
    exit 1
fi

# Change to the working directory
cd "$WORKSPACE_DIR"

# Check for .pt files
if [ -z "$(ls -A /workspace/input/*.pt 2>/dev/null)" ]; then
    echo "No .pt files found in /workspace/input/"
    exit 1
fi

echo "Found $(ls -1 /workspace/input/*.pt | wc -l) .pt files in /workspace/input/"
# Process each .pt file
for input_file in /workspace/input/*.pt; do
    # Skip if no files found
    [ -e "$input_file" ] || continue
    
    # Extract filename without path and extension
    base_name=$(basename "$input_file" .pt)
    echo "Processing $base_name"

    # Determine task type from filename
    case "$base_name" in
        *-cls) task="cls" ;;
        *-seg) task="seg" ;;
        *-pose) task="pose" ;;
        *-obb) task="obb" ;;
        *) task="detect" ;;  # Default to "detect" if no match
    esac

    # Create output path
    output_file="/output/${base_name}.wts"
    echo "Output will be saved to $output_file"

    # Run the conversion script
    echo "Starting model conversion..."

    # Run conversion
    python3 gen_wts.py --weights "$input_file" --output "$output_file" -t "$task"

    # Check if conversion was successful
    if [ $? -eq 0 ]; then
        echo "Conversion completed successfully"
    else
        echo "Error: Conversion failed"
        exit 1
    fi
done


echo "All conversions finished"
