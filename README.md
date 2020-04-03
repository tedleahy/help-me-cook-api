# HelpMeCook

### Set up for development:

- Install Ruby 2.6.5

```shell
gem install bundler # if not already installed
bundle # install gems

# Setup database
rails db:create db:migrate

# Import recipes
rails runner lib/scrapers/mob_kitchen.rb

# Run tests
bin/rspec

# Start development server
rails s
```
