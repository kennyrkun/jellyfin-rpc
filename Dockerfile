FROM python:3.14-slim

ENV PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends git

WORKDIR /app
RUN mkdir -p /app/config
ADD jellyfin_rpc.ini /app/config/jellyfin_rpc.ini

RUN pip install git+https://github.com/kennethsible/jellyfin-rpc.git

CMD ["jellyfin-rpc", "--ini-path", "/app/config"]
