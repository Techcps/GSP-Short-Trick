
export PROJECT_ID=$(gcloud config get-value project)

#!/bin/bash

BLUE='\033[0;32m'
GOLD='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Open text-bison:${NC}"
python -c "print('   https://console.cloud.google.com/vertex-ai/publishers/google/model-garden/text-bison?project=$PROJECT_ID')"
echo "CP, link 1"

echo "subscribe to techcps"

echo -e "${GOLD}Open owlvit-base-patch32:${NC}"
python -c "print('   https://console.cloud.google.com/vertex-ai/publishers/google/model-garden/owlvit-base-patch32?project=$PROJECT_ID')"
echo "CP, link 2"

echo "subscribe to techcps, https://www.youtube.com/@techcps"

echo -e "${BLUE}Open bert-base:${NC}"
python -c "print('   https://console.cloud.google.com/vertex-ai/publishers/google/model-garden/bert-base?project=$PROJECT_ID')"
echo "CP, link 3"

