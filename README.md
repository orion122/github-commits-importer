# Github Commits Importer
[![Build Status](https://travis-ci.org/orion122/github-commits-importer.svg?branch=master)](https://travis-ci.org/orion122/github-commits-importer)

## Install app
```
$ git clone https://github.com/orion122/github-commits-importer
$ bundle install
```

## Run docker with PostgreSQL
`$ docker-compose up -d`

## Database init
```
$ rails db:create RAILS_ENV=production
$ rails db:migrate RAILS_ENV=production
```

## Run app
`$ rails s -e production`

## Run tests
```
$ rails db:create RAILS_ENV=test
$ rails db:migrate RAILS_ENV=test
$ bundle exec rspec
```