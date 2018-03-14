# Utils image which contains jq and curl.
FROM alpine
MAINTAINER hrishikesh.deodhar@gmail.com

RUN apk update \
 && apk add --update curl \
 && apk add jq \
 && apk add --update bash \
 && rm -rf /var/cache/apk/*

COPY pxStatus.sh /usr/bin

ENTRYPOINT [ "pxStatus.sh" ]
