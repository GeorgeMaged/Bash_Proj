FROM ubuntu:20.04

WORKDIR /app

COPY db.sh .
#COPY index.html .
#COPY app.py .


RUN apt-get update && apt-get install -y \
    bash
RUN apt-get install -y coreutils bsdmainutils    

RUN chmod +x /app/db.sh

#RUN pip install flask


#EXPOSE 80
ENTRYPOINT [ "/app/db.sh" ]
