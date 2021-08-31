# Dockerfile

# pull official base image (python:3.8-buster is less sensible than python:3.8-alpine for Sqlite).
FROM python:3.8-buster

# set work directory
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DEBUG 0

# set arg and env for sensive parameters

# set a defaut value
ARG SECRET=secret
ENV SECRET_KEY=${SECRET}

# set a defaut value
ARG DSN=dsn
ENV DSN_SENTRY=${DSN}

# install dependencies
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# copy project
COPY . .

# collect static files
RUN python manage.py collectstatic --noinput

# run gunicorn
CMD gunicorn core.wsgi --bind 0.0.0.0:$PORT
