# DESCRIPTION:  Containerized Discord
# AUTHOR:        davidk
# COMMENTS:      This Dockerfile wraps Discord into a Docker container.
#                Based on Jess Frazelle's work at: https://github.com/jessfraz/
#
# USAGE:
#
#    # Build image
#    docker build -t discord --build-arg DOWNLOAD_LINK=PATH_TO_CANARY_OR_NORMAL_BUILD .
#
#    # Run it!
#    docker run -v /tmp/.X11-unix:/tmp/.X11-unix \
#    --device /dev/snd \
#    -v discordSettings:/home/discord \
#    -v /dev/shm:/dev/shm:z \
#    -v /etc/localtime:/etc/localtime:ro \
#    -v /var/run/dbus:/var/run/dbus \
#    -v /var/run/user/$(id -u)/bus:/var/run/user/1000/bus \
#    -e DBUS_SESSION_BUS_ADDRESS="unix:path=/var/run/user/1000/bus" \
#    -v /var/run/user/$(id -u)/pulse:/var/run/user/1000/pulse \
#    -e PULSE_SERVER="unix:/run/user/1000/pulse/native" \
#    -e DISPLAY=unix$DISPLAY --rm --group-add $(getent group audio | cut -d: -f3) discord
#
#    # If this fails, it might either be SELinux or
#    # just needing to allow access to your local X session
#    xhost local:root


FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
  libgl1 \
  libcurl4 \
  libgbm1 \
  libdrm2 \
  libc++1 \
  libappindicator1 \
  gconf2 \
  gconf-service \
  gvfs-bin \
  libasound2 \
  libcap2 \
  libgconf-2-4 \
  libgtk-3-0 \
  libcanberra-gtk3-module \
  libpulse0 \
  libnotify4 \
  libnss3 \
  libxkbfile1 \
  libxss1 \
  libxtst6 \
  libx11-xcb1 \
  xdg-utils \
  libatomic1 \
  fonts-noto-color-emoji \
  git \
  python3 \
  python3-pip \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get autoremove -y \
  && apt-get autoclean

ARG DOWNLOAD_LINK=https://discordapp.com/api/download?platform=linux&format=deb

RUN apt-get update && apt-get install -y \
  curl \
  ca-certificates \
  --no-install-recommends \
  && curl -sSL "${DOWNLOAD_LINK}" > discord.deb \
  && dpkg -i discord.deb \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get purge -y --auto-remove curl \
  && apt-get autoclean \
  && rm -f /etc/localtime

RUN pip install git+https://github.com/kennethsible/jellyfin-rpc.git

RUN mkdir -p /opt/jellyfin-rpc/config

# TODO: make this ENV configureable
RUN echo "America/Chicago" > /etc/timezone

COPY start.sh /opt/scripts/
RUN chmod +x /opt/scripts/start.sh

ENTRYPOINT [ "/opt/scripts/start.sh" ]
