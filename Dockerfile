# 1. TEST WITH:
# pull official base image
FROM python:3.8-alpine

# set work directory
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DEBUG 0
ENV SECRET_KEY fp$9^593hsriajg$_%=5trot9g!1qa@ew(o-1#@=&4%=hp46(s

## install psycopg2
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

# add and run as non-root user
RUN adduser -D myuser
USER myuser

# run gunicorn
CMD gunicorn core.wsgi --bind 0.0.0.0:$PORT


#2. TEST WITH:
## pull the official base image
#FROM python:3.8.3-alpine
#
## set work directory
#WORKDIR /usr/src/app
#
## set environment variables
#ENV PYTHONDONTWRITEBYTECODE 1
#ENV PYTHONUNBUFFERED 1
##ENV SECRET_KEY $SECRET_KEY
#
## install dependencies
#RUN pip install --upgrade pip
#COPY ./requirements.txt /usr/src/app
#RUN pip install -r requirements.txt
#
## copy project
#COPY . /usr/src/app
#
##EXPOSE 8000
##
#CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
#
##CMD gunicorn --bind 0.0.0.0:$PORT core.wsgi

#======
# RUN: (il n'y a pas de core/.env)
#dockebuild --tag django_todo:latest .
#docker run  SECRET_KEY='fp$9^593hsriajg$_%=5trot9g!1qa@ew(o-1#@=&4%=hp46(s' django_todo:latest python manage.py runserver
# Aller dans localhost:80000/
