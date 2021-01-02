FROM adoptopenjdk/openjdk11:jre-11.0.9_11-alpine

ENV RELEASE_DATE 2021-01-02
ENV H2DATA /h2-data

RUN curl http://www.h2database.com/h2-$RELEASE_DATE.zip -o h2.zip \
    && unzip h2.zip -d . \
    && mv $(ls /h2/bin/*jar) /usr/local/bin/h2.jar \
    && rm -rf h2.zip h2 \
    && mkdir /docker-entrypoint-initdb.d

VOLUME /h2-data

EXPOSE 8082 9092

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD java -cp /usr/local/bin/h2.jar org.h2.tools.Server \
  -web -webAllowOthers -tcp -tcpAllowOthers -baseDir $H2DATA
