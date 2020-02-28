FROM tomcat:8-jdk8

MAINTAINER Joerg Mechnich <joerg.mechnich@bib.uni-mannheim.de>

ENV DB_ADDR=localhost
ENV DB_PORT=3306
ENV KITODO_HOME=/usr/local/kitodo

WORKDIR /tmp
RUN  apt-get -q update \
  && apt-get -q install -y --no-install-recommends ant mariadb-client wget \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p "${KITODO_HOME}" \
  && git clone -b 2.x https://github.com/kitodo/kitodo-production.git \
  && cd kitodo-production \
  && cp build.properties.template build.properties \
  && echo "tomcat.dir.lib=${CATALINA_HOME}/lib" >> build.properties \
  && ant \
  && unzip -d "${CATALINA_HOME}"/webapps/kitodo dist/kitodo-production*.war \
  && rm -f dist/kitodo-production*.war \
  && cd .. \
  && rm -rf /tmp/kitodo-production

ENTRYPOINT ["/docker-entrypoint.sh"]
COPY docker-entrypoint.sh /

RUN  wget -q https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
  && wget -q https://raw.githubusercontent.com/kitodo/kitodo-production/2.x/Goobi/setup/schema.sql \
  && wget -q https://raw.githubusercontent.com/kitodo/kitodo-production/2.x/Goobi/setup/default.sql \
  && chmod +x wait-for-it.sh \
  && chmod +x /docker-entrypoint.sh
  
EXPOSE 8080

CMD catalina.sh run
