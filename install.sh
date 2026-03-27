#!/bin/bash

# 1. Define Variables
TARGET_NAME="openwebui-manager"
INSTALL_PATH="/usr/local/bin/$TARGET_NAME"
SCRIPT_FILE="openwebui-manager.sh"

# 2. Create the Manager Script Content
cat << 'EOF' > "$SCRIPT_FILE"
#!/bin/bash

# Configuration
LOG_FILE="$HOME/.open-webui/open-webui.log"
DATA_DIR="$HOME/.open-webui"

# Ensure data directory exists
mkdir -p "$DATA_DIR"

start_openwebui() {
    echo "Starting openwebui in the background..."
    DATA_DIR=$DATA_DIR uvx --with beautifulsoup4 --python 3.11 open-webui@latest serve >> "$LOG_FILE" 2>&1 &
    echo "Service initiated. Use -status to view logs."
}

stop_openwebui() {
    echo "Stopping openwebui..."
    pkill -f 'open-webui@latest serve'
    echo "Service stopped."
}

show_status() {
    if [ ! -f "$LOG_FILE" ]; then
        echo "Log file not found at $LOG_FILE. Start the service first."
        return
    fi
    echo "--- Live Output (Ctrl+C to stop) ---"
    tail -f "$LOG_FILE"
}

remove_openwebui() {
    read -p "Confirm: Delete all data and logs in $DATA_DIR? (y/n) " conf
    if [[ $conf == "y" ]]; then
        rm -rf "$DATA_DIR"
        echo "Cleanup complete."
    fi
}

case "$1" in
    -start)  start_openwebui ;;
    -stop)   stop_openwebui ;;
    -status) show_status ;;
    -rm)     remove_openwebui ;;
    *)
        echo "Usage: $TARGET_NAME { -start | -stop | -status | -rm }"
        exit 1
        ;;
esac
EOF

# 3. Set Executable Permissions
chmod +x "$SCRIPT_FILE"

# 4. Install to System Path
echo "Moving $SCRIPT_FILE to $INSTALL_PATH..."
if [ -w "/usr/local/bin" ]; then
    mv "$SCRIPT_FILE" "$INSTALL_PATH"
else
    echo "Sudo privileges required to move to /usr/local/bin"
    sudo mv "$SCRIPT_FILE" "$INSTALL_PATH"
fi

echo "Success. You can now run '$TARGET_NAME -status' from any directory."
