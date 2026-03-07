#!/bin/bash


ACTIVE=$(docker exec nginx grep "server green" /etc/nginx/upstream.conf)

if [ -n "$ACTIVE" ]; then
	echo "Green is active. Switching to blue."
	ln -sf upstream_blue.conf nginx/upstream.conf

	#sed -i 's/#server blue:5000;/server blue:5000;/g' nginx/nginx.conf
	#sed -i 's/server green:5000;/#server green:5000;/g' nginx/nginx.conf
else
	echo "Blue is active. Switching to green."
	ln -sf upstream_green.conf nginx/upstream.conf
	#sed -i 's/#server green:5000;/server green:5000;/g' nginx/nginx.conf
	#sed -i 's/server blue:5000;/#server blue:5000;/g' nginx/nginx.conf
fi

docker exec nginx nginx -s reload

