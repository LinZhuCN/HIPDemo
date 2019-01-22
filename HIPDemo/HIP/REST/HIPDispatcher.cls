Class HIP.REST.HIPDispatcher Extends (HIP.Core.AbstractRESTDispatcher, Ens.Util.JSON)
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/:type/:id" 				Method="GET" 		Call="Read"/>
<Route Url="/:type/:id" 				Method="PUT" 		Call="Update"/>
<Route Url="/:type/:id" 				Method="DELETE" 	Call="Delete"/>
<Route Url="/:type" 					Method="POST" 		Call="Create"/>
<Route Url="/:type"			 			Method="GET" 		Call="Search"/>
</Routes>
}

/// Read a specific resource instance.
/// Use GET Method
ClassMethod Read(pType As %String, pId As %String) As %Status
{
	Quit ..processRequest("Read", pType, pId)
}

/// The update interaction creates a new current version for an existing resource or creates a new resource if no resource already exists for the given id
/// Use PUT Method
ClassMethod Update(pType As %String, pId As %String) As %Status
{
	Quit ..processRequest("Update", pType, pId)
}

/// The delete interaction removes an existing resource
/// Use DELETE method
ClassMethod Delete(pType As %String, pId As %String) As %Status
{
	Quit ..processRequest("Delete", pType, pId)
}

/// The create interaction creates a new resource in a server assigned location.
/// Use POST Method
ClassMethod Create(pType As %String) As %Status
{
	Quit ..processRequest("Create", pType)
}

/// This interaction searches a set of resources based on some filter criteria.
/// Use GET Method
ClassMethod Search(pType As %String) As %Status
{
	Quit ..processRequest("Search", pType)
}

/// This REST API will invoke ODS BusinessService to handle resource request
/// All corresponding BusinessService should be names as "HIP.BusinessService.[ResourceName]Service"
/// I.e. HIP.BusinessService.PatientService
ClassMethod processRequest(pInteraction As %String, pType As %String = "", pId As %String = "") As %Status
{
	#dim %request As %CSP.Request
	#dim tStatus As %Status = $$$OK
	Try {

		#dim tRequest As HIP.Message.HIPRESTRequest
		#dim tResponse As HIP.Message.HIPRESTResponse
		
		/// Construct a raw request
		Set tStatus = ..marshallRequest(pInteraction, pType, pId, .tRequest)
		
		Set tErrorTextU = $ZConvert($system.Status.GetErrorText(tStatus),"U")
		
		If $$$ISOK(tStatus) {
			Set tServiceClass = ..#Handler
			Set tServiceName = tServiceClass
			
			// Delegate the request into the business service
			Set tStatus = ..delegateRequest(tServiceName, tServiceClass, tRequest, .tResponse)
			Quit:$$$ISERR(tStatus)
		} 
		
		// Process the response back to the calling REST client
		Set tStatus = ..marshallResponse(tResponse)
		Quit:$$$ISERR(tStatus)
		
		// Done!*/

	} Catch (tUnexpected) {
		// Unexpected error ...
		Set tStatus = tUnexpected.AsStatus()
	}
	
	// NOTE: Any error %Status will be converted into a 500 Internal Server Error.  This is error handling of the last
	//       resort.  Normally, errors will have been converted into an OperationOutcome structure and returned.  Since
	//       this is a catch-all, we make no attempt to convert this error into anything; by default, %CSP.REST will
	//		 convert the %Status to JSON if the caller accepts it, otherwise it's reported as plain text.
	
	Quit tStatus
}

