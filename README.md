[![Docker Pulls](https://img.shields.io/docker/pulls/kitodo/production.svg)](https://hub.docker.com/r/kitodo/production/) [![Docker Stars](https://img.shields.io/docker/stars/kitodo/production.svg)](https://hub.docker.com/r/kitodo/production/)

# Kitodo.Production

Kitodo.Production is a workflow management tool for mass digitization and is part of the Kitodo Digital Library Suite.

Kitodo.Production supports various types of materials such as prints, periodicals, manuscripts, sheet music and typical documents of a *Nachlass*. The software is written in Java, uses Java Server Faces web technology to run on a [Tomcat Servlet container](http://tomcat.apache.org/), and is backed by a [MySQL](http://www.mysql.com) database utilizing the [Hibernate framework](http://www.hibernate.org) to access it.

## Kitodo. Digital Library Modules

[Kitodo](https://github.com/kitodo) is an open source software suite intended to support mass digitization projects for cultural heritage institutions. Kitodo is widely used and cooperatively maintained by major German libraries and digitization service providers. The software implements international standards such as METS, MODS, ALTO, and other formats maintained by the Library of Congress. Kitodo consists of several independent modules serving different purposes such as controlling the digitization workflow, enriching descriptive and structural metadata, and presenting the results to the public in a modern and convenient way.

For more information, visit the [Kitodo homepage](https://www.kitodo.org). You can also follow Kitodo News on [Twitter](https://twitter.com/kitodo_org).

## Docker instructions

The Docker images were built by [Mannheim University Library](https://en.wikipedia.org/wiki/Mannheim_University_Library).

Run the latest Docker images like this:

    docker run -d --name kitodo-database kitodo/database:latest
    docker run -d -p 8888:8080 --name kitodo-production \
               --link kitodo-database:mysql kitodo/production:latest

Then Kitodo.Production can be accessed at http://localhost:8888/kitodo.

## Code and User Feedback

This image is based on upstream code available at [GitHub](https://github.com/kitodo/kitodo-production). If you have any problems with or questions about this image specifically, you can contact us through a [GitHub issue](https://github.com/UB-Mannheim/kitodo-production-docker/issues).
