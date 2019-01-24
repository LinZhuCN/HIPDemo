Class HIP.Message.HIPRESTResponse Extends Ens.Response
{

Property Code As %String(MAXLEN = 8);

Property Event As %String(MAXLEN = 16);

Property Type As %String;

Property Message As %String(MAXLEN = 4096);

Property Payload As %Stream.GlobalCharacter;

Storage Default
{
<Data name="HIPRESTResponseDefaultData">
<Subscript>"HIPRESTResponse"</Subscript>
<Value name="1">
<Value>code</Value>
</Value>
<Value name="2">
<Value>event</Value>
</Value>
<Value name="3">
<Value>message</Value>
</Value>
<Value name="4">
<Value>Payload</Value>
</Value>
<Value name="5">
<Value>Code</Value>
</Value>
<Value name="6">
<Value>Event</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
<Value name="8">
<Value>Message</Value>
</Value>
</Data>
<DefaultData>HIPRESTResponseDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}
