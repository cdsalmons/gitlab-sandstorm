#! /bin/sh

set -x

mkdir -p /var/redis
mkdir -p /var/log

mkdir -p /var/repositories
mkdir -p /var/gitlab-satellites

mkdir -p /var/tmp/cache
mkdir -p /var/tmp/miniprofiler
mkdir -p /var/tmp/pids
mkdir -p /var/tmp/sessions
mkdir -p /var/tmp/sockets
mkdir -p /var/tmp/repositories

mkdir -p /var/uploads

mkdir -p /var/sqlite3

export PATH="/usr/local/share/rbenv/versions/2.1.5/bin:$PATH"

redis-server /etc/redis.conf &
echo "started redis-server: " $?

cp initdb.sqlite3 /var/sqlite3/db.sqlite3

# gitlab-shell wants this variable to be set. Any value will do.
export SSH_CONNECTION=12345

cd gitlab

export GEM_HOME=/gitlab/vendor/bundle/ruby/2.1.0
RUBYOPT=-r/gitlab/vendor/bundle/bundler/setup RAILS_ENV=production ./vendor/bundle/ruby/2.1.0/bin/sidekiq -q post_receive -q default 2>&1 | awk '{print "sidekiq: " $0}' &
./bin/rails server -p 10000 -e production