/// 
/// Marshall the incoming REST request into a message ready for dispatch to business service
/// 
ClassMethod marshallRequest(pInteraction As %String, pType As %String, pId As %String, ByRef pRequest As HIP.Message.HIPRESTRequest) As %Status [ Internal ]
{
	#dim tStatus As %Status = $$$OK
	Try {
		
		#dim tKey As %String
		#dim tSubKey As %String
		#dim tItem As %String
		#dim tHeader As %String
		#dim tContentType As %String
		#dim %request As %CSP.Request
		
		// Construct a new FHIR request object and populate it with the contents of the HTTP request
		Set pRequest = ##class(HIP.Message.HIPRESTRequest).%New()		
		
		Set pRequest.Operation = pInteraction
		Set pRequest.Type = pType
		Set pRequest.Id = pId
		
		// Copy in any HTTP query values
		Set tKey = ""
		For {
			Set tKey = $ORDER(%request.Data(tKey))
			Quit:tKey=""
			
			// Look for subkeys in case of duplicate query parameters
			Set (tSubKey, tItem) = ""
			For {
				Set tSubKey = $ORDER(%request.Data(tKey,tSubKey))
				Quit:tSubKey=""
				
				// NOTE: We store this as a $LIST of possible values in order of appearance
				Set tItem = tItem_$LB(%request.Data(tKey,tSubKey))
			}
			
			// Copy the URL query parameters
			Do pRequest.Parameters.SetAt(tItem, tKey)
		}
		
		// Copy the HTTP body (if any)
		If $IsObject(%request.Content) {
		// Copy the incoming payload
				Set pRequest.Payload = %request.Content.Read()
		}

	} Catch (tUnexpected) {
		Set tStatus = tUnexpected.AsStatus()
	}
	Quit tStatus
}

/// 
/// Delegate a  request to  business service
/// 
ClassMethod delegateRequest(pServiceName As %String, pServiceClass As %String, pRequest As HIP.Message.HIPRESTRequest, ByRef pResponse As HIP.Message.HIPRESTResponse) As %Status [ Internal ]
{
	#dim tStatus As %Status = $$$OK
	Try {
		#dim tStatus2 As %Status
		
		// Dispatch to the business service
		Set tStatus2 = ##class(Ens.Director).CreateBusinessService(pServiceName,.srcInstance)
		set tStatus2 = srcInstance.OnProcessInput(pRequest, .pResponse)
		
		// NOTE: The business service will map normal runtime errors into an OperationOutcome structure
		//       Any %Status errors here are fatal operational errors (such as production not running,
		//       class does not exist etc).
		//
		//       However, there are some validation and processing errors in the business service that we
		//       can attempt to map to a HTTP status (e.g. Bad Requests).

		#dim tHttpStatus As %String = ""
		
		Set tStatus = ##class(HIP.Core.Utils).StatusToHttp(tStatus2,.tHttpStatus)
		Quit:$$$ISERR(tStatus)
		
		// We were able to map the %Status to something ... let's go with that.
		If tHttpStatus'="" {
			Set tStatus = pRequest.NewResponse(.pResponse)
			Quit:$$$ISERR(tStatus)
			// Write the error to the payload
			set pResponse.Message = $system.Status.GetErrorText(tStatus2)
		} Else {
			// No appropriate HTTP status code, so we'll return the error which will end up as a 500 Internal Server Error
			Set tStatus = tStatus2
		}
	} Catch (tUnexpected) {
		Set tStatus = tUnexpected.AsStatus()
	}
	Quit tStatus
}

/// 
/// Marshall a raw HS.Message.FHIR.Response message out onto the wire
/// 
ClassMethod marshallResponse(pResponse As HIP.Message.HIPRESTResponse, pDefaultStatus As %String = {##class(HIP.Core.Utils).#HTTP200OK}) As %Status [ Internal ]
{
	
	#dim tStatus As %Status = $$$OK
	Try {
		
		#dim %response As %CSP.Response
		#dim tKey As %String
		#dim tValue As %String
		#dim tHTTPCode As %String
		#dim tHTTPStatus As %String

		

		// Set up HTTP response code
		Set tHTTPCode = $SELECT(pResponse.Code'="":pResponse.Code,1:pDefaultStatus)
		Set %response.Status = +tHTTPCode 
				
		// Set the content type
		Set %response.ContentType = ##class(HIP.Core.Utils).#CONTENTTYPEJSON
		Set %response.CharSet = "UTF-8"
		
		//zw pResponse
		set tStream = ""		
		d ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.tStream,pResponse,,,1,"sbn")
		set rtnStr = tStream.Read()
		
		//set rtnStr = $ZSTRIP(rtnStr,"*","\")
		w rtnStr
		//w tStream.Read()
		
		
	} Catch (tUnexpected) {
		Set tStatus = tUnexpected.AsStatus()
	}
	
    Quit tStatus
}

}
