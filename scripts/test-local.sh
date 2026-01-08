#!/bin/bash

# Test script for local development

echo "================================================"
echo "Testing AKS Production Microservices"
echo "================================================"

BASE_URL="http://localhost:5000"

echo -e "\n1. Testing root endpoint (/):"
curl -s $BASE_URL/ | python3 -m json.tool

echo -e "\n\n2. Testing health endpoint (/health):"
curl -s $BASE_URL/health | python3 -m json.tool

echo -e "\n\n3. Testing info endpoint (/api/info):"
curl -s $BASE_URL/api/info | python3 -m json.tool

echo -e "\n\n================================================"
echo "All tests completed!"
echo "================================================"
