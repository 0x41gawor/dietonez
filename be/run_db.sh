#!/bin/bash

docker run --name dietonez-db \
  -e POSTGRES_DB=dietonez_db \
  -e POSTGRES_USER=dietonez \
  -e POSTGRES_PASSWORD=dietonez123 \
  -v "$(pwd)/init.sql:/docker-entrypoint-initdb.d/init.sql:ro" \
  -p 5432:5432 \
  -d postgres:15