FROM ruby
 
COPY . /app
WORKDIR /app
RUN bundle install

ENTRYPOINT rackup
