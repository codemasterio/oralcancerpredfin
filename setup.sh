#!/bin/bash
mkdir -p ~/.streamlit/
echo "\
[server]\n\
headless = true\n\
port = $PORT\n\nenableCORS = false\n\n\n" > ~/.streamlit/config.toml
