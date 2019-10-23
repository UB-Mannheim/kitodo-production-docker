FROM tomcat:8-jdk8

MAINTAINER Joerg Mechnich <joerg.mechnich@bib.uni-mannheim.de>

ENV DB_ADDR=localhost
ENV DB_PORT=3306
ENV ELASTIC_ADDR=localhost

ENV KITODO_HOME=/usr/local/kitodo

WORKDIR /tmp
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
RUN  apt-get -q update \
  && apt-get -q install -y --no-install-recommends mariadb-client maven wget zip \
  && rm -rf /var/lib/apt/lists/* \
  && sed -i 's/securerandom.source=file:\/dev\/random/securerandom.source=file:\/dev\/urandom/' /etc/java-8-openjdk/security/java.security

RUN  wget -q https://github.com/kitodo/kitodo-production/archive/master.zip \
  && unzip master.zip && rm master.zip \
  && (cd kitodo-production-master/ && mvn clean package '-P!development') \
  && zip -j kitodo-3-modules.zip kitodo-production-master/Kitodo/modules/*.jar \
  && mv kitodo-production-master/Kitodo/target/kitodo-3*.war kitodo-3.war

RUN  cp kitodo-production-master/Kitodo/setup/schema.sql . \
  && cp kitodo-production-master/Kitodo/setup/default.sql .

RUN  mkdir -p zip/config zip/debug zip/import zip/logs zip/messages zip/metadata zip/plugins zip/plugins/command zip/plugins/import zip/plugins/opac zip/plugins/step zip/plugins/validation zip/rulesets zip/scripts zip/swap zip/temp zip/users zip/xslt zip/diagrams \
  && install -m 444 kitodo-production-master/Kitodo/src/main/resources/kitodo_*.xml zip/config/ \
  && install -m 444 kitodo-production-master/Kitodo/src/main/resources/modules.xml zip/config/ \
  && install -m 444 kitodo-production-master/Kitodo/src/main/resources/docket*.xsl zip/xslt/ \
  && install -m 444 kitodo-production-master/Kitodo/rulesets/*.xml zip/rulesets/ \
  && install -m 444 kitodo-production-master/Kitodo/diagrams/*.xml zip/diagrams/ \
  && install -m 554 kitodo-production-master/Kitodo/scripts/*.sh zip/scripts/ \
  && chmod -w zip/config zip/import zip/messages zip/plugins zip/plugins/command zip/plugins/import zip/plugins/opac zip/plugins/step zip/plugins/validation zip/rulesets zip/scripts zip/xslt \
  && (cd zip && zip -r ../kitodo-3-config.zip *) \
  && rm -rf zip

RUN  unzip -d ${CATALINA_HOME}/webapps/kitodo kitodo-3.war \
  && rm -f kitodo-3.war \
  && wget -q https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
  && chmod +x wait-for-it.sh \
  && chmod +x /docker-entrypoint.sh
 

EXPOSE 8080

CMD catalina.sh run
