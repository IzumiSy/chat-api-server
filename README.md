# Chat API Server
![build status](https://circleci.com/gh/IzumiSy/chat-api-server.svg?style=shield&circle-token=a8ab869724415d9d09f918fa716bf41a8ea45188)  
This repository is the backend side of chat application.  
Frontend side is here: https://github.com/IzumiSy/chat-frontend
## Setup
```bash
$ brew update
$ brew install mongodb
$ bundle install
```

## Run
```bash
$ bundle exec thin -p 3000
```
or
```bash
$ bundle exec shotgun -p 3000
```

## Test
```bash
$ bundle exec rspec
```
