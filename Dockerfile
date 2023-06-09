FROM python:3.10.7-alpine3.16

WORKDIR /src

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apk update && \
    apk add --no-cache python3 postgresql-libs && \
    apk add --no-cache --virtual .build-deps gcc python3-dev musl-dev postgresql-dev zlib-dev jpeg-dev musl-dev && \
    apk add --no-cache libc-dev make git libffi-dev openssl-dev libxml2-dev libxslt-dev

COPY requirements.txt /src
RUN python3 -m pip install -r requirements.txt --no-cache-dir && mkdir -m 777 media

COPY ./src/ .

RUN addgroup -S web && adduser -S web -G web \
   && chown web:web -R /src
USER web

ENTRYPOINT ["/src/entrypoint.sh"]