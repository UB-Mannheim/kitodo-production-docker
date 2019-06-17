FROM tomcat:8-jdk8

MAINTAINER Joerg Mechnich <joerg.mechnich@bib.uni-mannheim.de>

ENV TOMCATDIR /usr/local/tomcat
ENV KITODODIR /usr/local/kitodo

RUN apt-get update; apt-get install -y --no-install-recommends ant \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN git clone -b 2.x https://github.com/kitodo/kitodo-production.git \
  && cd kitodo-production \
  && cp build.properties.template build.properties \
  && echo "tomcat.dir.lib=$TOMCATDIR/lib" >> build.properties \
  && ant \
  && unzip -d $TOMCATDIR/webapps/kitodo dist/kitodo-production*.war \
  && rm -f dist/kitodo-production*.war \
  && mkdir -p $KITODODIR \
  && cp -r Goobi/scripts $KITODODIR
  
EXPOSE 8080

CMD /bin/sed -i s/localhost/$MYSQL_PORT_3306_TCP_ADDR:$MYSQL_PORT_3306_TCP_PORT/ $TOMCATDIR/webapps/kitodo/WEB-INF/classes/hibernate.cfg.xml && \
    catalina.sh run
