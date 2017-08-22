FROM alpine:3.6
RUN mkdir -p /mysqldump && \
    apk add --update mysql-client bash openssh-client groff less python py-pip  && \
    pip install awscli && \
    apk --purge -v del py-pip && \
  	rm /var/cache/apk/*

WORKDIR /mysqldump

COPY dump.sh /
COPY import.sh /
ENTRYPOINT ["/dump.sh"]
