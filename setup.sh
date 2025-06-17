#!/bin/bash

# Create necessary directories
mkdir -p ~/.streamlit/

# Create config file
echo "\
[server]\n\
headless = true\n\
port = $PORT\n\
enableCORS = false\n\n\n" > ~/.streamlit/config.toml

# Install requirements
pip install -r requirements.txt
