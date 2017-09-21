FROM alpine

RUN   apk update \
  &&  apk add ca-certificates wget \
  &&  update-ca-certificates \
  &&  apk add bash

RUN wget --no-verbose -O /tmp/apache-maven-3.3.9.tar.gz http://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz

# verify checksum
RUN echo "516923b3955b6035ba6b0a5b031fbd8b  /tmp/apache-maven-3.3.9.tar.gz" | md5sum -c
# install maven
RUN  mkdir /opt \
  && tar xzf /tmp/apache-maven-3.3.9.tar.gz -C /opt/ \
  && ln -s /opt/apache-maven-3.3.9 /opt/maven \
  && ln -s /opt/maven/bin/mvn /usr/local/bin \
  && rm -f /tmp/apache-maven-3.3.9.tar.gz
ENV MAVEN_HOME /opt/maven

# set shell variables for java installation
ENV filename jdk-8u144-linux-x64.tar.gz
ENV downloadlink http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz
# download java, accepting the license agreement
RUN wget -q --header "Cookie: oraclelicense=accept-securebackup-cookie" -O /tmp/$filename $downloadlink

# unpack java
RUN mkdir -p /opt/oracle-java && tar -zxf /tmp/$filename -C /opt/oracle-java/
ENV JAVA_HOME /opt/oracle-java/jdk1.8.0_144/
ENV PATH $JAVA_HOME/bin:$PATH

RUN  apk add python3 libxml2-utils \
  && if [[ ! -e /usr/bin/easy_install ]]; then ln -sf /usr/bin/easy_install-3* /usr/bin/easy_install; fi \
  && easy_install pip \
  && pip install awscli --upgrade 

RUN  rm -rf /var/cache/apk \
  && rm -rf /var/cache/ \
  && rm -rf /tmp/*

