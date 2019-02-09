Class HIP.DataModel.Observation Extends (HIP.DataModel.AbstractPersistentResource, ODS.Observation)
{

Parameter XMLNAME = "HIP.DataModel.Observation";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "HIP.DataModel.Observation";

/// An encounter or episode of care that provides additional information about the healthcare context in which this request is made.
/// 就诊
Property Encounter As HIP.DataModel.Encounter(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="ObservationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ObsId</Value>
</Value>
<Value name="3">
<Value>Identifier</Value>
</Value>
<Value name="4">
<Value>Encounter</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>Category</Value>
</Value>
<Value name="7">
<Value>Code</Value>
</Value>
<Value name="8">
<Value>Subject</Value>
</Value>
<Value name="9">
<Value>EffectiveDateTime</Value>
</Value>
<Value name="10">
<Value>EffectivePeriod</Value>
</Value>
<Value name="11">
<Value>Performer</Value>
</Value>
<Value name="12">
<Value>ValueType</Value>
</Value>
<Value name="13">
<Value>Value</Value>
</Value>
<Value name="14">
<Value>DataAbsentReason</Value>
</Value>
<Value name="15">
<Value>Interpretation</Value>
</Value>
<Value name="16">
<Value>Comment</Value>
</Value>
<Value name="17">
<Value>BodySite</Value>
</Value>
<Value name="18">
<Value>Method</Value>
</Value>
<Value name="19">
<Value>ValueUnits</Value>
</Value>
<Value name="20">
<Value>ReferenceRange</Value>
</Value>
<Value name="21">
<Value>Specimen</Value>
</Value>
<Value name="22">
<Value>Clinician</Value>
</Value>
<Value name="23">
<Value>SubId</Value>
</Value>
</Data>
<DataLocation>^HIP.DataModel.ObservationD</DataLocation>
<DefaultData>ObservationDefaultData</DefaultData>
<IdLocation>^HIP.DataModel.ObservationD</IdLocation>
<IndexLocation>^HIP.DataModel.ObservationI</IndexLocation>
<StreamLocation>^HIP.DataModel.ObservationS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
