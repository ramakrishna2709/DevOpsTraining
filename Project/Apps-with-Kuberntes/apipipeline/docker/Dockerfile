#Common Docker image for API Services
#Maintainers:"Academy DevOps"
FROM us.gcr.io/just-slate-88918/alpine-oracle-jdk:alpine-3.8-glibc-2.28-r0-jdk-8u131-full-v3
ENV     JAVA_VERSION=8 \
        JAVA_UPDATE=181 \
        JAVA_BUILD=13 \
        JAVA_PATH=96a7b8442fe848ef90c96a2fad6ed6d1 \
        JAVA_HOME="/usr/lib/jvm/default-jvm" \
        JAVA_OPTS="-server -Xmx512m -XX:+UseG1GC"

COPY    target/ARTIFACT-*.jar /tmp

EXPOSE PORTNUMBER
CMD ["/bin/bash"] 

ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /tmp/ARTIFACT-*.jar" ]