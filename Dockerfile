FROM openjdk:8u302-buster
RUN apt update
RUN apt install -y screen supervisor rsync
ENV ENABLE_WEBUI_CONSOLE=yes
ADD install/install.sh /root/
RUN chmod +x /root/install.sh
RUN /root/install.sh
ADD install/cn.sh /root
RUN chmod +x /root/cn.sh
RUN /root/cn.sh

VOLUME /config
EXPOSE 25565
EXPOSE 8222/tcp

ADD run/* /root/
RUN chmod +x /root/*.sh

CMD ["/bin/bash","/root/init.sh"]