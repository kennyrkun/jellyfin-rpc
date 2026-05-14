FROM debian:stretch

RUN apt update && \
    apt install --yes --no-install-recommends \
        apt-utils \
        dbus-x11 \
        dunst \
        hunspell-en-us \
        python3-dbus \
        software-properties-common \
        libx11-xcb1 \
        gconf2 \
        libgtk2.0-0 \
        libxtst6 \
        libnss3 \
        libasound2 \
        libc++1 \
        libatomic1 \
        libnotify4 \
        libappindicator1 \
        python3
        python3-pip
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1

WORKDIR /app
RUN mkdir -p /app/config
ADD jellyfin_rpc.ini /app/config/jellyfin_rpc.ini

RUN pip install git+https://github.com/kennethsible/jellyfin-rpc.git

CMD ["jellyfin-rpc", "--ini-path", "/app/config"]

ENV URL https://discordapp.com/api/download?platform=linux&format=deb

RUN wget $URL -O discord.deb && \
    dpkg -i discord.deb && \
    rm discord.deb

CMD ["discord"]
