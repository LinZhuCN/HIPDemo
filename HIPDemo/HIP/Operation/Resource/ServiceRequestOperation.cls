Class HIP.Operation.Resource.ServiceRequestOperation Extends HIP.Core.AbstractResourceOperation
{

/// Must be overriden by sub class to record the resource name. I.e. "ODS.Patient"
Parameter RESOURCENAME = "HIP.DataModel.ServiceRequest";

Parameter INVOCATION = "Queue";

Method OnRead(pRequest As HIP.Message.HIPRESTRequest, ByRef pResponse As HIP.Message.HIPRESTResponse) As %Status
{
	set tSC = $$$OK
	try{
		set instId = pRequest.Id
		#dim pInstance As HIP.DataModel.ServiceRequest = $CLASSMETHOD(..#RESOURCENAME,"ResourceIdIdxOpen",instId)
		//set patInst = pInstance.Subject
		set entInst = pInstance.Encounter
		#dim odsInstance As ODS.ServiceRequest = ""
		do ..GetODSFromDataModel(pInstance,.odsInstance,"ODS.ServiceRequest")
		#dim odsEnt As ODS.Encounter = ""
		do ..GetODSFromDataModel(pInstance.Encounter,.odsEnt,"ODS.Encounter")
		set odsInstance.Encounter = odsEnt
		
		set resourceType = "ODS.ServiceRequest"
		set pResponse = ..OnReadResponse(tSC,odsInstance,pRequest,resourceType)
	}catch unexpected{
		set pResponse = ..OnReadResponse(unexpected.AsStatus(),pInstance,pRequest,resourceType)
		set tSC = $$$OK
	}
	quit tSC
}


Method GetODSFromDataModel(dataInst As HIP.DataModel.AbstractPersistentResource, ByRef odsInst As ODS.DT.AbstractResource, odsType As %String) As %Status
{
	Set tSC = $$$OK
	Set tStream = ""
	Set tSC = ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.tStream,dataInst,,,,"s")
	Quit:$$$ISERR(tSC)
	set odsInst = ""
	Set tSC = ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(tStream,odsType,.odsInst,1)
	Quit tSC
}

}
