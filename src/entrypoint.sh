#!/bin/sh

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $DB_HOST $DB_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

python manage.py migrate
python manage.py createcachetable
python manage.py collectstatic --no-input
gunicorn project.wsgi:application --bind 0.0.0.0:8000

exec "$@"