# About
*Dockerfiles for setting up development environment for Customer Portal Labs.*

It supports applications written in Ruby on Rails and NodeJS based on Fedora 23.

*Note: The images are used to mimic development environment for Customer Portal Labs only. They are not supposed to apply in production.


# How To Use

## 1. Clone this repository
```bash
git clone REPO_URL
```

## 2. Build docker images

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

### Build

```bash
cd labsEnv
docker build -t labs-rails ./labs-rails/
docker build -t labs-nodejs ./labs-node/
```

## 3. Run your application
Mount app source to the container and map application port to host port. App source is mounted on /labsapp and you can run the serve in this directory.
```bash
docker run --name "$appContainerName" -it -p $hostPort:$appPort -v "$appDir":/labsapp:Z labs-rails /bin/bash
```