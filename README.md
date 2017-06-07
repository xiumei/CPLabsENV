# About
*Dockerfiles for setting up development environment for Customer Portal Labs.*

It supports applications written in Ruby on Rails and NodeJS as well as the above run with MySQL and Mongo DB based on Fedora 23.
The repo offers some scripts to build all docker images from dockerfiles and run applications on your local box.

# Features
- Share dockerfiles to build environment for RoR and Nodejs applications as well as MySQL and Mongo DB.
- Offer dockerfiles to set up proxy for Customer Portal Labs.
- Ship script to run applications which integrates source mounting, port mapping, container running and DB linking.
- Embed script to install dependencies, initialize DB as well as start server when running applications.


# How To Use

## Clone this repository
```bash
git clone <Repo url>
```

## Build docker images

### Edit your UID

When running the app, source of your application will be mounted to the container. In order to make files created in the container have the same permission or ownership as existing ones, the user running the application in container should have the same uid as the one owns the application in host.

- Check the uid of the application owner.
```shell
id <owner of the app>
```

- Edit Dockerfiles

```shell
cd labsEnv
sed -i 's/RUN useradd -u 1000 labsapp/RUN useradd -u <your user id> labsapp/g' labs-rails/Dockerfile
sed -i 's/RUN useradd -u 1000 labsapp/RUN useradd -u <your user id> labsapp/g' labs-node/Dockerfile
```

### Edit your host domain

In order to use resources deployed in Customer Portal, a proxy is set for CPLabs to retrieve all data from Portal. As applications under development are usually running on your local box, a host domain must be accessible for returned resource. Here, we set Apache as a proxy with your own host domain.
```shell
cd labsEnv
sed -i 's/myHost="my-host-domain"/myHost="<your host domain>"/g' labs-proxy/create-conf
```

### Buid

```bash
cd labsEnv
./build-all
```
If docker is not installed in your OS, run:
```bash
cd labsEnv
./build-all -install
```

## Run your application
```bash
<path to labsEnv>/runapp [options]
```

Options
- node/rails, the app to run is Rails or Nodejs. Default is 'rails'.
- bundle/install, for Rails app, appending 'bundle' triggers 'bundle install'. For Node app, appending 'install' triggers 'npm install && bower install'. By default, bundle is appended.
- rake, used in Rails app only to trigger 'rake db:migrate' task.
- noproxy, no proxy container will be created.
- bash, source will be mounted and you will interact with the /bin/bash of the container. You have to run other tasks like installing dependencies, initializing DB as well as starting server by yourself. In the bash mode, you are able to debug in the container.
- -d, run the containers as daemon.
- -q, create and link a MySQL container for the app.
- -m, create and link a mongo db container for the app.
- --image=<another image>, use another image to run the app. The default is labs-rails for Rails app and labs-node for Node app.

Examples:

Run demo rh-labs-rails
```bash
cd labsEnv/Demos/rh-labs-rails
labsEnv/runapp.sh rails
```

Run demo rh-labs-node
```bash
cd labsEnv/Demos/rh-labs-node
labsEnv/runapp.sh node install
```

Check proxy port
```shell
docker ps -a
```
If the containers are up, you will be able to find containers with names like rh-labs-rails-proxy-3001-10001 and rh-labs-node-proxy-3002-10002, the port 3001/3002 is the one exposed by the application container, and 10001/10002 is exposed by the proxy container. You can access to your application in the browser by visiting links like:
```doc
https://<my domain>:10001/labs/labsdemoapprails/
https://<my domain>:10002/labs/rhlabsangular/
```


