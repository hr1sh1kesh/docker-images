FROM docker.elastic.co/kibana/kibana:5.5.0
MAINTAINER hrishikesh.deodhar@gmail.com

RUN bin/kibana-plugin remove x-pack

# Set some Kibana configuration defaults.
ADD config/kibana.yml /usr/share/kibana/config/