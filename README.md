# Docker image for H2

A Docker image for the [H2 Database Engine](http://www.h2database.com/).

## Versions

Currently only the latest stable image is built, which according to
[this page](http://www.h2database.com/html/download.html) is
**Version 1.4.200 (2020-01-02)**.

## How to use this image

```sh
docker run --name my-h2 -d brunoe/h2database
```

The default TCP port 9092 is exposed, so standard container linking will make it
automatically available to the linked containers.

Use this JDBC string to connect from another container:

```
jdbc:h2:tcp://my-h2/my-db-name
```

## Using the web interface

If you want to connect to the H2 web interface, bind the port 8082:

```sh
docker run --name my-h2 -p 8082:8082 -d brunoe/h2
```

Then in your browser open http://localhost:8082/ and use the following
connection parameters:

Driver Class: org.h2.Driver
JDBC URL: jdbc:h2:my-db-name
User Name: _(empty)_
Password: _(empty)_

if you want to use the database from the host add port 8092

```sh
docker run --name my-h2 -p 8082:8082 -p 8092:8092 -d brunoe/h2
```

## Environment Variables

`H2DATA` specifies the location for the db files. If not set, `/h2-data` is used
which is automatically created as an anonymous Docker volume.

```sh
docker run --name my-h2 \
  -p 8082:8082 \
  -p 8092:8092 \
  -v myh2-data:/h2-data \
  -d brunoe/h2
```

## Initialization scripts

This image uses an initialization mechanism similar to the one used in the
[official Postgres image](https://hub.docker.com/_/postgres/).

You can add one or more `*.sql` or `*.sh` scripts under
/docker-entrypoint-initdb.d (creating the directory if necessary). The image
entrypoint script will run any `*.sql` files and source any `*.sh` scripts found
in that directory to do further initialization before starting the service.

The **name** of the `*.sql` files will be used as the name of the database. For
example, to create a table named "FOOBAR" in the "baz" database, add the
following content to `/docker-entrypoint-initdb.d/baz.sql`:

```
CREATE TABLE FOOBAR;
```

If you want to do something more complex, use a `.sh` script instead, for
example adding the following content to `/docker-entrypoint-initdb.d/init.sh`:

```
#!/bin/bash

java -cp /h2/bin/h2.jar org.h2.tools.RunScript \
  -script /docker-entrypoint-initdb.d/baz \
  -url "jdbc:h2:/h2-data/custom-db-name"
```
