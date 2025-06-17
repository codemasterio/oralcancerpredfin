# Use Python 3.10 to support scikit-learn 1.7.0
FROM python:3.10.13-slim

WORKDIR /app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=10000 \
    PYTHONPATH="${PYTHONPATH}:/app" \
    PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install pip and setuptools with specific versions
RUN python -m pip install --no-cache-dir pip==23.0.1 && \
    pip install --no-cache-dir setuptools==65.5.0 wheel==0.38.4

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install numpy first with specific version
RUN pip install --no-cache-dir numpy==1.23.5

# Install other core dependencies
RUN pip install --no-cache-dir scipy==1.10.1 && \
    pip install --no-cache-dir scikit-learn==1.7.0 && \
    pip install --no-cache-dir joblib==1.2.0

# Install remaining requirements
RUN pip install --no-cache-dir -r requirements.txt

# Verify installations with detailed output
RUN python -c "\
import sys; \
print(f'Python: {sys.version}'); \
import numpy; print(f'Numpy: {numpy.__version__}, Path: {numpy.__file__}'); \
import sklearn; print(f'Scikit-learn: {sklearn.__version__}'); \
import joblib; print(f'Joblib: {joblib.__version__}'); \
import sys; print(f'Python path: {sys.path}'); \
import numpy.core; print(f'Numpy core path: {numpy.core.__file__}')"

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
