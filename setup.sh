#!/bin/bash
pip install -r requirements.txt
mkdir -p ~/.streamlit/
echo "\
[server]\n\
headless = true\n\
port = $PORT\n\
enableCORS = false\n\
\n" > ~/.streamlit/config.toml
