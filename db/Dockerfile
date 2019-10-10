FROM mariadb:10.1

MAINTAINER Joerg Mechnich <joerg.mechnich@bib.uni-mannheim.de>

#ENV MYSQL_ALLOW_EMPTY_PASSWORD=yes
ENV MYSQL_RANDOM_ROOT_PASSWORD=yes
ENV MYSQL_DATABASE=kitodo
ENV MYSQL_USER=kitodo
ENV MYSQL_PASSWORD=kitodo

RUN  apt-get -q update \
  && apt-get -q install -y --no-install-recommends ca-certificates unzip wget \
  && rm -rf /var/lib/apt/lists/* \
  && wget -q https://github.com/kitodo/kitodo-production/releases/download/kitodo-production-2.3.0/kitodo-production-2.3.0.war \
  && unzip -j kitodo-production-2.3.0.war database-setup/\* \
  && mv schema.sql /docker-entrypoint-initdb.d/00_schema.sql \
  && mv default.sql /docker-entrypoint-initdb.d/01_default.sql \
  && rm -f kitodo-production-2.3.0.war
