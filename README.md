---
title: Oral Cancer Detection
emoji: 🦷
colorFrom: blue
colorTo: indigo
sdk: streamlit
sdk_version: "1.31.0"
app_file: app.py
pinned: false
---

# Oral Cancer Detection App

A Streamlit web application for detecting oral cancer from oral cavity images using machine learning.

## Features
- Upload and analyze oral cavity images
- View original and processed images
- Get prediction results with confidence scores
- Visualize feature importance

## How to Use
1. Click on "Browse files" or drag and drop an image
2. Click "Analyze Image" to process the image
3. View the prediction results and processed image

## Model
- Random Forest Classifier trained on oral cancer dataset
- Preprocessing includes grayscale conversion and resizing

## Requirements
- streamlit
- scikit-learn
- opencv-python-headless
- numpy
- Pillow

## Note

This application is for research and educational purposes only. It is not intended to replace professional medical advice, diagnosis, or treatment.
