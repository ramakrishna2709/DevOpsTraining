FROM jenkins/jenkins 

ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV PATH /opt/google-cloud-sdk/bin:$PATH

USER root

# Install Google Cloud Component
RUN mkdir -p /opt
#RUN curl -fsSL  https://sdk.cloud.google.com | sh && mv google-cloud-sdk /opt 
#ENV CLOUD_SDK_REPO="echo cloud-sdk-$(lsb_release -c -s)"
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-216.0.0-linux-x86_64.tar.gz
RUN gunzip google-cloud-sdk-216.0.0-linux-x86_64.tar.gz
RUN tar -xvf  google-cloud-sdk-216.0.0-linux-x86_64.tar
RUN sh google-cloud-sdk/install.sh
RUN mv google-cloud-sdk /opt
RUN gcloud components install kubectl
RUN ln -s "/opt/google-cloud-sdk/bin/gcloud" /usr/bin/gcloud 
RUN ln -s "/opt/google-cloud-sdk/bin/kubectl" /usr/bin/kubectl 
RUN ln -s "/opt/google-cloud-sdk/bin/gsutil" /usr/bin/gsutil

# Install docker
RUN dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
 && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.10/gosu-$dpkgArch" \
 && chmod +x /usr/local/bin/gosu \
 && gosu nobody true
RUN curl -fsSL https://get.docker.com/ | sh &&  chmod +x /usr/bin/docker


# Required for ensuring we use the Gcloud docker API version
ENV DOCKER_API_VERSION=1.37

# Install maven
RUN mkdir -p "/opt" && \
    cd /tmp && \
    wget "http://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz" && \
    tar -zxvf "apache-maven-3.2.5-bin.tar.gz" && \
    mv "apache-maven-3.2.5" "/opt" && \
    ln -s "/opt/apache-maven-3.2.5/bin/mvn" /usr/local/bin/mvn


RUN apt-get update -yq \
    && apt-get install curl gnupg -yq \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash \
    && apt-get install nodejs -yq
RUN npm install -g npm@5.6.0

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY config/ImageListScript.groovy /ImageListScript.groovy
COPY entrypoint.sh /entrypoint.sh
#COPY config/scriptApproval.xml /var/jenkins_home/scriptApproval.xml
#COPY config/config.xml /var/jenkins_home/config.xml
#COPY config/credentials.xml /var/jenkins_home/credentials.xml
#COPY config/secrets /var/jenkins_home/secrets
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
#ENTRYPOINT ["/entrypoint.sh"]

#COPY config/.bashrc /home/jenkins
#USER jenkins
