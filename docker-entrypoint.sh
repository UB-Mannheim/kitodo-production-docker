#!/bin/sh

[ -e "${KITODO_HOME}/config/modules.xml" ] || \
    unzip -n -d "${KITODO_HOME}" kitodo-3-config.zip \
        && rm -f kitodo-3-config.zip

[ -e "${KITODO_HOME}/modules" ] || \
    mkdir -p "${KITODO_HOME}/modules" \
        && unzip -n -j -d "${KITODO_HOME}/modules" kitodo-3-modules.zip \
        && rm -f kitodo-3-modules.zip

# Database configuration
/bin/sed -i \
         "s,\(jdbc:mysql://\)[^/]*\(/.*\),\1${DB_ADDR}:${DB_PORT}\2," \
         ${CATALINA_HOME}/webapps/kitodo/WEB-INF/classes/hibernate.cfg.xml

# Elasticsearch configuration
/bin/sed -i \
         "s,^\(elasticsearch.host\)=.*,\1=${ELASTIC_ADDR}," \
         ${CATALINA_HOME}/webapps/kitodo/WEB-INF/classes/kitodo_config.properties

# Wait for database container
/tmp/wait-for-it.sh -t 0 ${DB_ADDR}:${DB_PORT}

# Initialize database if necessary
echo "SELECT 1 FROM user LIMIT 1;" \
    | mysql -h "${DB_ADDR}" -P "${DB_PORT}" -u kitodo --password=kitodo kitodo >/dev/null 2>&1 \
    || mysql -h "${DB_ADDR}" -P "${DB_PORT}" -u kitodo --password=kitodo kitodo < /tmp/schema.sql \
        && mysql -h "${DB_ADDR}" -P "${DB_PORT}" -u kitodo --password=kitodo kitodo < /tmp/default.sql \
        && /bin/sed -i \
                    "s,\(jdbc:mysql://\)[^/]*\(/.*\),\1${DB_ADDR}:${DB_PORT}\2," \
                    kitodo-production-master/Kitodo-DataManagement/src/main/resources/db/config/flyway.properties \
        && /bin/sed -i \
                    '/kitodo-api/!b;n;s,3\.0\.0-beta\.4-SNAPSHOT,3.0-SNAPSHOT,' kitodo-production-master/Kitodo-DataManagement/pom.xml \
        && (cd kitodo-production-master/Kitodo-DataManagement && mvn flyway:baseline -Pflyway && mvn flyway:migrate -Pflyway)

# Run CMD
"$@"
