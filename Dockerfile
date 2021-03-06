FROM python:3.6-slim-stretch

LABEL maintainer="Simon Kassel <skassel@azavea.com>"

WORKDIR /opt/src/

ADD requirements.txt /tmp/requirements.txt

RUN apt-get update && \
    apt-get install -y \
        wget \
        build-essential \
        make \
        gcc \
        locales \
        libgdal20 libgdal-dev \
        python-dev \
        protobuf-compiler \
        libprotobuf-dev \
        libtokyocabinet-dev \
        python-psycopg2 \
        libspatialindex-dev && \
    python -m pip install numpy cython --no-binary numpy,cython && \
    python -m pip install \
        "rasterio>=1.0a12" fiona shapely rtree \
        --pre --no-binary rasterio,fiona,shapely && \
    python -m pip install -r /tmp/requirements.txt && \
    python -m pip uninstall -y cython && \
    rm -r /root/.cache/pip && \
    apt-get remove -y --purge libgdal-dev make gcc build-essential && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

ENV LC_ALL C.UTF-8
ENV PYTHONPATH="$PYTHONPATH:/opt/src/"

# Open Ports for Jupyter
EXPOSE 8888

# Run a shell script
CMD  ["/bin/bash"]


