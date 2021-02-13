FROM jolielang/jolie

RUN mkdir travelCompany
WORKDIR travelCompany

COPY TravelCompany.ol ./
COPY TravelCompanyInterface.iol ./
COPY travel_company.wsdl ./

EXPOSE 8080

CMD ["jolie", "TravelCompany.ol"]
