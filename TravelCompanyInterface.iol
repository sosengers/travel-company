type buyTransfersRequest: void {
	.customer_address: string
	.airport_code: string
	.departure_transfer_datetime: string
	.arrival_transfer_datetime: string
	.customer_name: string
}

type buyTransfersResponse: void {
	.response: string
}

type buyTransfersError: void {
	.description: string
}

interface TravelCompanyInterface {
RequestResponse:
	buyTransfers( buyTransfersRequest )( buyTransfersResponse ) throws Fault400( buyTransfersError )
}

