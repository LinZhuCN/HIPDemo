Include (HS.Common, HS.FHIR.Errors, EnsErrors, %occSAX, %occErrors)

/// Helpful utilities
Class HIP.Core.Utils
{

Parameter CONTENTTYPEANY As %String = "*/*";

Parameter CONTENTTYPEXML As %String = "application/xml";

Parameter CONTENTTYPEJSON As %String = "application/json";

Parameter CONTENTTYPETEXTPLAIN As %String = "text/plain";

Parameter HTTPLOCATION As %String = "Location";

Parameter HTTPACCEPT As %String = "Accept";

Parameter HTTPCONTENTLOCATION As %String = "Content-Location";

///HTTP200OK
Parameter OK As %String = "200";

///HTTP400BADREQUEST
Parameter BADREQUEST As %String = "400";

///HTTP404NOTFOUND
Parameter NOTFOUND As %String = "404";

///HTTP406NOTACCEPTABLE
Parameter NOTACCEPTABLE As %String = "406";

///HTTP500INTERNALSERVERERROR
Parameter INTERNALSERVERERROR As %String = "500";

///HTTP502BADGATEWAY
Parameter BADGATEWAY As %String = "502";

///HTTP503SERVICEUNAVAILABLE
Parameter SERVICEUNAVAILABLE As %String = "503";

/// 
/// Convert common %Status values into HTTP status codes.  Note: this is not exhaustive
/// 
ClassMethod StatusToHttp(pStatus As %Status, ByRef pHttpStatus As %String = "") As %Status
{
    #dim tStatus As %Status = $$$OK
    Try {

		// Map common errors
		#dim tCodes As %String = $system.Status.GetErrorCodes(pStatus)
		#dim tIndex
		
		For tIndex = 1:1:$LENGTH(tCodes,",") {
			#dim tCode As %String
			#dim tMatch As %String
			
			Set tCode = $PIECE(tCodes,",",tIndex)
			
			// Try to match the %Status code
			Set tMatch = $CASE(tCode,
					$$$LoadObjectNotFound:						..#NOTFOUND,
					$$$HSFHIRErrEntityNotFound:					..#NOTFOUND,
					$$$HSFHIRErrUrlNotMatchedToInteraction:		..#NOTFOUND,
					$$$HSFHIRErrPayloadMissing:					..#BADREQUEST,
					$$$HSFHIRErrPayloadUnexpected:				..#BADREQUEST,
					$$$HSFHIRErrContentTypeNotSupported:		..#NOTACCEPTABLE,
					$$$EnsErrProductionNotRunning:				..#SERVICEUNAVAILABLE,
					$$$EnsErrBusinessDispatchNameNotRegistered:	..#BADGATEWAY,
					:"")
								
			If tMatch'="" {
				Set pHttpStatus = tMatch
				Quit
			}
		}

    } Catch (tEx) {
	    Set tStatus = tEx.AsStatus()
    }
    
    Quit tStatus
}

/// An utility method to unmarshall json payload from HIP.Message.HIPRESTRequest to corresponding resource instance
/// type: the full resource class name, i.e. "ODS.Patient"
ClassMethod GetResourceFromRESTReq(pRequest As HIP.Message.HIPRESTRequest, ByRef resInstance As ODS.DT.AbstractResource, type As %String) As %Status
{
	Set tSC = $$$OK
	Set tSC = ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(pRequest.Payload, type,.resInstance)
	quit tSC
}

///Make a response message with Dependent Resource missing Error
ClassMethod GetResMissingResp(resourceName as %String, dependentResName As %String) As HIP.Message.HIPRESTResponse{
	#dim resp As HIP.Message.HIPRESTResponse = ##class(HIP.Message.HIPRESTResponse).%New()
	set resp.Code = ..#BADREQUEST
	set resp.Message = resourceName _" dependent Resource " _ dependentResName _" doest not exist in request"
	quit resp
}

///Make a response message with Resource not Existence Error
ClassMethod GetResNotExistResp(resourceName as %String, dependentResName As %String, dependentResId As %String) As HIP.Message.HIPRESTResponse{
	#dim resp As HIP.Message.HIPRESTResponse = ##class(HIP.Message.HIPRESTResponse).%New()
	set resp.Code = ..#NOTACCEPTABLE
	set resp.Message = resourceName _" dependent Resource " _ dependentResName _" with ResourceId:"_dependentResId_" doest not exist"
	quit resp
}

}
