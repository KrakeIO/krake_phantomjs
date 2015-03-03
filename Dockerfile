FROM ubuntu
MAINTAINER Gary Teh <garyjob@gmail.com>

# Installing GIT
RUN apt-get update

# Install GIT
RUN sudo apt-get -y install git-core git



# Install PhantomJS dependencies
RUN apt-get -y install fontconfig
RUN apt-get -y install wget
RUN apt-get -y install curl

# Install PhantomJS
RUN cd /usr/local/share && \
  wget http://phantomjs.googlecode.com/files/phantomjs-1.9.2-linux-x86_64.tar.bz2 && \
  tar xjf phantomjs-1.9.2-linux-x86_64.tar.bz2

RUN sudo ln -s /usr/local/share/phantomjs-1.9.2-linux-x86_64/bin/phantomjs /usr/local/share/phantomjs
RUN sudo ln -s /usr/local/share/phantomjs-1.9.2-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs
RUN sudo ln -s /usr/local/share/phantomjs-1.9.2-linux-x86_64/bin/phantomjs /usr/bin/phantomjs
RUN sudo ln -s /usr/local/share/phantomjs-1.9.2-linux-x86_64/bin/phantomjs /bin/phantomjs



# Installing NodeJs
RUN git clone https://github.com/creationix/nvm.git $HOME/.nvm

# nvm configuration
RUN /bin/bash -c "source $HOME/.bashrc \
    && . ~/.nvm/nvm.sh \
    && nvm install v0.10.28 "

# Coffee setup
RUN sudo ln -s /root/.nvm/v0.10.28/bin/coffee /usr/local/share/coffee
RUN sudo ln -s /root/.nvm/v0.10.28/bin/coffee /usr/local/bin/coffee
RUN sudo ln -s /root/.nvm/v0.10.28/bin/coffee /usr/bin/coffee
RUN sudo ln -s /root/.nvm/v0.10.28/bin/coffee /bin/coffee

# Node setup
RUN sudo ln -s /root/.nvm/v0.10.28/bin/node /usr/local/share/node
RUN sudo ln -s /root/.nvm/v0.10.28/bin/node /usr/local/bin/node
RUN sudo ln -s /root/.nvm/v0.10.28/bin/node /usr/bin/node
RUN sudo ln -s /root/.nvm/v0.10.28/bin/node /bin/node

# Environment setup 
RUN echo ". ~/.nvm/nvm.sh" >> $HOME/.bashrc
RUN echo "nvm use v0.10.28" >> $HOME/.bashrc

RUN echo ". ~/.nvm/nvm.sh" >> $HOME/.profile
RUN echo "nvm use v0.10.28" >> $HOME/.profile



# use changes to package.json to force Docker not to use the cache
# when we change our application's nodejs dependencies:
ADD package.json /tmp/package.json
RUN /bin/bash -c "source $HOME/.bashrc \
    && . ~/.nvm/nvm.sh \
    && nvm use v0.10.28 \ 
    && cd /tmp \
    && npm install "

RUN mkdir -p /root/krake_phantomjs && cp -a /tmp/node_modules /root/krake_phantomjs

# Exposing the files from the current directory to the docker container
WORKDIR /root/krake_phantomjs
ADD . /root/krake_phantomjs

# Runtime configuration
EXPOSE 9701
CMD [ "phantomjs", "/root/krake_phantomjs/server.js" ]