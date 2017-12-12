FROM node:9-alpine

# need to build prolog ourselves, it's not in apk repos.
# Taken from (seems this version is not yet officially available in Dockerhub):
# https://github.com/SWI-Prolog/docker-swipl/blob/master/7.5.11/alpine/Dockerfile

RUN SWIPL_VER=7.5.11 && \
    SWIPL_CHECKSUM=ab8a21ef88e410fc8dfb421bcba7884687fdf08ed85c191e51d806aa831d95e9 \
    && apk --update add --no-cache curl libarchive readline pcre gmp libressl libedit zlib db unixodbc libuuid \
    && apk --update add --no-cache --virtual build-dependencies bash alpine-sdk autoconf libarchive-dev gmp-dev pcre-dev readline-dev libedit-dev libressl-dev zlib-dev db-dev unixodbc-dev util-linux-dev linux-headers \
    && apk add geos-dev --update-cache --virtual build-dependencies --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
    && curl -O http://www.swi-prolog.org/download/devel/src/swipl-$SWIPL_VER.tar.gz \
    && echo "$SWIPL_CHECKSUM  swipl-$SWIPL_VER.tar.gz" >> swipl-$SWIPL_VER.tar.gz-CHECKSUM \
    && sha256sum -c swipl-$SWIPL_VER.tar.gz-CHECKSUM \
    && tar -xzf swipl-$SWIPL_VER.tar.gz \
    && cd swipl-$SWIPL_VER && ./configure && make && make install \
    && cd packages && ./configure && make && make install \
    && apk del build-dependencies \
    && cd ../.. && rm -rf swipl-$SWIPL_VER.tar.gz swipl-$SWIPL_VER.tar.gz-CHECKSUM swipl-$SWIPL_VER

COPY src/js /js
COPY src/prolog /prolog

WORKDIR "/js"
CMD ["node", "server.js"]
