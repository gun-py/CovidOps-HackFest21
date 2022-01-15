# start from base
FROM python:3.7.3-stretch
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y && \
   apt-get install -y libsndfile1 libgl1-mesa-glx libglib2.0-0

COPY ./requirements.txt /app/requirements.txt
RUN python -m pip install --upgrade pip
RUN pip install -r /app/requirements.txt

WORKDIR /app
#RUN pip3 install -r requirements.txt

COPY . /app

ENTRYPOINT ["./gunicorn.sh"]
#CMD ["python", "app.py"]