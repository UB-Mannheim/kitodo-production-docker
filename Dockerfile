FROM tomcat:8-jdk8

MAINTAINER Joerg Mechnich <joerg.mechnich@bib.uni-mannheim.de>

ENV DB_ADDR=localhost
ENV DB_PORT=3306

ENV KITODO_HOME=/usr/local/kitodo

ENV KITODO_CONF=https://github.com/kitodo/kitodo-production/releases/download/kitodo-production-3.0.0-beta.2/kitodo-production-3.0.0-beta.2-config.zip
ENV KITODO_MODS=https://github.com/kitodo/kitodo-production/releases/download/kitodo-production-3.0.0-migration.1/modules.zip
ENV KITODO_SQL=https://github.com/kitodo/kitodo-production/releases/download/kitodo-production-3.0.0-migration.1/migration_V2_0-V2_87.sql

ARG KITODO_BASE=https://github.com/kitodo/kitodo-production/releases/download/kitodo-production-3.0.0-migration.1/kitodo-3.0.0-beta.4-SNAPSHOT.war

WORKDIR /tmp
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
RUN  apt-get -q update \
  && apt-get -q install -y --no-install-recommends mariadb-client \
  && rm -rf /var/lib/apt/lists/* \
  && wget -q "${KITODO_BASE}" -O ${CATALINA_HOME}/webapps/kitodo.war \
  && unzip -d ${CATALINA_HOME}/webapps/kitodo ${CATALINA_HOME}/webapps/kitodo.war \
  && rm -f ${CATALINA_HOME}/webapps/kitodo.war \
  && wget -q https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
  && chmod +x wait-for-it.sh \
  && chmod +x /docker-entrypoint.sh

EXPOSE 8080

CMD catalina.sh run
