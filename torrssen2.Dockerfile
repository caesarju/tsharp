FROM node:12-alpine
RUN mkdir /torrssen2
COPY . /torrssen2
WORKDIR /torrssen2/nuxt
RUN npm install && npm run build -- --spa
RUN mkdir -p ../src/main/resources/static
RUN cp -R dist/* ../src/main/resources/static

FROM gradle:jdk8
RUN mkdir /torrssen2
WORKDIR /torrssen2
COPY --from=0 /torrssen2 .
RUN gradle bootjar

FROM ubuntu:focal
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    locales \
    wget \
    software-properties-common

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN add-apt-repository --yes ppa:openjdk-r/ppa
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-17-jdk

COPY --from=1 /torrssen2/build/libs/torrssen2-*.jar torrssen2.jar
VOLUME [ "/root/data" ]
EXPOSE 8080
CMD [ "java", "-jar", "torrssen2.jar"]
