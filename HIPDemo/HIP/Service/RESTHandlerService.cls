Class HIP.Service.RESTHandlerService Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Parameter SETTINGS = "TargetConfigName:Connection:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// Name of the target business host
Property TargetConfigName As %String;

Method OnProcessInput(pInput As HIP.Message.HIPRESTRequest, Output pOutput As HIP.Message.HIPRESTResponse) As %Status
{	
	do ..SendRequestSync(..TargetConfigName,pInput,.pOutput)
	Quit $$$OK
}

}
