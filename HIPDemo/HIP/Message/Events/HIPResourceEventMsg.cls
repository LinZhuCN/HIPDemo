Class HIP.Message.Events.HIPResourceEventMsg Extends Ens.Request
{
	/// The entity type on which to perform this request
	Property Type As %String(MAXLEN = 128) ;

	/// The operation need to be performed, namely create,delete,update,search and read
	Property Event As %String(MAXLEN = 16, VALUELIST = ",Created,Deleted,Updated") ;
	
	Property ResourceId As %String;
	
	/// Current Status of the instance, to be used as a shotcut for event handling
Property Status As %String;
	
	/// For update use only, to save the previous version of the instance
	Property PreVersion As %Stream.GlobalCharacter;
Storage Default
{
<Data name="HIPResourceEventMsgDefaultData">
<Subscript>"HIPResourceEventMsg"</Subscript>
<Value name="1">
<Value>Type</Value>
</Value>
<Value name="2">
<Value>Event</Value>
</Value>
<Value name="3">
<Value>Instance</Value>
</Value>
<Value name="4">
<Value>preVerrsion</Value>
</Value>
<Value name="5">
<Value>ResourceId</Value>
</Value>
<Value name="6">
<Value>PreVersion</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
</Data>
<DefaultData>HIPResourceEventMsgDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}