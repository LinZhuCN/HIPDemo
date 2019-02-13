/// Created from: http://localhost:57772/csp/healthshare/bloodtransfusion/BloodTransfusion.BS.HISService.cls?wsdl
Class HIS.Proxy.s0.HIPResourceEventMsg Extends HIS.Proxy.s0.EnsRequest [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://myhospital.org";

Parameter XMLNAME = "HIPResourceEventMsg";

Property Type As %String(MAXLEN = 128, XMLNAME = "Type") [ Required ];

Property Event As %String(MAXLEN = 16, VALUELIST = ",Created,Deleted,Updated", XMLNAME = "Event") [ Required ];

Property Status As %String(XMLNAME = "Status");

Property ResourceId As %String(XMLNAME = "ResourceId") [ Required ];

Property PreVersion As %Stream.GlobalCharacter(XMLNAME = "PreVersion");

Storage Default
{
<Data name="HIPResourceEventMsgState">
<Subscript>"HIPResourceEventMsg"</Subscript>
<Value name="1">
<Value>Type</Value>
</Value>
<Value name="2">
<Value>Event</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
<Value name="4">
<Value>ResourceId</Value>
</Value>
<Value name="5">
<Value>PreVersion</Value>
</Value>
</Data>
<State>HIPResourceEventMsgState</State>
<Type>%Library.CacheSerialState</Type>
}

}
