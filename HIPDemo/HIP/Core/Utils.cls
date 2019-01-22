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

Parameter HTTP200OK As %String = "200 OK";

Parameter HTTP400BADREQUEST As %String = "400 Bad Request";

Parameter HTTP404NOTFOUND As %String = "404 Not Found";

Parameter HTTP406NOTACCEPTABLE As %String = "406 Not Acceptable";

Parameter HTTP500INTERNALSERVERERROR As %String = "500 Internal Server Error";

Parameter HTTP502BADGATEWAY As %String = "502 Bad Gateway";

Parameter HTTP503SERVICEUNAVAILABLE As %String = "503 Service Unavailable";

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
					$$$LoadObjectNotFound:						..#HTTP404NOTFOUND,
					$$$HSFHIRErrEntityNotFound:					..#HTTP404NOTFOUND,
					$$$HSFHIRErrUrlNotMatchedToInteraction:		..#HTTP404NOTFOUND,
					$$$HSFHIRErrPayloadMissing:					..#HTTP400BADREQUEST,
					$$$HSFHIRErrPayloadUnexpected:				..#HTTP400BADREQUEST,
					$$$HSFHIRErrContentTypeNotSupported:		..#HTTP406NOTACCEPTABLE,
					$$$EnsErrProductionNotRunning:				..#HTTP503SERVICEUNAVAILABLE,
					$$$EnsErrBusinessDispatchNameNotRegistered:	..#HTTP502BADGATEWAY,
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


}
