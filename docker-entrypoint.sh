#!/bin/sh

# Database configuration
/bin/sed -i "s,\(jdbc:mysql://\)[^/]*\(/.*\),\1${DB_ADDR}:${DB_PORT}\2," ${CATALINA_HOME}/webapps/kitodo/WEB-INF/classes/hibernate.cfg.xml

# Wait for database container
/tmp/wait-for-it.sh -t 0 ${DB_ADDR}:${DB_PORT}

echo "SELECT 1 FROM benutzer LIMIT 1;" \
    | mysql -h "${DB_ADDR}" -P "${DB_PORT}" -u kitodo --password=kitodo kitodo >/dev/null 2>&1 \
    || (mysql -h "${DB_ADDR}" -P "${DB_PORT}" -u kitodo --password=kitodo kitodo < /tmp/schema.sql \
            && mysql -h "${DB_ADDR}" -P "${DB_PORT}" -u kitodo --password=kitodo kitodo < /tmp/default.sql)

# create/update configuration directory structure if necessary
(cd "${KITODO_HOME}"; mkdir -p config debug logs messages metadata plugins rulesets scripts swap tmp xslt)
# config
cp -ru "${CATALINA_HOME}/webapps/kitodo/WEB-INF/classes"/goobi_*.xml "${KITODO_HOME}/config"
cp -ru "${CATALINA_HOME}/webapps/kitodo/WEB-INF/classes"/modules.xml "${KITODO_HOME}/config"
# plugins
cp -ru "${CATALINA_HOME}/webapps/kitodo/plugins" "${KITODO_HOME}"
# rulesets
cp -ru "${CATALINA_HOME}/webapps/kitodo/rulesets" "${KITODO_HOME}"
# scripts
cp -ru "${CATALINA_HOME}/webapps/kitodo/scripts" "${KITODO_HOME}"
chmod +x "${KITODO_HOME}"/scripts/*
# xslt
cp -ru "${CATALINA_HOME}/webapps/kitodo/WEB-INF/classes"/docket*.xsl "${KITODO_HOME}/xslt"

# Run CMD
"$@"
