FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends git

WORKDIR /app
RUN pip install git+https://github.com/kennethsible/jellyfin-rpc.git

CMD ["jellyfin-rpc"]
