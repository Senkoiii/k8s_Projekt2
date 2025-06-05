#!/bin/bash
set -e

echo "⏳ Waiting for projekt2-mongo-0.projekt2-mongodb to accept connections..."

success=0
for i in {1..30}; do
  if mongosh --host projekt2-mongo-0.projekt2-mongodb --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
    echo "✅ projekt2-mongo-0.projekt2-mongodb is ready"
    success=1
    break
  else
    echo "❌ Attempt $i failed. Retrying..."
    sleep 2
  fi
done

if [[ $success -ne 1 ]]; then
  echo "❌ projekt2-mongo-0.projekt2-mongodb did not become ready in time."
  exit 1
fi

echo "⏳ Waiting for projekt2-mongo-1.projekt2-mongodb and projekt2-mongo-2.projekt2-mongodb to accept connections..."

for host in projekt2-mongo-1.projekt2-mongodb projekt2-mongo-2.projekt2-mongodb; do
  echo "⏳ Waiting for $host to accept unauthenticated connections..."
  for i in {1..30}; do
    if mongosh --host $host --eval "db.runCommand({ ping: 1 })" > /dev/null 2>&1; then
      echo "✅ $host is reachable"
      break
    else
      echo "❌ $host not ready yet. Retrying..."
      sleep 2
    fi
  done
done

echo "⚙️ Initiating replica set..."

mongosh --host projekt2-mongo-0.projekt2-mongodb <<EOF
rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "projekt2-mongo-0.projekt2-mongodb:27017" },
    { _id: 1, host: "projekt2-mongo-1.projekt2-mongodb:27017" },
    { _id: 2, host: "projekt2-mongo-2.projekt2-mongodb:27017" }
  ]
});
EOF
