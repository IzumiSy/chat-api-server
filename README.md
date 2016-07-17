# Chat API Server
[![build status](https://circleci.com/gh/IzumiSy/chat-api-server.svg?style=shield&circle-token=a8ab869724415d9d09f918fa716bf41a8ea45188)](https://circleci.com/gh/IzumiSy/chat-api-server)  
Simple & Easy-modifiable chat backend server.  
What you need are only three things: **Sinatra**, **MongoDB**, and **Redis**

### Features
- Multiple room
- Entrance authorization
- Admin user support
- Small and fast

Sample front-end app: https://github.com/IzumiSy/chat-frontend
## Setup
Install tools and dependencies
```bash
$ brew update
$ brew install mongodb
$ brew install redis
$ bundle install
```

Itamae recipe file for EC2 instance is available: `itamae/ec2-recipe.rb`

Edit .env
```bash
$ cp .env.sample .env
$ vi .env
...
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
**Seed**
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
All records on DB will be cleaned up if you run test, so you need to exec `rake db:seed_rooms` again before you start it up.

## Known issues
- chat-api-server currently does NOT work well on Heroku probably because of RocketIO.
