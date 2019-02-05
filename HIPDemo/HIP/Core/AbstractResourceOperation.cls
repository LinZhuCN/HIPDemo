Class HIP.Core.AbstractResourceOperation Extends Ens.BusinessOperation [ Abstract,NOEXTENT ]
{

Parameter INVOCATION = "Queue";

/// Must be overriden by sub class to record the resource name. I.e. "ODS.Patient"
Parameter RESOURCENAME AS %STRING;

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HIP.Message.HIPRESTRequest"> 
		<Method>OnRequest</Method>
	</MapItem>
</MapItems>
}


Method OnRequest(pRequest As HIP.Message.HIPRESTRequest, Output pResponse As HIP.Message.HIPRESTResponse) As %Status
{
	Set tSC = $$$OK
	Set tInstance = ""
	if (("Create" = pRequest.Operation) || ("Update" = pRequest.Operation)){
		Set tSC =  ..GetResourceFromRESTReq(pRequest,.tInstance)
		Quit:$$$ISERR(tSC)
	}
	//Invoke handlers to perform
	set tSC = $CASE(pRequest.Operation,
		"Create":..OnCreate(tInstance,.pResponse,pRequest),
		"Delete":..OnDelete(pRequest,.pResponse),
		"Update":..OnUpdate(tInstance,.pResponse,pRequest),
		"Search":..OnSearch(pRequest,.pResponse),
		"Read":..OnRead(pRequest,.pResponse))
		
	Quit tSC
}


Method OnCreate(pInstance As %Persistent, ByRef pResponse As HIP.Message.HIPRESTResponse, pRequest As HIP.Message.HIPRESTRequest) As %Status{
	Set tSC = $$$OK
	try{
		$$$TOE(tSC,pInstance.%Save())
		Set pResponse = ..OnSaveResponse(tSC,pInstance)
	}catch unexpected{
		Set pResponse = ..OnSaveResponse(unexpected.AsStatus(),pInstance)
		Set tSC = $$$OK
	}
	quit tSC
}



Method OnDelete(pRequest As HIP.Message.HIPRESTRequest, ByRef pResponse As HIP.Message.HIPRESTResponse) As %Status{
	set instId = pRequest.Id
	set tSC = $CLASSMETHOD(..#RESOURCENAME,"%DeleteId",instId)
	quit tSC
}

Method OnUpdate(pInstance As %Persistent, ByRef pResponse As HIP.Message.HIPRESTResponse, pRequest As HIP.Message.HIPRESTRequest) As %Status{
	set tSC = pInstance.%Save()
	quit tSC
}

Method OnSearch(pRequest As HIP.Message.HIPRESTRequest, ByRef pResponse As HIP.Message.HIPRESTResponse) As %Status{
	Quit $$$ERROR($$$NotImplemented)
}

Method OnRead(pRequest As HIP.Message.HIPRESTRequest, ByRef pResponse As HIP.Message.HIPRESTResponse) As %Status{
	set tSC = $$$OK
	try{
		set instId = pRequest.Id
		set pInstance = $CLASSMETHOD(..#RESOURCENAME,"ResourceIdIdxOpen",instId)
		set resourceType = ..#RESOURCENAME
		set pResponse = ..OnReadResponse(tSC,pInstance,pRequest,resourceType)
	}catch unexpected{
		set pResponse = ..OnReadResponse(unexpected.AsStatus(),pInstance,pRequest,resourceType)
		set tSC = $$$OK
	}
	quit tSC
}

Method OnUnmarshallError(status As %Status) As HIP.Message.HIPRESTResponse{
	#dim resp As HIP.Message.HIPRESTResponse = ##class(HIP.Message.HIPRESTResponse).%New()
	set resp.Code = ##class(HIP.Core.Utils).#BADREQUEST
	set resp.Event= ""
	set resp.Message = $System.Status.GetOneStatusText(status,1)
	set resp.Payload = ""
	quit resp
}

Method OnSaveResponse(status As %Status,instance As ODS.DT.AbstractResource, className As %String = "") As HIP.Message.HIPRESTResponse{
	#dim resp As HIP.Message.HIPRESTResponse = ##class(HIP.Message.HIPRESTResponse).%New()
	if $$$ISERR(status){
		set resp.Code = ##class(HIP.Core.Utils).#NOTACCEPTABLE
		if ("" = className) {
			set resp.Type = instance.%ClassName(0)
		}else{
			set resp.Type = className
		}
		set resp.Message = $System.Status.GetOneStatusText(status,1)
		set tStream = ""
		do ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.tStream,instance,,,,"s")
		Set tSC = resp.Payload.CopyFrom(tStream)
		quit:$$$ISERR(tSC)
	}else{
		set resp.Code = ##class(HIP.Core.Utils).#OK
		if ("" = className) {
			set resp.Type = instance.%ClassName(0)
		}else{
			set resp.Type = className
		}
		set resp.Message= resp.Type_" Successfully saved into ODS."
		set tStream = ""
		do ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.tStream,instance,,,,"s")
		Set tSC = resp.Payload.CopyFrom(tStream)
		quit:$$$ISERR(tSC)
	}
	quit resp
}

