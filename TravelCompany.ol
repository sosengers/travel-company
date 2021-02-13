include "TravelCompanyInterface.iol"
include "console.iol"
include "time.iol"
include "string_utils.iol"

execution{ concurrent }

inputPort TravelCompany{
	Location:"socket://localhost:8080"
	Protocol: soap {
		.wsdl = "./travel_company.wsdl";
		.wsdl.port = "TravelCompany";
		.dropRootValue = true;
	}
	Interfaces: TravelCompanyInterface
}

init {
	println@Console("Travel company service started")();
	install (Fault400 => throw(Fault400, {description = main.Fault400.description}))
}

main {
	buyTransfers( request )( response ) {
		scope (dateFormatCheckingDepartureDateTime) {
			install ( InvalidTimestamp => {
				println@Console("Invalid date format in departure_transfer_datetime")();
				throw (Fault400, {description = "Invalid date format in departure_transfer_datetime"})
			})

			dateTime = request.departure_transfer_datetime;
			dateTime.format = "yyyy-MM-dd'T'HH:mm:ss"; 
			//dateTime.language =
			getTimestampFromString@Time(dateTime)(departureTransferTimestamp)
		}
		
		scope (dateFormatCheckingArrivalDateTime) {
			install ( InvalidTimestamp => {
				println@Console("Invalid date format in arrival_transfer_datetime")()
				throw (Fault400, {description = "Invalid date format in arrival_transfer_datetime"})
			})

			dateTime = request.arrival_transfer_datetime;
			dateTime.format = "yyyy-MM-dd'T'HH:mm:ss"; 
			//dateTime.language =
			getTimestampFromString@Time(dateTime)(arrivalTransferTimestamp)
		}
		
		//Error habdling not necessary because dates are verified
		if (arrivalTransferTimestamp <= departureTransferTimestamp) {
			throw (Fault400, {description = "departure_transfer_dateime greater than arrival_transfer_datetime"})
		}

		matchRequest = request.airport_code
		matchRequest.regex = "[A-Z]{3,3}"
		match@StringUtils(matchRequest)(airportCodeOK)
		if (airportCodeOK == 0) {
			throw(Fault400, {description = "airport_code not valid"})
		}

		response.response = "Tansport booked from " + request.customer_address + " to " + request.airport_code + " at: " + request.departure_transfer_datetime + " - " + request.arrival_transfer_datetime
	}
}
