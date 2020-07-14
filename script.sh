#!/bin/bash

#Get the Running state of the container get-udemy-courses
dockerRunning=$(docker inspect get-udemy-courses | grep '"Running": true')
#echo $dockerRunning

if [[ "$dockerRunning" == *"true"* ]];
	then
		echo "Container is running"
	else
		docker start get-udemy-courses
		dockerRunning=$(docker inspect get-udemy-courses | grep '"Running": true')
		echo $dockerRunning
fi

read -p 'Access Token: ' accessToken
docker exec get-udemy-courses sed -i 's/=.*/='$accessToken'/g' /home/courses-downloads/udemy-dl/cookie.txt
dockerCookie=$(cat /home/courses-downloads/udemy-dl/cookie.txt)
echo $dockerCookie
