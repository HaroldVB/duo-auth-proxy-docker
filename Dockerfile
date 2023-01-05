# Defining FROM with Ubuntu
FROM ubuntu:latest

# Define user
USER root

# Update image to get packages 
RUN apt-get update && apt-get upgrade -y

# Installing dependencies 
RUN apt-get install build-essential libffi-dev perl zlib1g-dev wget -y

#Install duoauthproxy
RUN wget https://dl.duosecurity.com/duoauthproxy-latest-src.tgz
RUN mkdir duoauthproxy && tar xf duoauthproxy-latest-src.tgz
RUN cd duoauthproxy-*-src && make 
RUN cd */duoauthproxy-build && ./install --install-dir /opt/duoauthproxy --service-user root --log-group duo_authproxy_grp --create-init-script yes
RUN rm duoauthproxy-latest-src.tgz 
RUN rm -rf */duoauthproxy-* 

# Path to authproxy.cfg in container /opt/duoauthproxy/conf/authproxy.cfg
# Exposing ports
EXPOSE 1812

# Sending information to user
CMD ["sudo /opt/duoauthproxy/bin/authproxyctl", "start"]