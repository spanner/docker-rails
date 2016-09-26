FROM phusion/baseimage:0.9.19

ENV APT_PACKAGES " \
  git imagemagick ruby ruby-dev nodejs\
  gcc g++ make patch binutils libc6-dev \
  libjemalloc-dev libffi-dev libssl-dev libyaml-dev zlib1g-dev libgmp-dev \
  libxml2-dev libxslt1-dev libmysqlclient-dev libreadline-dev"

ENV APT_REMOVE_PACKAGES "anacron cron openssh-server postfix"

COPY apt.conf /etc/apt/apt.conf.d/local
RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install -y $APT_PACKAGES
RUN apt-get remove --purge -y $APT_REMOVE_PACKAGES
RUN apt-get autoremove --purge -y

RUN rm /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN rm -r /etc/service/sshd /etc/service/cron

ENV GEM_SPEC_CACHE "/tmp/gemspec"
RUN echo 'gem: --no-document' > $HOME/.gemrc
RUN gem update --system
RUN gem install bundler

COPY db_migrate.sh /etc/my_init.d/90_db_migrate.sh
COPY sidekiq.sh /etc/service/sidekiq/run
COPY appserver.sh /etc/service/appserver/run
COPY clockwork.sh /etc/service/clockwork/run
COPY puma.rb /etc/
COPY sidekiq.yml /etc/
COPY clockwork.rb /etc/

RUN useradd -m app
RUN mkdir /home/app/webapp && chown app:app -R /home/app

RUN rm -rf /tmp/* /var/tmp/* /var/lib/apt /var/lib/dpkg /usr/share/man /usr/share/doc
