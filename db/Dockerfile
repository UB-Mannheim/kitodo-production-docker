FROM mariadb:10.1

MAINTAINER Joerg Mechnich <joerg.mechnich@bib.uni-mannheim.de>

#ENV MYSQL_ALLOW_EMPTY_PASSWORD yes
ENV MYSQL_RANDOM_ROOT_PASSWORD yes
ENV MYSQL_DATABASE kitodo
ENV MYSQL_USER kitodo
ENV MYSQL_PASSWORD kitodo

RUN apt-get update; apt-get install -y --no-install-recommends wget \
  && rm -rf /var/lib/apt/lists/*
RUN wget https://raw.githubusercontent.com/kitodo/kitodo-production/2.x/Goobi/setup/schema.sql -O /docker-entrypoint-initdb.d/00_schema.sql
RUN wget https://raw.githubusercontent.com/kitodo/kitodo-production/2.x/Goobi/setup/default.sql -O /docker-entrypoint-initdb.d/01_default.sql
