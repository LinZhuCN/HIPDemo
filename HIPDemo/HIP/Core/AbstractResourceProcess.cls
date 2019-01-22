/// Base Resource Process class
/// To create a new Resource Process, you need to:
/// 1. Override Parameter RESOURCENAME with the resource name. I.e. "ODS.Patient"
/// 2. Implement 5 resource operation method, namely OnCreate, OnDelete, OnUpdate, OnSearch, OnGet
/// you may refer to those provided by HIP.Core.AbstractResourceProcess to finish DB level operations such as saving an instance to ODS or Get an instance by ID
/// You can write your own method to implement more business and make use of those in HIP.Core.AbstractResourceProcess by calling <code>Do ##super()</code>

Class HIP.Core.AbstractResourceProcess Extends Ens.BusinessProcess [ Abstract ]
{


/// Must be overriden by sub class to record the resource name. I.e. "ODS.Patient"
Parameter RESOURCENAME AS %STRING;

/// An utility method to unmarshall json payload from HIP.Message.HIPRESTRequest to corresponding resource instance
Method GetResourceFromRESTReq(pRequest As HIP.Message.HIPRESTRequest, ByRef resInstance As ODS.DT.AbstractResource) As %Status
{
	Set tSC = $$$OK
	Set tSC = ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(pRequest.Payload, ..#RESOURCENAME,.resInstance)
	quit tSC
}

Method OnCreate(pInstance As %Persistent, ByRef pResponse As HIP.Message.HIPRESTResponse) As %Status{
	set tSC = $$$OK
	try{
		$$$TOE(tSC,pInstance.%Save())
		set pResponse = ..OnSaveResponse(tSC,pInstance)
	}catch unexpected{
		set pResponse = ..OnSaveResponse(unexpected.AsStatus(),pInstance)
		set tSC = $$$OK
	}
	quit tSC
}

Method OnDelete(pRequest As HIP.Message.HIPRESTRequest, ByRef pResponse As HIP.Message.HIPRESTResponse) As %Status{
	set instId = pRequest.Id
	set tSC = $CLASSMETHOD(..#RESOURCENAME,"%DeleteId",instId)
	quit tSC
}

Method OnUpdate(pInstance As %Persistent, ByRef pResponse As HIP.Message.HIPRESTResponse) As %Status{
	set tSC = pInstance.%Save()
	quit tSC
}

Method OnSearch(pRequest As HIP.Message.HIPRESTRequest, ByRef pResponse As HIP.Message.HIPRESTResponse) As %Status{
	Quit $$$ERROR($$$NotImplemented)
}

Method OnGet(pRequest As HIP.Message.HIPRESTRequest, ByRef pResponse As HIP.Message.HIPRESTResponse) As %Status{
	set instId = pRequest.Id
	set tSC = $CLASSMETHOD(..#RESOURCENAME,"%OpenId",instId)
	quit tSC
}

Method OnUnmarshallError(status As %Status) As HIP.Message.HIPRESTResponse{
	#dim resp As HIP.Message.HIPRESTResponse = ##class(HIP.Message.HIPRESTResponse).%New()
	set resp.Code = "400"
	set resp.Event= ""
	set resp.Message = $System.Status.GetOneStatusText(status,1)
	set resp.Payload = ""
	quit resp
}

Method OnSaveResponse(status As %Status,instance As ODS.DT.AbstractResource) As HIP.Message.HIPRESTResponse{
	#dim resp As HIP.Message.HIPRESTResponse = ##class(HIP.Message.HIPRESTResponse).%New()
	if $$$ISERR(status){
		set resp.Code = "400"
		set resp.Type = instance.%ClassName(0)
		set resp.Message = $System.Status.GetOneStatusText(status,1)
		//set resp.Message = $ZSTRIP($System.Status.GetOneStatusText(status,1),"*","\")
		set tStream = ""
		do ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.tStream,instance,,,1,"aelqo")
		set resp.Payload = tStream.Read()
	}else{
		set resp.Code = "200"
		set resp.Type = instance.%ClassName(0)
		set resp.Message= instance.%ClassName(0)_" Successfully saved into ODS."
		set tStream = ""
		do ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.tStream,instance,,,1,"aelqo")
		set resp.Payload = tStream.Read()
	}
	quit resp
}

Storage Default
{
<Type>%Library.CacheStorage</Type>
}

}
