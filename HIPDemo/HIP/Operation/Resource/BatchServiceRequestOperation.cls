Class HIP.Operation.Resource.BatchServiceRequestOperation Extends HIP.Core.AbstractResourceOperation
{

/// Must be overriden by sub class to record the resource name. I.e. "ODS.Patient"
/// Be aware that BatchServiceRequest is not aimed to be saved directly into ODS
/// It is used to support batch save of Service Request
Parameter RESOURCENAME = "ODS.BatchServiceRequest";

Parameter INVOCATION = "Queue";

Method OnCreate(pInstance As %Persistent, ByRef pResponse As HIP.Message.HIPRESTResponse, pRequest As HIP.Message.HIPRESTRequest) As %Status
{
	Set tSC = $$$OK
	try{
		Set pId = pInstance.Patient.ResourceId
		Set eId = pInstance.Encounter.ResourceId
		#Dim patInstance As HIP.DataModel.Patient = ##class(HIP.DataModel.Patient).%OpenId(pId)
		#Dim entInstance As HIP.DataModel.Encounter = ##class(HIP.DataModel.Encounter).%OpenId(eId)
		Set count = pInstance.ServiceRequests.Size
		Set saveList = ##class(%ListOfObjects).%New()
		For idx=1:1:count {
			set odsInst = pInstance.ServiceRequests.GetAt(idx)
			#Dim dataInst As HIP.DataModel.ServiceRequest = ""
			if ($IsObject(odsInst) && ("" '= odsInst)){
				Set tSC = ..GetDataModelFromODS(odsInst,.dataInst)
				if '$$$ISERR(tSC){
					Set dataInst.Subject = patInstance
					Set dataInst.Encounter = entInstance
					Do entInstance.ServiceRequests.Insert(dataInst)
					Do saveList.Insert(dataInst)
				}else{
					Set pResponse = ..OnSaveResponse(tSC,inst)
					Set tSC = $$$OK
					RETURN tSC
				}
			}
		}
		///TSTART
		for i=1:1:(saveList.Count()){
			set inst = saveList.GetAt(i)
			Set tSC = inst.%Save()
			If $$$ISERR(tSC){
				///TROLLBACK
				Set pResponse = ..OnSaveResponse(tSC,inst)
				Set tSC = $$$OK
				RETURN tSC
			}
		}
		///TCOMMIT
		Set pResponse = ..OnSaveResponse(tSC,saveList,"HIP.DataModel.ServiceRequest")
	}catch (unexpected){
		///TROLLBACK
		Set pResponse = ..OnSaveResponse(unexpected.AsStatus(),pRequest)
		Set tSC = $$$OK
	}
	Quit tSC
}

Method GetDataModelFromODS(odsInst As ODS.ServiceRequest, ByRef dataInst As HIP.DataModel.ServiceRequest) As %Status
{
	Set tSC = $$$OK
	Set tStream = ""
	Set tSC = ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.tStream,odsInst,,,,"s")
	Quit:$$$ISERR(tSC)
	set dataInst = ##class(HIP.DataModel.ServiceRequest).%New()
	Set tSC = ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(tStream,"HIP.DataModel.ServiceRequest",.dataInst,1)
	Quit tSC
}

}
