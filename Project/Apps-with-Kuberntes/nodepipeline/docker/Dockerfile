FROM centos:7.3.1611
MAINTAINER Academy DevOps Team 

COPY ./ /src
ADD package.json /src/package.json
ADD package-lock.json /src/package-lock.json

RUN curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - && \
	yum -y install nodejs gcc-c++ make yum-utils libpng-devel && yum clean all && \ 
	cd /src; npm rebuild

WORKDIR /src

EXPOSE APPPNUMBER

CMD ["npm", "start", "APPNAME"]