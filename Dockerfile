# pull official base image
FROM python:3.8-alpine

# set work directory
#WORKDIR /app
WORKDIR /oc_project13

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DEBUG 0

# install psycopg2
#RUN apk update \
#    && apk add --virtual build-deps gcc python3-dev musl-dev \
#    && apk add postgresql-dev \
#    && pip install psycopg2 \
#    && apk del build-deps

# install dependencies
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# copy project
COPY . .

## collect static files
#RUN mkdir -p ./static
RUN python manage.py collectstatic --noinput

# add and run as non-root user
RUN adduser -D myuser
USER myuser

# run gunicorn
CMD gunicorn --bind 0.0.0.0:$PORT core.wsgi
#CMD gunicorn hello_django.wsgi:application --bind 0.0.0.0:$PORT




## syntax=docker/dockerfile:1
#FROM python:3.8
##ENV PYTHONUNBUFFERED=1
#ENV PYTHONDONTWRITEBYTECODE 1
#ENV PYTHONUNBUFFERED 1
#ENV DEBUG 0
#RUN mkdir oc_project13
#WORKDIR /oc_project13
#ADD . /oc_project13/
#RUN pip install -r requirements.txt
##CMD python manage.py runserver 0.0.0.0:$PORT --insecure
##EXPOSE 8000
##ENTRYPOINT ["python", "manage.py"]
## collect static files
#RUN python manage.py collectstatic --noinput
#
## add and run as non-root user
##RUN adduser -D myuser
##USER myuser
#
##CMD python manage.py runserver 0.0.0.0:$PORT
#CMD gunicorn core.wsgi:application --bind 0.0.0.0:$PORT