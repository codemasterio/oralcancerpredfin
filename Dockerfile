# Use Python 3.9 explicitly
FROM python:3.9.16-slim

WORKDIR /app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=10000 \
    PYTHONPATH="${PYTHONPATH}:/app"

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and setuptools first
RUN pip install --no-cache-dir --upgrade pip==23.0.1 setuptools==65.5.0 wheel==0.38.4

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies with explicit versions
RUN python -m pip install --no-cache-dir numpy==1.23.5 && \
    python -m pip install --no-cache-dir -r requirements.txt

# Verify numpy installation
RUN python -c "import numpy; print(f'Numpy version: {numpy.__version__}')"

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
