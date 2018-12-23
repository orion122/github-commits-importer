# Github Commits Importer

## Run docker with PostgreSQL
`docker-compose up -d`

## Database init
`rails db:create RAILS_ENV=production`, `rails db:migrate RAILS_ENV=production`

## Run app
`rails s -e production`

## Run tests
`rails db:create RAILS_ENV=test`, `rails db:migrate RAILS_ENV=test`, `bundle exec rspec`