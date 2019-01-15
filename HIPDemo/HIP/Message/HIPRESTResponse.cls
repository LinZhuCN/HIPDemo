Class HIP.Message.HIPRESTResponse Extends Ens.Response
{

Property code As %String;

Property event As %String;

Property message As %String(MAXLEN = 1024);

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
</Data>
<DefaultData>HIPRESTResponseDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}
