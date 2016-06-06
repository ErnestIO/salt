install:
	gem install bundler
	bundle install

lint:
	bundle exec rubocop

cover:
	COVERAGE=true MIN_COVERAGE=0 bundle exec rspec -c -f d spec

test:
	bundle exec rspec
