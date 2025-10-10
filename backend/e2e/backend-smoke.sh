# if curl -s ${BACKEND_URL}/hash/test | grep "098f6bcd4621d373cade4e832627b4f6"
# then
#     echo "Success!"
#     exit 0
# else
#     echo "Correct hash not found!"
#     exit 1
# fi

#!/bin/bash
set -e

echo "Running smoke test for ${BACKEND_URL}/hash/test"

# Fetch response
RESPONSE=$(curl -s "${BACKEND_URL}/hash/test")
# Extract hash value (works whether it's JSON or plain text)
ACTUAL_HASH=$(echo "$RESPONSE" | grep -Eo '[a-f0-9]{32}' | head -n1)

# Expected hash (update this to match your Postman output)
EXPECTED_HASH="098f6bcd4621d373cade4e832627b4f6"

# Compare
if [ "$ACTUAL_HASH" = "$EXPECTED_HASH" ]; then
  echo "✅ Correct hash found: $ACTUAL_HASH"
  exit 0
else
  echo "❌ Correct hash not found!"
  echo "Expected: $EXPECTED_HASH"
  echo "Got:      $ACTUAL_HASH"
  exit 1
fi
