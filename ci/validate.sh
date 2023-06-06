#!/bin/busybox sh
set -euo pipefail

# Make sure regctl can be invoked
regctl version

cat > /tmp/compose.yaml <<EOF
---
services:
  regctl:
    image: ghcr.io/regclient/regctl:edge-alpine
EOF

composevalidate /tmp/compose.yaml

composevalidate --platform linux/arm64 --architecture arm64 /tmp/compose.yaml

echo "Image OK!"
