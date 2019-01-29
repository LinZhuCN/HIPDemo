Class HIP.Operation.Resource.EncounterOperation extends HIP.Core.AbstractResourceOperation{
	
/// Must be overriden by sub class to record the resource name. I.e. "ODS.Patient"
Parameter RESOURCENAME = "HIP.DataModel.Encounter";

Parameter INVOCATION = "Queue";
	

Method OnCreate(pInstance As %Persistent, ByRef pResponse As HIP.Message.HIPRESTResponse) As %Status{
	Set tSC = $$$OK
	#dim pInstance As HIP.DataModel.Encounter
	Set pId = pInstance.Subject.ResourceId
	Set patInstance = ##class(HIP.DataModel.Patient).%OpenId(pId)
	Set pInstance.Subject = patInstance
	Set tSC = ##super(pInstance,.pResponse)
	Quit tSC
}


}