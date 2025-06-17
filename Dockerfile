FROM python:3.9.16-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

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
enableXsrfProtection = false\n\n" > ~/.streamlit/config.toml

# Expose the port the app runs on
EXPOSE $PORT

# Command to run the application
CMD ["streamlit", "run", "app.py", "--server.port=$PORT", "--server.address=0.0.0.0"]
