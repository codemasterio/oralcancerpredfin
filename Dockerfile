# Use the latest Python 3.10 slim image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=10000 \
    PYTHONPATH="/app" \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install build dependencies
RUN python -m pip install --upgrade pip setuptools wheel

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Verify installations
RUN python -c "\
import sys; \
print(f'Python: {sys.version}'); \
import numpy; print(f'Numpy: {numpy.__version__}'); \
import sklearn; print(f'Scikit-learn: {sklearn.__version__}'); \
import joblib; print(f'Joblib: {joblib.__version__}'); \
import pandas; print(f'Pandas: {pandas.__version__}'); \
import PIL; print(f'Pillow: {PIL.__version__}')"

# Copy the rest of the application
COPY . .

# Create necessary directories
RUN mkdir -p ~/.streamlit/

# Set up Streamlit config
RUN echo "\
[server]\n\
headless = true\n\
port = $PORT\n\
enableCORS = false\n\
enableXsrfProtection = false\n\
[logger]\n\
level = "debug"\n\n" > ~/.streamlit/config.toml

# Expose the port the app runs on
EXPOSE $PORT

# Command to run the application
CMD ["streamlit", "run", "app.py", "--server.port=$PORT", "--server.address=0.0.0.0", "--logger.level=debug"]
