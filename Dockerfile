FROM ruby:2.6.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client npm\
  && rm -rf /var/lib/apt/lists/* \
  && curl -o- -L https://yarnpkg.com/install.sh | bash
RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
RUN bundle install

# install yarn
RUN npm install -g yarn
RUN yarn install --check-files

COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE $RAILS_PORT
