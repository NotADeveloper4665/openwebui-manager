#!/bin/bash

# Configuration
LOG_FILE="$HOME/.open-webui/open-webui.log"
DATA_DIR="$HOME/.open-webui"

# Ensure data directory exists
mkdir -p "$DATA_DIR"

# Function to start openwebui
start_openwebui() {
    echo "Starting openwebui in the background..."
    # Redirecting both stdout and stderr to a log file for persistent tracking
    DATA_DIR=$DATA_DIR uvx --with beautifulsoup4 --python 3.11 open-webui@latest serve > "$LOG_FILE" 2>&1 &
    echo "openwebui started. Logs are being written to $LOG_FILE"
}

# Function to install openwebui
install_openwebui() {
    echo "Installing uv..."
    curl -fsSL https://astral.sh/uv/install.sh | bash
    echo "Installation attempt complete."
}

# Function to stop openwebui
stop_openwebui() {
    echo "Stopping openwebui..."
    pkill -f 'open-webui@latest serve'
    echo "openwebui stopped."
}

# Function to show status/logs
show_status() {
    if [ ! -f "$LOG_FILE" ]; then
        echo "No log file found at $LOG_FILE. Is the service running?"
        return
    fi

    echo "Displaying live logs (Press Ctrl+C to exit):"
    tail -f "$LOG_FILE"
}

# Function to remove openwebui
remove_openwebui() {
    echo "Removing openwebui data and logs..."
    rm -rf "$DATA_DIR"
    echo "openwebui removed."
}

# Main script logic
case "$1" in
    -start)
        start_openwebui
        ;;
    -install)
        install_openwebui
        ;;
    -stop)
        stop_openwebui
        ;;
    -status)
        show_status
        ;;
    -rm)
        remove_openwebui
        ;;
    *)
        echo "Usage: $0 { -start | -install | -stop | -status | -rm }"
        exit 1
        ;;
esac
