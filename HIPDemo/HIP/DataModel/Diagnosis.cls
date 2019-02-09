Class HIP.DataModel.Diagnosis Extends (HIP.DataModel.AbstractPersistentResource, ODS.Diagnosis)
{

Parameter XMLNAME = "HIP.DataModel.Diagnosis";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "HIP.DataModel.Diagnosis";

/// An encounter or episode of care that provides additional information about the healthcare context in which this request is made.
/// 就诊
Property Encounter As HIP.DataModel.Encounter(XMLNAME = "encounter", XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="DiagnosisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Role</Value>
</Value>
<Value name="3">
<Value>Rank</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>StatusHistory</Value>
</Value>
<Value name="8">
<Value>OnsetTime</Value>
</Value>
<Value name="9">
<Value>IsPrimary</Value>
</Value>
<Value name="10">
<Value>GroupCode</Value>
</Value>
<Value name="11">
<Value>Encounter</Value>
</Value>
</Data>
<DataLocation>^HIP.DataModel.DiagnosisD</DataLocation>
<DefaultData>DiagnosisDefaultData</DefaultData>
<IdLocation>^HIP.DataModel.DiagnosisD</IdLocation>
<IndexLocation>^HIP.DataModel.DiagnosisI</IndexLocation>
<StreamLocation>^HIP.DataModel.DiagnosisS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
