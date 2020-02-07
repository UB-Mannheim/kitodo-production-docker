#!/bin/sh

# Database configuration
/bin/sed -i "s,\(jdbc:mysql://\)[^/]*\(/.*\),\1${DB_ADDR}:${DB_PORT}\2," ${CATALINA_HOME}/webapps/kitodo/WEB-INF/classes/hibernate.cfg.xml

# Wait for database container
/tmp/wait-for-it.sh -t 0 ${DB_ADDR}:${DB_PORT}

echo "SELECT 1 FROM benutzer LIMIT 1;" \
    | mysql -h "${DB_ADDR}" -P "${DB_PORT}" -u kitodo --password=kitodo kitodo >/dev/null 2>&1 \
    || (mysql -h "${DB_ADDR}" -P "${DB_PORT}" -u kitodo --password=kitodo kitodo < /tmp/schema.sql \
            && mysql -h "${DB_ADDR}" -P "${DB_PORT}" -u kitodo --password=kitodo kitodo < /tmp/default.sql)

# Run CMD
"$@"
