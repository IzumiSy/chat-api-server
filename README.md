# Chat API Server

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
