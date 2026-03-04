#!/bin/bash

echo "checking green container health..."

STATUS=$(docker inspect --format='{{.State.Health.Status}}' green)

if [ "$STATUS" != "healthy" ]; then
	echo "Green container is not healthy. Aborting deployment."
	exit 1
fi

echo "Green is healthy. Switching traffic..."

sed -i 's/server blue:5000;/#server blue:5000;/g' nginx/nginx.conf
sed -i 's/#server green:5000;/server green:5000;/g' nginx/nginx.conf

docker compose restart nginx

echo "Traffic switched to GREEN deployment"
