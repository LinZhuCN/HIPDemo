Class HIP.BusinessService.RESTHandlerService Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Method OnProcessInput(pInput As HIP.Message.HIPRESTRequest, Output pOutput As HIP.Message.HIPRESTResponse) As %Status
{
	if pInput.%Extends("%String"){
	}else{
		if pInput.%Extends("%String"){
		}
	}
	Quit $$$ERROR($$$NotImplemented)
}

}
