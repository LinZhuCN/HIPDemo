Class HIS.Proxy.Request.GetEventRequest Extends Ens.Request [ ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "HIS.Proxy.Response.GetEventResponse";

Property pRequest As HIS.Proxy.s0.HIPResourceEventMsg;

Storage Default
{
<Data name="GetEventRequestDefaultData">
<Subscript>"GetEventRequest"</Subscript>
<Value name="1">
<Value>pRequest</Value>
</Value>
</Data>
<DefaultData>GetEventRequestDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}
