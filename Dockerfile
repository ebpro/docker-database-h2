FROM adoptopenjdk/openjdk11:jre-11.0.9_11-alpine

ENV RELEASE_DATE 2019-10-14
ENV H2DATA /h2-data

RUN echo "\e[93m**** Install S6 supervisor ****\e[38;5;241m" && \
       	wget -cO - https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.2/s6-overlay-amd64-installer > /tmp/s6-overlay-amd64-installer && \
        chmod +x /tmp/s6-overlay-amd64-installer && \
        chmod +x /tmp/s6-overlay-amd64-installer && \
        /tmp/s6-overlay-amd64-installer / && \
        rm /tmp/s6-overlay-amd64-installer && \
        mv /usr/bin/with-contenv /usr/bin/with-contenvb && \
        echo "\e[93m**** Create user 'user' ****\e[38;5;241m" && \
        adduser -u 2000 -D user user -s /bin/bash 

RUN apk add --update-cache bash shadow && rm -rf /var/cache/apk/* \
    && wget -cO - http://www.h2database.com/h2-$RELEASE_DATE.zip > /tmp/h2.zip \
    && unzip /tmp/h2.zip -d /tmp \
    && mv $(ls /tmp/h2/bin/*jar) /usr/local/bin/h2.jar \
    && rm -rf /tmp/h2.zip /tmp/h2 \
    && mkdir /docker-entrypoint-initdb.d

VOLUME /h2-data

EXPOSE 8082 9092

RUN echo -e "\e[93m**** Adds S6 scripts : services, user ids, ... ****\e[38;5;241m"
COPY /root /

ENTRYPOINT ["/init"]

#CMD java -cp /usr/local/bin/h2.jar org.h2.tools.Server \
#  -web -webAllowOthers -tcp -tcpAllowOthers -baseDir $H2DATA -ifNotExists
