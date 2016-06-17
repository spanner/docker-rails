#!/bin/bash -xe

function testapp_run() {
  if ! docker-compose run app "$@"; then
    echo "Test '$@' failed!"
    exit 1
  fi
}

cd test
rm -rf testapp

# Set up testing rails app
gem install bundler rails
rails new testapp -d mysql -m template.rb --skip-bundle
cd testapp; bundle lock; cd ..
cp -r files/* testapp

# Build container
docker-compose kill
docker-compose rm -f
docker-compose build
docker-compose up -d

# Check that app server boots correctly, ENV variables are exposed and sidekiq works properly
if [ "$DOCKER_MACHINE_NAME" != "" ]; then
  HOST=$(docker-machine ip $DOCKER_MACHINE_NAME)
fi
RESULT=$(wget -O - --retry-connrefused -T 60 http://${HOST:-localhost}:8080/)
[ "$RESULT" == "ok" ] || exit 1

# Clean up
docker-compose stop

# Check that imagemagick is present
testapp_run which convert

# Check that ruby uses jemalloc
testapp_run bash -c "ldd /usr/local/bin/ruby |grep jemalloc"

# Check that openssl/readline is working in ruby
testapp_run ruby -r readline -e puts
testapp_run ruby -r openssl -e puts

# Check that nodejs, npm and bower are present
RESULT=$(testapp_run node -p '1+1')
[[ "$RESULT" == "2"* ]] || exit 1
testapp_run npm -v
testapp_run bower -v

# Check that asset gzipping works
FILE="/home/app/webapp/public/assets/application-*.js"
testapp_run bash -ec "gzip -dc < $FILE.gz |diff - $FILE"

echo "Tests OK"
