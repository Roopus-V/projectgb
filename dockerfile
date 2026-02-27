From python:3.11.2 
#python version

WORKDIR /app 
#set working directory

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

