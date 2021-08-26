# syntax=docker/dockerfile:1
FROM python:3
ENV PYTHONUNBUFFERED=1
RUN mkdir oc_project13
WORKDIR /oc_project13
ADD . /oc_project13/
RUN pip install -r requirements.txt
CMD python manage.py runserver 0.0.0.0:$PORT --insecure