FROM python:3.11-slim
#python version

WORKDIR /app 
#set working directory

RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
#copy requirements

RUN pip install --no-cache-dir -r requirements.txt
#install dependencies

COPY app.py . 
#copy app code

EXPOSE 5000 
#expose port

ENV APP_VERSION="Version 1 - Blue" 
#default env

CMD ["python", "app.py"] 
#run the app

