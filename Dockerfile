FROM ruby:2.2.5
MAINTAINER Eric Hertwig <eric@ehdev.de>

run apt-get update && \
    apt-get install -y \
        qt4-default node unzip && \
    cd /opt && \
    wget -qO- -O tmp.zip \
         https://github.com/jneen/rouge.jneen.net/archive/master.zip && \
    unzip tmp.zip && rm tmp.zip
run cd /opt/rouge.jneen.net-master && \
   sed -i -e "s/gem 'pg'/gem 'sqlite3'/g" Gemfile && \
   sed -i -e "/gem 'sqlite3'/a gem 'foreman'" Gemfile && \
   sed -i -e "s/postgresql/sqlite3/g" config/database.yml && \
   sed -i -e "s/rouge_development/db.sqlite3/g" config/database.yml && \
   gem install capybara-webkit -v '1.11.1'
run cd /opt/rouge.jneen.net-master && ./bin/setup
copy startup.sh /startup.sh
ENTRYPOINT ["/bin/bash", "/startup.sh"]
