Class HIP.DataModel.ServiceRequest Extends (HIP.DataModel.AbstractPersistentResource, ODS.ServiceRequest)
{

Parameter XMLNAME = "HIP.DataModel.ServiceRequest";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "HIP.DataModel.ServiceRequest";

/// On whom or what the procedure or diagnostic is to be performed. This is usually a human patient, but can also be requested on animals, groups of humans or animals, devices such as dialysis machines, or even locations (typically for environmental scans).
/// 医嘱目标患者
Property Subject As HIP.DataModel.Patient(XMLNAME = "subject", XMLPROJECTION = "ELEMENT");

/// An encounter or episode of care that provides additional information about the healthcare context in which this request is made.
/// 就诊
Property Encounter As HIP.DataModel.Encounter(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

/// Assigns a persistent object Id value for this object. 
/// This method fails if the object already has an Id value assigned to it.
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
Method SetId(id As %String) As %Status
{
 	Set class=$classname(),class=$$$DenormalizeClassname(class),oid=$$$oidCompose(id,class)
	#; Check for previously assigned OID
	If i%"%%OID"'="",i%"%%OID"'=oid Quit $$$ERROR($$$OidPreviouslyAssigned,$classname(),id)
	#; store oid and allow lookup based on oid
	Set i%"%%OID"=oid $$$ActiveOidInsert(oid,$this)
	Quit $$$OK
}

Storage Default
{
<Data name="ServiceRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Identifier</Value>
</Value>
<Value name="3">
<Value>Encounter</Value>
</Value>
<Value name="4">
<Value>Requisition</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>Intent</Value>
</Value>
<Value name="7">
<Value>Priority</Value>
</Value>
<Value name="8">
<Value>DoNotPerform</Value>
</Value>
<Value name="9">
<Value>Category</Value>
</Value>
<Value name="10">
<Value>Code</Value>
</Value>
<Value name="11">
<Value>QuantityQuantity</Value>
</Value>
<Value name="12">
<Value>OccurrenceDateTime</Value>
</Value>
<Value name="13">
<Value>OccurrencePeriod</Value>
</Value>
<Value name="14">
<Value>AuthoredOn</Value>
</Value>
<Value name="15">
<Value>Requester</Value>
</Value>
<Value name="16">
<Value>PerformerType</Value>
</Value>
<Value name="17">
<Value>Performer</Value>
</Value>
<Value name="18">
<Value>ReasonCode</Value>
</Value>
<Value name="19">
<Value>BodySite</Value>
</Value>
<Value name="20">
<Value>Notes</Value>
</Value>
<Value name="21">
<Value>Extension</Value>
</Value>
<Value name="22">
<Value>Location</Value>
</Value>
<Value name="23">
<Value>OrderQuantity</Value>
</Value>
<Value name="24">
<Value>Subject</Value>
</Value>
</Data>
<DataLocation>^HIP.DataModel.ServiceRequestD</DataLocation>
<DefaultData>ServiceRequestDefaultData</DefaultData>
<IdLocation>^HIP.DataModel.ServiceRequestD</IdLocation>
<IndexLocation>^HIP.DataModel.ServiceRequestI</IndexLocation>
<StreamLocation>^HIP.DataModel.ServiceRequestS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
