Class HIP.REST.HIPDispatcher Extends (HIP.Core.AbstractRESTDispatcher, Ens.Util.JSON)
{

ClassMethod processCreate(pType As %String = "") As %Status
{
	#dim %request As %CSP.Request
	#dim tStatus As %Status = $$$OK
	Try {

		#dim tRequest As HIP.Message.HIPRESTMessage
		#dim tResponse As HS.Message.FHIR.Response
		
		If pParamCount < 0 {
			#dim tParam As %String
			
			Set pParamCount = 0
			For tParam = pType, pId, pVersion, pCompartment {
				Set:tParam'="" pParamCount = pParamCount+1
			}
		}

		// Construct a raw FHIR request
		Set tStatus = ..marshallRequest(pInteraction, pType, pId, pVersion, pCompartment, pParamCount, .tRequest)
		
		Set tErrorTextU = $ZConvert($system.Status.GetErrorText(tStatus),"U")
		
		If $$$ISOK(tStatus) {
			Set tServiceName = "HS.FHIR.Service"
			Set tServiceClass = tServiceName
			#; Hold the FHIR CSP Config data in a % variable or else this class does URLIndexOpen
			#; four times for each CSP request.  Set to 0 if object not found, to prevent the
			#; current CSP request from doing URLIndexOpen repeatedly in that scenario.
			If '$Data(%fhircspconfig) {
				Set tApplication = %request.Application
				If $Extract(tApplication, *)="/" Set tApplication = $Extract(tApplication, 1, *-1)
				Set %fhircspconfig = ##class(HS.Registry.FHIRCSPConfig).URLIndexOpen(tApplication)
				If '$IsObject($Get(%fhircspconfig)) Set %fhircspconfig = 0
			}
			If $IsObject($Get(%fhircspconfig)) {
				Set tServiceName = %fhircspconfig.ServiceConfigName
				Set tServiceClass = %fhircspconfig.ServiceClassName
				If tServiceClass="" Set tServiceClass = tServiceName
			}
			// Delegate the FHIR request into the FHIR service
			Set tStatus = ..delegateRequest(tServiceName, tServiceClass, tRequest, .tResponse)
			Quit:$$$ISERR(tStatus)
		} ElseIf (tErrorTextU["NO VALID ACCEPT DATA FOUND")||(tErrorTextU["INVALID CONTENT-TYPE") {
			Set tResponse = ##class(HS.Message.FHIR.Response).%New()
			Set tResponse.Status = ##class(HS.FHIR.Utils).#HTTP406NOTACCEPTABLE
			Set tStatus = ##class(HS.FHIR.Utils).CreateOperationOutcomeStream("error", $system.Status.GetErrorText(tStatus), .tStream, "xml", "not-supported", 0)
			If $$$ISOK(tStatus) Set tResponse.ContentType="text/xml" Do tResponse.Payload.CopyFrom(tStream)
		} ElseIf tErrorTextU["INVALID ACCESS TOKEN" {
			// Should have already been caught by OnPreDispatch, but providing for it here anyway.
			Set tResponse = ##class(HS.Message.FHIR.Response).%New()
			Set tResponse.Status = 401
		} Else {
			Set tStatus = ##class(HS.FHIR.Utils).OperationOutcomeFromStatus(tStatus, $S($D(tRequest):tRequest.ContentType, 1:..#DefaultContentType), .tResponse)
		}
		
		// Process the FHIR response back to the calling REST client
		Set tStatus = ..marshallResponse(tResponse)
		Quit:$$$ISERR(tStatus)
		
		Do ..LogCSPResponse("[HS.FHIR.REST.Handler:processRequest]", 1)
		
		// Done!

	} Catch (tUnexpected) {
		// Unexpected error ...
		Set tStatus = tUnexpected.AsStatus()
	}
	
	// NOTE: Any error %Status will be converted into a 500 Internal Server Error.  This is error handling of the last
	//       resort.  Normally, errors will have been converted into an OperationOutcome structure and returned.  Since
	//       this is a catch-all, we make no attempt to convert this error into anything; by default, %CSP.REST will
	//		 convert the %Status to JSON if the caller accepts it, otherwise it's reported as plain text.

	Kill %fhircspconfig
	
	Quit tStatus
}

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/:type/:id" 				Method="GET" 		Call="Read"/>
<Route Url="/:type/:id" 				Method="PUT" 		Call="Update"/>
<Route Url="/:type/:id" 				Method="DELETE" 	Call="Delete"/>
<Route Url="/:type" 					Method="POST" 		Call="processCreate"/>
<Route Url="/:type"			 			Method="GET" 		Call="Search"/>
</Routes>
}

}
