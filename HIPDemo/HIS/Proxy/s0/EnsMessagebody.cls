/// Created from: http://localhost:57772/csp/healthshare/bloodtransfusion/BloodTransfusion.BS.HISService.cls?wsdl
Class HIS.Proxy.s0.EnsMessagebody Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://myhospital.org";

Parameter XMLNAME = "Ens_Messagebody";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "Ens_Messagebody";

Storage Default
{
<StreamLocation>^HIS.Proxy.s0.EnsMessagebodyS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
