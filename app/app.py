from flask import Flask, jsonify
import os
from datetime import datetime

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({
        "message": "AKS Production App Running!",
        "timestamp": datetime.now().isoformat(),
        "version": "v1.0.0",
        "status": "healthy"
    })

@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.now().isoformat()
    })

@app.route("/api/info")
def info():
    return jsonify({
        "application": "AKS Production Microservices",
        "environment": os.getenv("ENVIRONMENT", "development"),
        "pod": os.getenv("HOSTNAME", "localhost")
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
