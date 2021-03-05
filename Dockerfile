FROM ruby:2.5.3-slim-stretch
LABEL maintainer="Martin Stabenfeldt <martin@stabenfeldt.net>"

ENV INSTALL_PATH /app
WORKDIR $INSTALL_PATH

RUN gem install httparty
RUN gem install pp

COPY . $INSTALL_PATH

WORKDIR $INSTALL_PATH


CMD ["ruby", "get.rb"]
