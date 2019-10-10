FROM tomcat:8-jdk8

MAINTAINER Joerg Mechnich <joerg.mechnich@bib.uni-mannheim.de>

ENV DB_ADDR=localhost
ENV DB_PORT=3306

ARG KITODO_HOME=/usr/local/kitodo

WORKDIR /tmp
RUN  apt-get -q update; apt-get -q install -y --no-install-recommends ant \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p "${KITODO_HOME}" \
  && wget -q https://github.com/kitodo/kitodo-production/releases/download/kitodo-production-2.3.0/kitodo-production-2.3.0.war -O ${CATALINA_HOME}/webapps/kitodo.war \
  && unzip -d ${CATALINA_HOME}/webapps/kitodo ${CATALINA_HOME}/webapps/kitodo.war \
  && cp -r ${CATALINA_HOME}/webapps/kitodo/scripts "${KITODO_HOME}" \
  && rm -f ${CATALINA_HOME}/webapps/kitodo.war \
  && (cd "${KITODO_HOME}" && mkdir -p config debug logs messages metadata plugins rulesets scripts swap tmp xslt) \
  && (cd ${CATALINA_HOME}/webapps/kitodo/WEB-INF/classes && cp goobi_*.xml modules.xml ${KITODO_HOME}/config) \
  && (cd ${CATALINA_HOME}/webapps/kitodo/WEB-INF/classes && cp docket.xsl docket_multipage.xsl ${KITODO_HOME}/xslt) \
  && cp ${CATALINA_HOME}/webapps/kitodo/rulesets/* ${KITODO_HOME}/rulesets
  
EXPOSE 8080

CMD /bin/sed -i "s,\(jdbc:mysql://\)[^/]*\(/.*\),\1${DB_ADDR}:${DB_PORT}\2," ${CATALINA_HOME}/webapps/kitodo/WEB-INF/classes/hibernate.cfg.xml \
  && catalina.sh run
