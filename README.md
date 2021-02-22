# Guide to run the application

## Setup & install

### Clone this repository
### Install docker & docker compose on your computer.
### Run the project
```
- $ cd <project dir>
- $ docker-compose build
- $ docker-compose up
```

Create database first time:

```
$ docker-compose run app rake db:create
```

If you meet the error compile, run the command:

```
$ docker-compose run app yarn install --check-files
```

## Api Guide

### Get user access token

```
curl -X POST -d "grant_type=password&name=user-name-1&password=123456789" localhost:3000/oauth/token
```

### Test api endpoint at

```
http://localhost:3000/swagger
```
