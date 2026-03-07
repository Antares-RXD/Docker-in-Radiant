FROM ubuntu:22.04

LABEL maintainer="Antares - Discord: realantares"

RUN apt update && apt-get install -y wget

WORKDIR /var/tmp

RUN wget -q https://github.com/RadiantBlockchain-Community/radiant-blockbook/releases/download/v0.4.0/backend-radiant_1.3.0-radiant-community_amd64.deb

RUN wget -q https://github.com/RadiantBlockchain-Community/radiant-blockbook/releases/download/v0.4.0/blockbook-radiant_0.4.0_amd64.deb

RUN apt install ./backend-radiant_1.3.0-radiant-community_amd64.deb -y

RUN apt install ./blockbook-radiant_0.4.0_amd64.deb -y

WORKDIR /DATA

VOLUME /DATA

COPY script-blockbook.sh /script-blockbook.sh

RUN chmod 755 /script-blockbook.sh

#CMD tail -f /dev/null

ENTRYPOINT ["/bin/sh", "-c" , "/script-blockbook.sh"]
