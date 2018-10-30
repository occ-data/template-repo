# To run: docker run -v /path/to/wsgi.py:/var/www/SERVICE_NAME/wsgi.py --name=SERVICE_NAME -p 81:80 SERVICE_NAME
# To check running container: docker exec -it SERVICE_NAME /bin/bash

FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

ENV appname=SERVICE_NAME

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    # dependency for cryptography
    libffi-dev \
    # dependency for pyscopg2 - which is dependency for sqlalchemy postgres engine
    libpq-dev \
    # dependency for cryptography
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    nginx \
    python2.7 \
    python-dev \
    python-pip \
    python-setuptools \
    sudo \
    vim \
    && pip install --upgrade pip==9.0.3 \
    && pip install --upgrade setuptools \
    && pip install uwsgi \
    && mkdir /var/www/$appname \
    && mkdir -p /var/www/.cache/Python-Eggs/ \
    && chown www-data -R /var/www/.cache/Python-Eggs/ \
    && mkdir /run/nginx/

COPY ./deployment/uwsgi/uwsgi.ini /etc/uwsgi/uwsgi.ini
COPY ./deployment/nginx/nginx.conf /etc/nginx/
COPY ./deployment/nginx/uwsgi.conf /etc/nginx/sites-available/
RUN rm /etc/nginx/sites-enabled/default \
    && ln -s /etc/nginx/sites-available/uwsgi.conf /etc/nginx/sites-enabled/uwsgi.conf \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && chown www-data /var/www/$appname

EXPOSE 80

COPY requirements.txt /$appname/requirements.txt
WORKDIR /$appname
RUN pip install -r requirements.txt

COPY . /$appname


RUN COMMIT=`git rev-parse HEAD` && echo "COMMIT=\"${COMMIT}\"" >$appname/version_data.py \
    && VERSION=`git describe --always --tags` && echo "VERSION=\"${VERSION}\"" >>$appname/version_data.py \
    && python setup.py install

CMD /$appname/dockerrun.bash