#!/usr/bin/env bash


file_url="https://testfileorg.netwet.net/500MB-CZIPtestfile.org.zip"

# Assign a value to this variable with the path of the spinning.sh script
spin_script_path="/home/bob/spinning.sh"

start_spinner() {
    echo "Beginning the Package Download..."
    # Add a source declaration below to source the spin_script_path while and send it to the background.
    source "${spin_script_path}" &
    spin_pid=$!
}

# Function to download the file
download_file() {
    wget -q "${file_url}" -O large_file
}

# Function to stop the spinner
stop_spinner() {
# Terminate the spin_pid below.
    kill "${spin_pid}"
    echo "Download complete!"
}

# Call the start_spinner function below this line.
start_spinner
download_file
stop_spinner



