Class HIP.Message.HIPRESTRequest Extends Ens.Request
{

Parameter RESPONSECLASSNAME As %String = "HIP.Message.HIPRESTResponse";

/// The entity type on which to perform this request
Property Type As %String(MAXLEN = 128) [ Required ];

/// The operation need to be performed, namely create,delete,update,search and read
Property Operation As %String(MAXLEN = 16, VALUELIST = ",Create,Delete,Update,Search,Read,BatchCreate") [ Required ];

/// Query Parameters
Property Parameters As array Of %List;

/// The resource ID
Property Id As %String(MAXLEN = 256);

/// The message payload
Property Payload As %Stream.GlobalCharacter;

Storage Default
{
<Data name="HIPRESTRequestDefaultData">
<Subscript>"HIPRESTRequest"</Subscript>
<Value name="1">
<Value>Type</Value>
</Value>
<Value name="2">
<Value>Operation</Value>
</Value>
<Value name="3">
<Value>Id</Value>
</Value>
<Value name="4">
<Value>Payload</Value>
</Value>
</Data>
<Data name="Parameters">
<Attribute>Parameters</Attribute>
<Structure>subnode</Structure>
<Subscript>"HIP.Message.HIPRESTRequest.Parameters"</Subscript>
</Data>
<DefaultData>HIPRESTRequestDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}
