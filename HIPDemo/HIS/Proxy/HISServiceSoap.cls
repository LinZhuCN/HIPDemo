Class HIS.Proxy.HISServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://localhost:57772/csp/healthshare/bloodtransfusion/BloodTransfusion.BS.HISService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://myhospital.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "HISService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method GetEvent(pRequest As HIS.Proxy.s0.HIPResourceEventMsg) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetEvent").Invoke($this,"http://myhospital.org/BloodTransfusion.BS.HISService.GetEvent",.pRequest)
}

}
