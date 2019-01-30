Class HIP.Operation.Resource.EncounterOperation extends HIP.Core.AbstractResourceOperation{
	
/// Must be overriden by sub class to record the resource name. I.e. "ODS.Patient"
Parameter RESOURCENAME = "HIP.DataModel.Encounter";

Parameter INVOCATION = "Queue";
	

Method OnCreate(pInstance As %Persistent, ByRef pResponse As HIP.Message.HIPRESTResponse, pRequest As HIP.Message.HIPRESTRequest) As %Status{
	Set tSC = $$$OK
	#dim pInstance As HIP.DataModel.Encounter
	Set pId = pInstance.Subject.ResourceId
	#dim patInstance As HIP.DataModel.Patient
	try{
		Set patInstance = ##class(HIP.DataModel.Patient).%OpenId(pId)
		Set pInstance.Subject = patInstance
		do patInstance.Encounters.Insert(pInstance)
		Set tSC = ##super(pInstance,.pResponse)
	}catch (unexpected){
		Set pResponse = ..OnSaveResponse(unexpected.AsStatus(),pRequest)
		Set tSC = $$$OK
	}
	Quit tSC
}


}