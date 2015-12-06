# Chat API Server
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
