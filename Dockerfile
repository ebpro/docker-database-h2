FROM eclipse-temurin:11-jre-jammy

ENV H2_ARGS="-web -webAllowOthers -tcp -tcpAllowOthers -ifNotExists"
ENV H2_VERSION="2.1.214"
ENV H2_DATA="/h2-data"

RUN echo "\e[93m**** Install S6 supervisor ****\e[38;5;241m" && \
       wget -cO - https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-aarch64-installer > /tmp/s6-overlay-installer && \
#       wget -cO - https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64-installer > /tmp/s6-overlay-installer && \
#     	wget -cO - https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.2/s6-overlay-amd64-installer > /tmp/s6-overlay-installer && \
        chmod +x /tmp/s6-overlay-installer && \
        /tmp/s6-overlay-installer / && \
        rm /tmp/s6-overlay-installer && \
        mv /usr/bin/with-contenv /usr/bin/with-contenvb && \
        echo "\e[93m**** Create user 'user' ****\e[38;5;241m" && \
        adduser --uid 2000 --home /home/user --shell /bin/bash user
        # adduser -u 2000 -D user user -s /bin/bash
RUN wget -cO - https://repo1.maven.org/maven2/com/h2database/h2/${H2_VERSION}/h2-${H2_VERSION}.jar > /usr/local/bin/h2.jar \
      && mkdir /docker-entrypoint-initdb.d

VOLUME /h2-data

EXPOSE 8082 9092

RUN echo -e "\e[93m**** Adds S6 scripts : services, user ids, ... ****\e[38;5;241m"
COPY /root /

ENTRYPOINT ["/init"]
