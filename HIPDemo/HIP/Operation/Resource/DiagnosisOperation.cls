Class HIP.Operation.Resource.DiagnosisOperation Extends HIP.Core.AbstractResourceOperation
{
	/// Must be overriden by sub class to record the resource name. I.e. "ODS.Patient"
Parameter RESOURCENAME = "HIP.DataModel.Diagnosis";

Parameter INVOCATION = "Queue";

Method OnCreate(pInstance As %Persistent, ByRef pResponse As HIP.Message.HIPRESTResponse, pRequest As HIP.Message.HIPRESTRequest) As %Status
{
	Set tSC = $$$OK
	#dim pInstance As HIP.DataModel.Diagnosis
	Set eId = pInstance.Encounter.ResourceId
	#dim entInstance As HIP.DataModel.Encounter
	try{
		Set entInstance = ##class(HIP.DataModel.Encounter).%OpenId(eId)
		Set pInstance.Encounter = entInstance
		if ($ISOBJECT(entInstance) && ("" '= entInstance)) {
			do entInstance.Diagnoses.Insert(pInstance)
		}
		Set tSC = ##super(pInstance,.pResponse)
	}catch (unexpected){
		Set pResponse = ..OnSaveResponse(unexpected.AsStatus(),pRequest)
		Set tSC = $$$OK
	}
	Quit tSC
}

}