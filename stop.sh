DOCKER_ID=`docker ps -aq --filter name=exp-blog`
if [ ! -z "${DOCKER_ID}" ]; then
    docker stop ${DOCKER_ID}
    # docker rm ${DOCKER_ID}
fi
