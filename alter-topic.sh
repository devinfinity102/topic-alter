#!/bin/bash

TOPIC_FILE="alter-topic-defination.yaml"

# Check for yq
command -v yq >/dev/null || { echo "yq is required to parse YAML"; exit 1; }

# Loop through topics
yq e '.topics[]' "$TOPIC_FILE" | yq -e '.topics[] | [.name, .partitions ] | @tsv' "$TOPIC_FILE" | while IFS=$'\t' read -r NAME PARTITIONS; do
  echo "Alter topic: $NAME"
  /etc/confluent-7.9.0/bin/kafka-topics --alter --bootstrap-server localhost:9092 \
    --partitions "$PARTITIONS" \
    --topic "$NAME"
done
