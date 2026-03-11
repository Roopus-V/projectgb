#!/bin/bash

echo "checking green container health..."
STATUS=$(docker inspect --format='{{.State.Health.Status}}' green)

if [ "$STATUS" != "healthy" ]; then
	echo "Green container is not healthy. Aborting deployment."
	exit 1
fi

echo "Green is healthy. Starting canary phase..."


#at 10%
ln -sf upstream_1.conf nginx/upstream.conf
docker exec nginx nginx -s reload
sleep 10
STATUS=$(docker inspect --format='{{.State.Health.Status}}' green)

if [ "$STATUS" != "healthy" ]; then
	echo "Green became unhealthy. Rolling back to BLUE."

	ln -sf upstream_0.conf nginx/upstream.conf
	docker exec nginx nginx -s reload

	exit 1
fi
echo "Green is healthy at 10%. Increasing to 30%..."


#At 30%
ln -sf upstream_3.conf nginx/upstream.conf
docker exec nginx nginx -s reload
sleep 10
STATUS=$(docker inspect --format='{{.State.Health.Status}}' green)

if [ "$STATUS" != "healthy" ]; then
	echo "Green became unhealthy. Rolling back to BLUE."

	ln -sf upstream_0.conf nginx/upstream.conf
	docker exec nginx nginx -s reload

	exit 1
fi
echo "Green is healthy at 30%. Increasing to 50%..."


#at 50%
ln -sf upstream_5.conf nginx/upstream.conf
docker exec nginx nginx -s reload
sleep 10
STATUS=$(docker inspect --format='{{.State.Health.Status}}' green)

if [ "$STATUS" != "healthy" ]; then
	echo "Green became unhealthy. Rolling back to BLUE."

	ln -sf upstream_0.conf nginx/upstream.conf
	docker exec nginx nginx -s reload

	exit 1
fi
echo "Green is healthy at 50%. Increasing to 100%..."


#at 100%v green
ln -sf upstream_green.conf nginx/upstream.conf
docker exec nginx nginx -s reload

echo "Monitoring deployment..."

sleep 15


STATUS=$(docker inspect --format='{{.State.Health.Status}}' green)

if [ "$STATUS" != "healthy" ]; then
	echo "Green became unhealthy. Rolling back to BLUE."

	ln -sf upstream_0.conf nginx/upstream.conf
	docker exec nginx nginx -s reload

	exit 1
fi

echo "Deployment successful. Green is stable."



