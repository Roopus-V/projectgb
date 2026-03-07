#!/bin/bash


ACTIVE=$(docker exec nginx grep "#server blue" /etc/nginx/nginx.conf)

if [ -n "$ACTIVE" ]; then
	echo "Green is active. Switching to blue."
	sed -i 's/#server blue:5000;/server blue:5000;/g' nginx/nginx.conf
	sed -i 's/server green:5000;/#server green:5000;/g' nginx/nginx.conf
else
	echo "Blue is active. Switching to green."
	sed -i 's/#server green:5000;/server green:5000;/g' nginx/nginx.conf
	sed -i 's/server blue:5000;/#server blue:5000;/g' nginx/nginx.conf
fi

docker compose restart nginx

