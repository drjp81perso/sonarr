FROM drjp81/powershell
USER 0
ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Base tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 \
    ca-certificates \
    curl \
 && rm -rf /var/lib/apt/lists/*

# Mono sources
RUN curl -fsSL https://download.mono-project.com/repo/xamarin.gpg \
    | gpg --dearmor -o /usr/share/keyrings/mono-official-archive-keyring.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/ubuntu stable-focal main" \
    > /etc/apt/sources.list.d/mono-official-stable.list

# MediaInfo source
ADD https://mediaarea.net/repo/deb/repo-mediaarea_1.0-25_all.deb /tmp/repo-mediaarea_1.0-25_all.deb
RUN dpkg -i /tmp/repo-mediaarea_1.0-25_all.deb && rm -f /tmp/repo-mediaarea_1.0-25_all.deb

# Sonarr
ADD https://services.sonarr.tv/v1/download/main/latest?version=4&os=linux /tmp/sonarr.tar.gz
RUN mkdir -p /opt \
 && tar -xzf /tmp/sonarr.tar.gz -C /opt \
 && rm -f /tmp/sonarr.tar.gz

# Runtime packages only
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    mediainfo \
    sqlite3 \
    mono-runtime \
    ca-certificates-mono \
 && rm -rf /var/lib/apt/lists/* /tmp/*

EXPOSE 8989

RUN mkdir -p /config

CMD ["/opt/Sonarr/Sonarr", "-nobrowser", "-data=/config"]