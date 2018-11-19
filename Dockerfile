# To run: docker run -v /path/to/wsgi.py:/var/www/service_name/wsgi.py --name=service_name -p 81:80 service_name
# To check running container: docker exec -it service_name /bin/bash


FROM tiangolo/uwsgi-nginx:python3.6-alpine3.7


ENV appname=service_name

# ensure www-data user exists
RUN addgroup -g 82 -S www-data \
    && adduser -u 82 -D -S -G www-data www-data

RUN apk update \
    && apk add postgresql-libs postgresql-dev libffi-dev libressl-dev \
    && apk add linux-headers musl-dev gcc \
    && apk add curl bash git vim

COPY . /$appname
COPY ./deployment/uwsgi/uwsgi.ini /etc/uwsgi/uwsgi.ini
COPY ./deployment/uwsgi/wsgi.py /$appname/wsgi.py
COPY ./deployment/nginx/nginx.conf /etc/nginx/
COPY ./deployment/nginx/uwsgi.conf /etc/nginx/conf.d/nginx.conf
WORKDIR /$appname

RUN python -m pip install --upgrade pip \
    && python -m pip install --upgrade setuptools \
    && pip install -r requirements.txt --src /usr/local/lib/python3.6/site-packages/

RUN mkdir -p /var/www/$appname \
    && mkdir -p /var/www/.cache/Python-Eggs/ \
    && mkdir /run/nginx/ \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && chown www-data -R /var/www/.cache/Python-Eggs/ \
    && chown www-data /var/www/$appname

EXPOSE 80

WORKDIR /var/www/$appname

CMD /$appname/dockerrun.bash
