#!/bin/bash
JAVA_HOME=/opt/java/openjdk
PATH=$JAVA_HOME/bin:$PATH
java -cp /usr/local/bin/h2.jar org.h2.tools.Server \
  -web -webAllowOthers -tcp -tcpAllowOthers -baseDir $H2DATA -ifNotExists