Method OnReadResponse(status As %Status,instance As ODS.DT.AbstractResource, pRequest As HIP.Message.HIPRESTRequest, resourceType As %String) As HIP.Message.HIPRESTResponse{
	#dim resp As HIP.Message.HIPRESTResponse = ##class(HIP.Message.HIPRESTResponse).%New()
	if $$$ISERR(status){
		set resp.Code = ##class(HIP.Core.Utils).#BADREQUEST
		set resp.Type = resourceType
		set resp.Message = $System.Status.GetOneStatusText(status,1)
		set tStream = ""
		do ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.tStream,pRequest,,,,"s")
		Set tSC = resp.Payload.CopyFrom(tStream)
		quit:$$$ISERR(tSC)
	}else{
		if (($data(instance)) && ("" '= instance)){
			set resp.Code = ##class(HIP.Core.Utils).#OK
			set resp.Type = instance.%ClassName(0)
			set resp.Message= instance.%ClassName(0)_ " found in ODS."
			set tStream = ""
			do ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.tStream,instance,,,,"as")
			Set tSC = resp.Payload.CopyFrom(tStream)
			quit:$$$ISERR(tSC)
		}else{
			set resp.Code = ##class(HIP.Core.Utils).#NOTFOUND
			set resp.Type = resourceType
			set resp.Message= resourceType_" with ResourceId=" _ pRequest.Id _ " not found in ODS."
		}
	}
	quit resp
}

/// An utility method to unmarshall json payload from HIP.Message.HIPRESTRequest to corresponding resource instance
ClassMethod GetResourceFromRESTReq(pRequest As HIP.Message.HIPRESTRequest, ByRef resInstance As ODS.DT.AbstractResource) As %Status
{
	Set tSC = $$$OK
	Set tSC = ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(pRequest.Payload, ..#RESOURCENAME,.resInstance)
	quit tSC
}

/// An utility method to unmarshall json array payload from HIP.Message.HIPRESTRequest to corresponding resource list
ClassMethod GetResourceListFromRESTReq(pRequest As HIP.Message.HIPRESTRequest, ByRef objList As %ListOfObjects) As %Status
{
	Set tSC = $$$OK
	Set tSC = ..getObjectListFromJSONArray(pRequest.Payload,..#RESOURCENAME,.objList)
	quit tSC
}

/// Get an Object List from a JSON stream
/// Assuming that all members in the JSON array are of the same type of <var>tierOneClass</var>
ClassMethod getObjectListFromJSONArray(inStream As %Stream.Object, tierOneClass As %String, ByRef list As %ListOfObjects) As %Status
{	
	Set tSC = $$$OK
	Set objList = ##class(%DynamicObject).%FromJSON(inStream.Read())
	//If the stream does not contain a JSON list, quit as an empty string
	if '(objList.%IsA("%Library.DynamicArray")){
		quit ""
	}
	Set list = ##class(%ListOfObjects).%New()
	for i=1:1:objList.%Size(){
		Set tStream = ""
		Set obj = objList.%Get(i)
		Set jsonStr = obj.%ToJSON()
		Set inst = ""
		Set tSC = ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(jsonStr, tierOneClass,.inst,1)
		quit:$$$ISERR(tSC)
		if ("" '= tierOneClass) {
			do list.Insert(inst)
		}
	}
	quit tSC
}

}
