# this is the export-import-flattened output of building ./base
FROM rails4-base-squashed

ENV RACK_ENV=production RAILS_ENV=production HOME=/home/app
CMD ["/sbin/my_init"]
EXPOSE 8080
WORKDIR /home/app/webapp

ONBUILD COPY Gemfile Gemfile.lock /home/app/webapp/
ONBUILD RUN chown app:app Gemfile Gemfile.lock && \
  chpst -u app bundle install --deployment --jobs 4 --without development test && \
  find vendor/bundle -name *.gem -delete

ONBUILD COPY . /home/app/webapp/
ONBUILD RUN mkdir -p db public log tmp vendor && chown -R app:app app db public log tmp vendor
