Class HIP.Operation.Resource.BatchObservationOperation Extends HIP.Core.AbstractResourceOperation
{
	/// Must be overriden by sub class to record the resource name. I.e. "ODS.Patient"
/// Be aware that BatchServiceRequest is not aimed to be saved directly into ODS
/// It is used to support batch save of Service Request
Parameter RESOURCENAME = "ODS.BatchObservation";

Parameter INVOCATION = "Queue";

Method OnCreate(pInstance As %Persistent, ByRef pResponse As HIP.Message.HIPRESTResponse, pRequest As HIP.Message.HIPRESTRequest) As %Status
{
	Set tSC = $$$OK
	try{
		Set eId = pInstance.Encounter.ResourceId
		#Dim entInstance As HIP.DataModel.Encounter = ##class(HIP.DataModel.Encounter).%OpenId(eId)
		If ('$IsObject(entInstance) || ("" = entInstance)){
			 set pResponse = ##class(HIP.Core.Utils).GetResNotExistResp("HIP.DataModel.Observation","HIP.DataModel.Encounter",eId)
			 Return $$$OK
		}
		Set count = pInstance.Observations.Size
		Set saveList = ##class(%ListOfObjects).%New()
		For idx=1:1:count {
			set odsInst = pInstance.Observations.GetAt(idx)
			#Dim dataInst As HIP.DataModel.Observation = ""
			if ($IsObject(odsInst) && ("" '= odsInst)){
				Set tSC = ..GetDataModelFromODS(odsInst,.dataInst)
				if '$$$ISERR(tSC){
					Set dataInst.Encounter = entInstance
					Do entInstance.ServiceRequests.Insert(dataInst)
					Do saveList.Insert(dataInst)
				}else{
					Set pResponse = ..OnSaveResponse(tSC,odsInst,..#RESOURCENAME)
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
				Set pResponse = ..OnSaveResponse(tSC,inst,"HIP.DataModel.Observation")
				Set tSC = $$$OK
				RETURN tSC
			}
		}
		///TCOMMIT
		Set pResponse = ..OnSaveResponse(tSC,saveList,..#RESOURCENAME)
	}catch (unexpected){
		///TROLLBACK
		Set pResponse = ..OnSaveResponse(unexpected.AsStatus(),pInstance,..#RESOURCENAME)
		Set tSC = $$$OK
	}
	Quit tSC
}

Method GetDataModelFromODS(odsInst As ODS.Observation, ByRef dataInst As HIP.DataModel.Observation) As %Status
{
	Set tSC = $$$OK
	Set tStream = ""
	Set tSC = ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.tStream,odsInst,,,,"s")
	Quit:$$$ISERR(tSC)
	set dataInst = ##class(HIP.DataModel.Observation).%New()
	Set tSC = ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(tStream,"HIP.DataModel.Observation",.dataInst,1)
	Quit tSC
}

}