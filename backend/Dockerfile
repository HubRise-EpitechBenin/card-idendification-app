FROM python:3.8.10

ENV PYHTONUNBUFFERED=1

WORKDIR /hub-reception-system-core

COPY . .

RUN apt-get update \
    && apt-get -y install tesseract-ocr tesseract-ocr-fra tesseract-ocr-eng \
    && apt-get -y install ffmpeg libsm6 libxext6

RUN pip install -r requirements.txt

RUN python manage.py makemigrations && python manage.py migrate

EXPOSE 8080

CMD python manage.py runserver 0.0.0.0:8080 --noreload
