#!/bin/bash

# Create necessary directories
mkdir -p ~/.streamlit/

# Create config file
cat > ~/.streamlit/config.toml << EOL
[server]
headless = true
port = $PORT
enableCORS = false
enableXsrfProtection = false
enableWebsocketCompression = false

[runner]
fixMatplotlib = false

[logger]
level = 'debug'

[browser]
gatherUsageStats = false
serverAddress = '0.0.0.0'
serverFileWatcherType = 'none'

[client]
showErrorDetails = true

[server]
maxUploadSize = 50
enableCORS = false
EOL

# Install requirements
pip install -r requirements.txt

# Debug information
echo "=== Environment Variables ==="
printenv | sort
echo "\n=== Current Directory ==="
pwd
ls -la

# Debug Python environment
echo "\n=== Python Environment ==="
python --version
pip list
