# if curl -s ${BACKEND_URL}/hash/test | grep "ACTUAL_HASH_FROM_RESPONSE"
# then
#     echo "Success!"
#     exit 0
# else
#     echo "Correct hash not found!"
#     exit 1
# fi

#!/bin/bash
set -e

# Backend URL (injected by CI)
echo "Checking backend at: ${BACKEND_URL}/hash/test"

# Make request and capture response
RESPONSE=$(curl -s "${BACKEND_URL}/hash/test")

# Print raw response for debugging
echo "Response: $RESPONSE"

# Try to extract hash value using jq if available, otherwise fallback to grep
if command -v jq &> /dev/null; then
  ACTUAL_HASH=$(echo "$RESPONSE" | jq -r '.hash')
else
  # Fallback: extract first 32-char hex sequence
  ACTUAL_HASH=$(echo "$RESPONSE" | grep -Eo "[a-f0-9]{32}" | head -n1)
fi

# If still empty, fail immediately
if [ -z "$ACTUAL_HASH" ]; then
  echo "❌ No hash found in response!"
  exit 1
fi

echo "🔹 Extracted hash: $ACTUAL_HASH"

# Define the expected hash here (update this value as needed)
EXPECTED_HASH="098f6bcd4621d373cade4e832627b4f6"

# Compare
if [ "$ACTUAL_HASH" = "$EXPECTED_HASH" ]; then
  echo "✅ Correct hash found!"
  exit 0
else
  echo "❌ Hash mismatch!"
  echo "Expected: $EXPECTED_HASH"
  echo "Got:      $ACTUAL_HASH"
  exit 1
fi
