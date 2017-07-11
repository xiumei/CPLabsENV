# About
*Dockerfiles for setting up development environment for Customer Portal Labs.*

It supports applications written in Ruby on Rails and NodeJS as well as the above run with MySQL and Mongo DB based on Fedora 23.
The repo offers some scripts to build all docker images from dockerfiles and run applications on your local box.

*Note: The images are used to mimic development environment for Customer Portal Labs only. They are not supposed to apply in production.

# Features
- Share dockerfiles to build environment for RoR and Nodejs applications as well as MySQL and Mongo DB.
- Offer dockerfiles to set up proxy for Customer Portal Labs.
- Ship script to run applications which integrates source mounting, port mapping, container running and DB linking.
- Embed script to install dependencies, initialize DB as well as start server when running applications.


# How To Use

## 1. Clone this repository
```bash
git clone REPO_URL
```

## ２. Manage Docker as a non-root user
```bash
sudo groupadd docker
sudo gpasswd -a $USER docker
```

## ３. Build docker images

### Edit UID

When running the app, source of your application will be mounted to the container. In order to make files created in the container have the same permission or ownership as existing ones, the user running the application in container should have the same uid as the one owns the application in host.

- Check the uid of the application owner.
```shell
id APP_OWNER
```

- Edit Dockerfiles
```shell
cd labsEnv
sed -i 's/RUN useradd -u 1000 labsapp/RUN useradd -u YOUR_USER_ID labsapp/g' labs-rails/Dockerfile
sed -i 's/RUN useradd -u 1000 labsapp/RUN useradd -u YOUR_USER_ID labsapp/g' labs-node/Dockerfile
```

### Edit host domain

In order to use resources deployed in Customer Portal, a proxy is set for CPLabs to retrieve all data from Portal. As applications under development are usually running on your local box, a host domain must be accessible for returned resource. Here, we set Apache as a proxy with your own host domain.
```shell
cd labsEnv
sed -i 's/myHost="my-host-domain"/myHost="YOUR_HOST_DOMAIN"/g' labs-proxy/create-conf
```

### Build

```bash
cd labsEnv
./build-all
```
If docker is not installed on your OS, run:
```bash
cd labsEnv
./build-all -install
```
## 4. Create link to runapp script
```bash
sudo ln -s PATH_TO_LABSENV/runapp /bin/runapp
```

## 5. Run your application
```bash
cd PATH_TO_LOCAL_APP
runapp [options]
```

## Options
- install, Used in Node app only to trigger 'npm install && bower install'.
- rake, used in Rails app only to trigger 'rake db:migrate' task.
- noproxy, no proxy container will be created.
- bash, source will be mounted and you will interact with the /bin/bash of the container. You have to run other tasks like installing dependencies, initializing DB as well as starting server by yourself. In the bash mode, you are able to debug in the container.
- -d, run the container as a daemon.
- -q, create and link a MySQL to the container.
- -m, create and link a mongo db to the container.
- --image=ANOTHER_IMAGE_NAME, run the container with another image. The default is labs-rails for Rails app and labs-node for Node app.
- -h|--help, display this help and exit.

## Examples:

Run demo rh-labs-rails
```bash
cd labsEnv/Demos/rh-labs-rails
runapp
```

Run demo rh-labs-node
```bash
cd labsEnv/Demos/rh-labs-node
runapp install
```

Check proxy port
```shell
docker ps -a
```
If the containers are up, you will be able to find containers with names like rh-labs-rails-proxy-3001-10001 and rh-labs-node-proxy-3002-10002, the port 3001/3002 is the one exposed by the application container, and 10001/10002 is exposed by the proxy container. You can access to your application in the browser by visiting links like:
```doc
https://YOUR_DOMAIN:10001/labs/labsdemoapprails/
https://YOUR_DOMAIN:10002/labs/rhlabsangular/
```


