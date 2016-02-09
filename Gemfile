source('https://rubygems.org')

gem('bcrypt')
gem('sinatra', require: 'sinatra/base')
gem('data_mapper')

group(:test, :development) {
  gem('dm-mysql-adapter')
}

group(:production) {
  gem('dm-postgres-adapter')
}