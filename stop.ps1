$DOCKER_ID = (docker ps -aq --filter name=exp-blog)
if(![String]::IsNullOrEmpty($DOCKER_ID)) {
    docker stop $DOCKER_ID
    # docker rm $DOCKER_ID
}
    
