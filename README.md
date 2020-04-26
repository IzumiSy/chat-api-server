# Chat API Server
[![build status](https://circleci.com/gh/IzumiSy/chat-api-server.svg?style=shield&circle-token=a8ab869724415d9d09f918fa716bf41a8ea45188)](https://circleci.com/gh/IzumiSy/chat-api-server)
[![standard-readme compliant](https://img.shields.io/badge/standard--readme-OK-green.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

> Chat backend server.

Sample front-end app: [IzumiSy/chat-frontend](https://github.com/IzumiSy/chat-frontend)

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Table of Contents
- [Setup](#Setup)
- [Run](#Run)
- [Test](#Test)
- [Contribute](#Contribute)
- [License](#License)

## Setup
```bash
$ docker-compose build
$ docker-compose run app bundle exec rake seed
$ docker-compose up
```

## Setup (non-dockerized)
### Install gems
```bash
$ bundle install
```
You also need to install MongoDB and Memcached in addition if not yet.

### Edit .env
```bash
$ cp .env.sample .env
$ vi .env
...
```

### Give seeds
```bash
$ bundle exec rake seed
```

## Run
```bash
$ bundle exec thin start -p 3000
```

## Test
```bash
$ bundle exec rspec
```

## License
MIT © IzumiSy
