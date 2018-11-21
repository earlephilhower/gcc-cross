# gcc-cross
Docker scripts to build earlephilhower/gcc-cross

## Build Docker Image
````
docker build -t gcc-cross .
````

## Upload to Docker Hub
````
docker tag gcc-cross earlephilhower/gcc-cross
docker push earlephilhower/gcc-cross
````

## Run Docker image
````
docker run --rm --tty --interactive earlephilhower/gcc-cross bash
````

