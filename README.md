# Chat API Server
[![build status](https://circleci.com/gh/IzumiSy/chat-api-server.svg?style=shield&circle-token=a8ab869724415d9d09f918fa716bf41a8ea45188)](https://circleci.com/gh/IzumiSy/chat-api-server)  
Chat backend server.

Sample front-end app: [IzumiSy/chat-frontend](https://github.com/IzumiSy/chat-frontend)

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Setup
Install tools and dependencies
```bash
$ brew install mongodb
$ brew install redis
$ bundle install
```

Edit .env
```bash
$ cp .env.sample .env
$ vi .env
...
```

Give seeds
```bash
$ rake db:seed_rooms
```

## Run
```bash
$ bundle exec thin start -p 3000
```

## Test
```bash
$ bundle exec rspec
```
