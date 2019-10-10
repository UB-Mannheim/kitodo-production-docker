FROM tomcat:8-jdk8

MAINTAINER Joerg Mechnich <joerg.mechnich@bib.uni-mannheim.de>

ENV DB_ADDR=localhost
ENV DB_PORT=3306

ARG KITODO_HOME=/usr/local/kitodo

WORKDIR /tmp
RUN  apt-get -q update; apt-get -q install -y --no-install-recommends ant \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p "${KITODO_HOME}" \
  && git clone -b 2.x https://github.com/kitodo/kitodo-production.git \
  && cd kitodo-production \
  && cp build.properties.template build.properties \
  && echo "tomcat.dir.lib=${CATALINA_HOME}/lib" >> build.properties \
  && ant \
  && unzip -d "${CATALINA_HOME}"/webapps/kitodo dist/kitodo-production*.war \
  && rm -f dist/kitodo-production*.war \
  && cp -r Goobi/scripts "${KITODO_HOME}" \
  && cd .. \
  && rm -rf /tmp/kitodo-production \
  && cd "${KITODO_HOME}" \
  && mkdir -p config debug logs messages metadata plugins rulesets scripts swap tmp xslt
  
EXPOSE 8080

CMD /bin/sed -i "s,\(jdbc:mysql://\)[^/]*\(/.*\),\1${DB_ADDR}:${DB_PORT}\2," ${CATALINA_HOME}/webapps/kitodo/WEB-INF/classes/hibernate.cfg.xml \
  && catalina.sh run
