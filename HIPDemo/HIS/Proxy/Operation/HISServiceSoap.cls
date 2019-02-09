Class HIS.Proxy.Operation.HISServiceSoap Extends Ens.BusinessOperation [ ProcedureBlock ]
{

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

Method GetEvent(pRequest As HIS.Proxy.Request.GetEventRequest, Output pResponse As HIS.Proxy.Response.GetEventResponse) As %Library.Status
{
 Set ..Adapter.WebServiceClientClass = "HIS.Proxy.HISServiceSoap"
 Set tSC = ..Adapter.InvokeMethod("GetEvent",.GetEventResult,pRequest.pRequest)  Quit:$$$ISERR(tSC) tSC
 Set tSC = pRequest.NewResponse(.pResponse)  Quit:$$$ISERR(tSC) tSC
 Set pResponse.GetEventResult=$get(GetEventResult)
 Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HIS.Proxy.Request.GetEventRequest">
		<Method>GetEvent</Method>
	</MapItem>
</MapItems>
}

}
