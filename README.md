# Chat API Server
[![build status](https://circleci.com/gh/IzumiSy/chat-api-server.svg?style=shield&circle-token=a8ab869724415d9d09f918fa716bf41a8ea45188)](https://circleci.com/gh/IzumiSy/chat-api-server)  
This repository is the backend side of chat application.  
Frontend side is here: https://github.com/IzumiSy/chat-frontend
## Setup
```bash
$ brew update
$ brew install mongodb
$ brew install redis
$ bundle install
```

## Preparation
**Redis**
```bash
$ redis-server
...
```
**MongoDB**
```bash
$ mongod --config /usr/local/etc/mongod.conf
...
```

## Run
```bash
$ bundle exec thin start -p 3000
```

## Test
```bash
$ bundle exec rspec
```
