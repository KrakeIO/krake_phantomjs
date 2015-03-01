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

# Clone the conf files into the docker container
RUN git clone https://github.com/KrakeIO/krake_phantomjs.git $HOME/krake_phantomjs_temp

# Update the Krake PhantomJs file
RUN cd $HOME/krake_phantomjs_temp/ \
  && git pull origin master

# Installing NodeJs
RUN git clone https://github.com/creationix/nvm.git $HOME/.nvm

#nvm configuration
RUN /bin/bash -c "source $HOME/.bashrc \
    && . ~/.nvm/nvm.sh \
    && nvm install v0.10.28 \
    && nvm use v0.10.28 \
    && npm install -g forever \
    && cd $HOME/krake_phantomjs_temp/ \
    && npm install "

# Runtime configuration
EXPOSE 9701
CMD [ "phantomjs", "/root/krake_phantomjs/server.js" ]