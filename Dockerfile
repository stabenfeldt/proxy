FROM ruby:2.5.3-slim-stretch
LABEL maintainer="Martin Stabenfeldt <martin.stabenfeldt@shortcut.no>"

ENV INSTALL_PATH /app
WORKDIR $INSTALL_PATH

RUN gem install httparty
RUN gem install pp

COPY . $INSTALL_PATH

WORKDIR $INSTALL_PATH
ENV RAILS_ENV development

EXPOSE 3000

# ENTRYPOINT bundle exec puma -p 3000 -b 0.0.0.0
# CMD ["/usr/local/bundle/bin/rails", "s", "-b", "0.0.0.0", "-p", "3000"]
CMD ["ruby", "get.rb"]
