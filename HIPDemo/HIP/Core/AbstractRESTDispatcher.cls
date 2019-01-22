Class HIP.Core.AbstractRESTDispatcher Extends %CSP.REST [ Abstract ]
{

/// This parameter influences the CORS support. The default is an empty string meaning 'not specified'.
/// If set to true (1) then CORS processing is ON. If set to false (0) then CORS processing is OFF.
/// If left unset "" then the decision to process CORS is delegated to the setting on the URL map route.
Parameter HandleCorsRequest As %Integer = 1;

/// DefaultContentType specifies the content type to use when no
/// content type is specified in the incoming request.  The FHIR
/// spec at http://www.hl7.org/fhir/DSTU2/http.html#mime-type is
/// not clear about defaulting, and defers to the spec for HTTP
/// Content Negotiation and Server-driven Negotiation at
/// http://www.w3.org/Protocols/rfc2616/rfc2616-sec12.html#sec12.
Parameter DefaultContentType As %String = "application/fhir+xml";

/// Per the FHIR spec, "FHIR uses UTF-8 for all request and response bodies."
/// (http://www.hl7.org/fhir/http.html#mime-type) Setting this parameter
/// to 1 (the default in %CSP.Page is 0) will cause CSP to convert the request
/// content to internal format before passing it to this handler (The equivalent
/// of doing $ZCVT(val, "I", "UTF8") on the request content).
Parameter CONVERTINPUTSTREAM = 1;

Parameter CONTENTTYPE = {..#CONTENTTYPEJSON};

Parameter CHARSET = "UTF-8";

Parameter UseSession As BOOLEAN = 1;

/// The business service to handle REST request
Parameter Handler As %String = "HIP.Service.RESTHandlerService";

}
