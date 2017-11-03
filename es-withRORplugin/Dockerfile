FROM quay.io/pires/docker-jre:8u131_alpine3.6.2
MAINTAINER hrishikesh.deodhar@gmail.com

# Export HTTP & Transport
EXPOSE 9200 9300

ENV ES_VERSION 5.5.0
ENV DOWNLOAD_URL "https://artifacts.elastic.co/downloads/elasticsearch"
ENV ES_TARBAL "${DOWNLOAD_URL}/elasticsearch-${ES_VERSION}.tar.gz"
ENV ES_TARBALL_ASC "${DOWNLOAD_URL}/elasticsearch-${ES_VERSION}.tar.gz.asc"
ENV GPG_KEY "46095ACC8548582C1A2699A9D27D666CD88E42B4"

# Install Elasticsearch.
RUN apk add --no-cache --update bash ca-certificates su-exec util-linux
RUN apk add --no-cache -t .build-deps wget gnupg openssl \
  && cd /tmp \
  && echo "===> Install Elasticsearch..." \
  && wget -O elasticsearch.tar.gz "$ES_TARBAL"; \
	if [ "$ES_TARBALL_ASC" ]; then \
		wget -O elasticsearch.tar.gz.asc "$ES_TARBALL_ASC"; \
		export GNUPGHOME="$(mktemp -d)"; \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY"; \
		gpg --batch --verify elasticsearch.tar.gz.asc elasticsearch.tar.gz; \
		rm -r "$GNUPGHOME" elasticsearch.tar.gz.asc; \
	fi; \
  tar -xf elasticsearch.tar.gz \
  && ls -lah \
  && mv elasticsearch-$ES_VERSION /elasticsearch \
  && adduser -DH -s /sbin/nologin elasticsearch \
  && echo "===> Creating Elasticsearch Paths..." \
  && for path in \
  	/elasticsearch/config \
  	/elasticsearch/config/scripts \
  	/elasticsearch/plugins \
  ; do \
  mkdir -p "$path"; \
  chown -R elasticsearch:elasticsearch "$path"; \
  done \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

ENV PATH /elasticsearch/bin:$PATH

WORKDIR /elasticsearch

# Copy configuration
COPY config /elasticsearch/config

# Copy run script
COPY run.sh /

# Set environment variables defaults
ENV ES_JAVA_OPTS "-Xms512m -Xmx512m"
ENV CLUSTER_NAME elasticsearch-default
ENV NODE_MASTER true
ENV NODE_DATA true
ENV NODE_INGEST true
ENV HTTP_ENABLE true
ENV NETWORK_HOST _site_
ENV HTTP_CORS_ENABLE true
ENV HTTP_CORS_ALLOW_ORIGIN *
ENV NUMBER_OF_MASTERS 1
ENV MAX_LOCAL_STORAGE_NODES 1
ENV SHARD_ALLOCATION_AWARENESS ""
ENV SHARD_ALLOCATION_AWARENESS_ATTR ""
# Set environment
ENV DISCOVERY_SERVICE elasticsearch-discovery
# Kubernetes requires swap is turned off, so memory lock is redundant
ENV MEMORY_LOCK false
ENV NODE_NAME $(uuidgen)

# Copy Readonly rest plugin and install it. 
COPY readonlyrest/readonlyrest_es5.5.0.zip /tmp/
RUN /elasticsearch/bin/elasticsearch-plugin install file:/tmp/readonlyrest_es5.5.0.zip
#COPY keystore.jks /elasticsearch/plugins/readonlyrest/

# Volume for Elasticsearch data
VOLUME ["/data"]

CMD ["/run.sh"]
