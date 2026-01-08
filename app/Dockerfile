FROM python:3.11-slim

WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

EXPOSE 5000

# Run as non-root user for security
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

CMD ["python", "app.py"]
