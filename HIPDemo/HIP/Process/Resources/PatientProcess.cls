Class HIP.Process.Resources.PatientProcess Extends HIP.Core.AbstractResourceProcess [ ClassType = persistent ]
{

/// Must be overriden by sub class to record the resource name. I.e. "ODS.Patient"
Parameter RESOURCENAME = "ODS.Patient";

Method OnRequest(pRequest As HIP.Message.HIPRESTRequest, Output pResponse As HIP.Message.HIPRESTResponse) As %Status
{
	Set tSC = $$$OK
	set patInstance = ""
	Set tSC =  ..GetResourceFromRESTReq(pRequest,.patInstance)
	
	//If unmarshall failed, make a failed response and return
	if $$$ISERR(tSC){
		set pResponse = ..OnUnmarshallError(tSC)
		quit tSC
	}
	//Invoke handlers to perform
	set tSC = $CASE(pRequest.Operation,
		"Create":..OnCreate(patInstance,.pResponse),
		"Delete":..OnDelete(pRequest,pResponse),
		"Update":..OnUpdate(patInstance,pResponse),
		"Search":..OnSearch(pRequest,pResponse),
		"Get":..OnGet(pRequest,pResponse)) 
	Quit tSC
}


/*Method OnCreate(pInstance As %Persistent, ByRef pResponse As HIP.Message.HIPRESTResponse) As %Status{
	quit ##super(.pInstance,.pResponse)
}



Method OnDelete(pRequest As HIP.Message.HIPRESTRequest, ByRef pResponse As HIP.Message.HIPRESTResponse) As %Status{
	quit ##super(.pRequest,.pResponse)
}

Method OnUpdate(pInstance As %Persistent, ByRef pResponse As HIP.Message.HIPRESTResponse) As %Status{
	quit ##super(.pInstance,.pResponse)
}

Method OnSearch(pRequest As HIP.Message.HIPRESTRequest, ByRef pResponse As HIP.Message.HIPRESTResponse) As %Status{
	quit ##super(.pRequest,.pResponse)
}

Method OnGet(pRequest As HIP.Message.HIPRESTRequest, ByRef pResponse As HIP.Message.HIPRESTResponse) As %Status{
	quit ##super(.pRequest,.pResponse)
}*/

Storage Default
{
<Type>%Library.CacheStorage</Type>
}

}
