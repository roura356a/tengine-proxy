FROM roura/tengine
LABEL maintainer="Alberto Roura mail@albertoroura.com"

ENV DOCKER_GEN_VERSION 0.7.4
ENV DOCKER_HOST unix:///tmp/docker.sock

ADD https://github.com/jwilder/forego/releases/download/v0.16.1/forego /usr/local/bin/forego

COPY network_internal.conf /etc/nginx/
COPY app /app

RUN apt-get update \
    && apt-get install -y -q --no-install-recommends wget ca-certificates \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/* \
    && chmod u+x /usr/local/bin/forego \
    && wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
    && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
    && rm /docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

WORKDIR /app

VOLUME ["/etc/nginx/certs", "/etc/nginx/dhparam"]
ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]