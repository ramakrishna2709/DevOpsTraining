FROM jenkins/jnlp-slave

ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV PATH /opt/google-cloud-sdk/bin:$PATH

USER root

# Install Google Cloud Component
RUN mkdir -p /opt
RUN curl https://sdk.cloud.google.com | bash && mv google-cloud-sdk /opt 
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
COPY config/settings.xml /opt/apache-maven-3.2.5/conf
COPY config/groovy-html.template /home/jenkins/groovy-html.template

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
#ENTRYPOINT ["/entrypoint.sh"]

#COPY config/.bashrc /home/jenkins
#USER jenkins
