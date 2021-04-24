FROM jolielang/jolie

RUN apk add --update --no-cache python3 dos2unix && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

RUN mkdir travelCompany
WORKDIR travelCompany

COPY TravelCompany.ol ./
COPY TravelCompanyInterface.iol ./
COPY init_services.sh ./

EXPOSE 8080
EXPOSE 8000

RUN dos2unix init_services.sh

CMD ["./init_services.sh"]
