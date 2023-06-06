#!/bin/busybox sh
set -euo pipefail

# Make sure regctl can be invoked
regctl version

cat > compose.yaml <<EOF
---
services:
  regctl:
    image: ghcr.io/regclient/regctl:edge-alpine
EOF

composevalidate compose.yaml

composevalidate --platform linux/arm64 --architecture arm64 compose.yaml

echo "Image OK!"
