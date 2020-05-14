FROM tomcat:8-jdk8

MAINTAINER Joerg Mechnich <joerg.mechnich@bib.uni-mannheim.de>

ARG KITODO_HOME=/usr/local/kitodo
# This should either be set via DOCKER_TAG when building on Docker Hub or
# be overridden in the docker-compose.yml file when building with docker-compose
ARG KITODO_VERSION=${DOCKER_TAG:-3.1.0}

ENV KITODO_HOME ${KITODO_HOME}
ENV KITODO_VERSION ${KITODO_VERSION}

# used in docker-entrypoint.sh
ENV DB_ADDR=localhost
ENV DB_PORT=3306
ENV ELASTIC_ADDR=localhost

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR /tmp
RUN  apt-get -q update \
  && apt-get -q install -y --no-install-recommends mariadb-client \
  && rm -rf /var/lib/apt/lists/* \
  && wget -q https://github.com/kitodo/kitodo-production/releases/download/kitodo-production-${KITODO_VERSION}/kitodo-production-${KITODO_VERSION}-config.zip -O kitodo_config.zip \
  && wget -q https://github.com/kitodo/kitodo-production/releases/download/kitodo-production-${KITODO_VERSION}/kitodo-production-${KITODO_VERSION}-modules.zip -O kitodo_mods.zip \
  && wget -q https://github.com/kitodo/kitodo-production/releases/download/kitodo-production-${KITODO_VERSION}/kitodo-production-${KITODO_VERSION}.sql -O kitodo.sql \
  && wget -q https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
  && wget -q https://github.com/kitodo/kitodo-production/releases/download/kitodo-production-${KITODO_VERSION}/kitodo-${KITODO_VERSION}.war -O ${CATALINA_HOME}/webapps/kitodo.war \
  && unzip -d ${CATALINA_HOME}/webapps/kitodo ${CATALINA_HOME}/webapps/kitodo.war \
  && rm -f ${CATALINA_HOME}/webapps/kitodo.war \
  && chmod +x wait-for-it.sh \
  && chmod +x /docker-entrypoint.sh

EXPOSE 8080

CMD catalina.sh run
