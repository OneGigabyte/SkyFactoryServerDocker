FROM openjdk:8u302-buster
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ADD https://media.forgecdn.net/files/3012/800/SkyFactory-4_Server_4.2.2.zip /tmp/server.zip
RUN unzip -d /opt/server /tmp/server.zip
WORKDIR /opt/server
RUN chmod +x *.sh
RUN ./Install.sh
COPY eula.txt ./
RUN mv server.properties server.properties.bak
RUN sed -e "s/online-mode=true/online-mode=false/g" server.properties.bak > server.properties
ENTRYPOINT [ "/entrypoint.sh" ]
