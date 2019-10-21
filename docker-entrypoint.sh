#!/bin/sh

[ -e "${KITODO_CONF}/config/modules.xml" ] || \
    (wget -q "${KITODO_CONF}" -O kitodo_config.zip \
         && unzip -n -d "${KITODO_HOME}" kitodo_config.zip \
         && rm -f kitodo_config.zip)

[ -e "${KITODO_CONF}/modules" ] || \
    (wget -q "${KITODO_MODS}" -O kitodo_mods.zip \
         && mkdir -p "${KITODO_CONF}/modules" \
         && unzip -n -j -d "${KITODO_HOME}/modules" kitodo_mods.zip \
         && rm -f kitodo_mods.zip)

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
    || wget -q "${KITODO_SQL}" -O- \
        | mysql -h "${DB_ADDR}" -P "${DB_PORT}" -u kitodo --password=kitodo kitodo

# Run CMD
"$@"
