/// 患者
Class HIP.DataModel.Patient Extends (HIP.DataModel.AbstractPersistentResource, ODS.Patient)
{

Parameter XMLNAME = "HIP.DataModel.Patient";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "HIP.DataModel.Patient";

/// 就诊
Property Encounters As list Of HIP.DataModel.Encounter(XMLNAME = "Encounters", XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ResourceId</Value>
</Value>
<Value name="3">
<Value>Identifier</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>Gender</Value>
</Value>
<Value name="7">
<Value>BirthDate</Value>
</Value>
<Value name="8">
<Value>BirthTime</Value>
</Value>
<Value name="9">
<Value>Deceased</Value>
</Value>
<Value name="10">
<Value>DeceasedPlaceType</Value>
</Value>
<Value name="11">
<Value>DeceasedDateTime</Value>
</Value>
<Value name="12">
<Value>Address</Value>
</Value>
<Value name="13">
<Value>MaritalStatus</Value>
</Value>
<Value name="14">
<Value>Nationality</Value>
</Value>
<Value name="15">
<Value>Ethnic</Value>
</Value>
<Value name="16">
<Value>Occupation</Value>
</Value>
<Value name="17">
<Value>MultipleBirthBoolean</Value>
</Value>
<Value name="18">
<Value>MultipleBirthInteger</Value>
</Value>
<Value name="19">
<Value>VIP</Value>
</Value>
<Value name="20">
<Value>Encounters</Value>
</Value>
</Data>
<DataLocation>^HIP.DataModel.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<IdLocation>^HIP.DataModel.PatientD</IdLocation>
<IndexLocation>^HIP.DataModel.PatientI</IndexLocation>
<StreamLocation>^HIP.DataModel.PatientS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
