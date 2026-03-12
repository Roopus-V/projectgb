#!/bin/bash

set -e

NGINX_CONTAINER="nginx"
UPSTREAM="nginx/upstream.conf"

STAGES=(1 3 5)

#function to generate upstream
generate_upstream(){
        BLUE=$1
        GREEN=$2

        if [ "$BLUE" -eq 0 ]; then
			ln -sf upstream_green.conf "$UPSTREAM"
        elif [ "$GREEN" -eq 0 ]; then
			ln -sf upstream_blue.conf "$UPSTREAM"
        elif [ "$GREEN" -eq 1 ]; then
			ln -sf upstream_1.conf "$UPSTREAM"
        elif [ "$GREEN" -eq 3 ]; then
			ln -sf upstream_3.conf "$UPSTREAM"
        elif [ "$GREEN" -eq 5 ]; then
			ln -sf upstream_5.conf "$UPSTREAM"
	fi
}

#function to reload
reload_nginx(){
        docker exec "$NGINX_CONTAINER" nginx -t
        docker exec "$NGINX_CONTAINER" nginx -s reload
}
#function to check health of container

check_health(){
        STATUS=$(docker inspect --format='{{.State.Health.Status}}' $TARGET)
        if [ "$STATUS" != "healthy" ]; then
                rollback
        fi
}

#function to rollback if there are issues.
rollback(){
        echo "Rollback triggered. Restoring to previous environment."

        if [ "$TARGET" == "green" ]; then
                generate_upstream 10 0
        else
                generate_upstream 0 10
        fi
        reload_nginx
        exit 1
}

echo "Dectecting environment...."

ACTIVE=$(readlink $UPSTREAM || true )

if [[ "$ACTIVE" == *green* ]]; then
        TARGET="blue"
        echo "Green is Live. Deploying to Blue..."
else
        TARGET="green"
        echo "Blue is Live. Deploying to Green..."
fi

echo "Checking $TARGET health..."
check_health

echo "Starting progressive rollout."

#Loop
for s in "${STAGES[@]}"; do

        if [ "$TARGET" == "green" ]; then
                BLUE=$((10 - s))
                GREEN=$s
        else
                BLUE=$s
                GREEN=$((10 - s))
        fi

        echo "Traffic stage: blue=$BLUE; green=$GREEN"

        generate_upstream $BLUE $GREEN
        reload_nginx
        sleep 10
        check_health

done

echo "Promoting $TARGET to 100%..."

if [ "$TARGET" == "green" ]; then
        generate_upstream 0 10
else
        generate_upstream 10 0
fi

reload_nginx

echo "Monitoring deployment..."
sleep 15
check_health

echo "Deployment successful."
