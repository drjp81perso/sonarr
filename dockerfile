FROM drjp81/powershell

ARG DEBIAN_FRONTEND=noninteractive

# mono sources
RUN apt-get update && apt-get install -y  gnupg2 ca-certificates \
&& gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
&& echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list 

# mediainfo sources
ADD https://mediaarea.net/repo/deb/repo-mediaarea_1.0-25_all.deb ./repo-mediaarea_1.0-25_all.deb 
RUN dpkg -i repo-mediaarea_1.0-25_all.deb 

# sonarr sources
ADD https://services.sonarr.tv/v1/download/main/latest?version=4&os=linux /tmp/sonarr.tar.gz
RUN tar -xvzf /tmp/sonarr.tar.gz -C /opt \
&& rm /tmp/sonarr.tar.gz \
&& apt install -y mediainfo sqlite3 mono-complete

# cleanup
RUN rm -rf /var/lib/apt/lists/* \
&& rm -rf /tmp/*
EXPOSE 8989

#create outdir
RUN mkdir /config

#startup

CMD ["/opt/Sonarr/Sonarr", "-nobrowser", "-data=/config"]
