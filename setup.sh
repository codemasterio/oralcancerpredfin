#!/bin/bash

# Create necessary directories
mkdir -p ~/.streamlit/

# Create config file
echo "\
[server]
headless = true
port = $PORT
enableCORS = false
enableXsrfProtection = false

[logger]
level = 'debug'

[browser]
gatherUsageStats = false
" > ~/.streamlit/config.toml

# Install requirements
pip install -r requirements.txt

# Print environment variables for debugging
echo "PORT: $PORT"
echo "PYTHONPATH: $PYTHONPATH"

# List files in the current directory for debugging
ls -la
