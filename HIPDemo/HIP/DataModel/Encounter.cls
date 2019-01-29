/// 一次就诊
Class HIP.DataModel.Encounter Extends (HIP.DataModel.AbstractPersistentResource, ODS.Encounter)
{

Parameter XMLNAME = "HIP.DataModel.Encounter";

Parameter XMLSEQUENCE = 1;

Parameter XMLTYPE = "HIP.DataModel.Encounter";

/// The patient ro group present at the encounter.
Property Subject As HIP.DataModel.Patient(XMLNAME = "subject", XMLPROJECTION = "ELEMENT") [required];



Storage Default
{
<Data name="EncounterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Identifier</Value>
</Value>
<Value name="3">
<Value>Subject</Value>
</Value>
<Value name="4">
<Value>Class</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
<Value name="6">
<Value>Priority</Value>
</Value>
<Value name="7">
<Value>IncomingReferral</Value>
</Value>
<Value name="8">
<Value>Participant</Value>
</Value>
<Value name="9">
<Value>Period</Value>
</Value>
<Value name="10">
<Value>Length</Value>
</Value>
<Value name="11">
<Value>Reason</Value>
</Value>
<Value name="12">
<Value>Hospitalization</Value>
</Value>
<Value name="13">
<Value>Location</Value>
</Value>
<Value name="14">
<Value>Extension</Value>
</Value>
<Value name="15">
<Value>ServiceRequests</Value>
</Value>
<Value name="16">
<Value>Observations</Value>
</Value>
<Value name="17">
<Value>Diagnoses</Value>
</Value>
</Data>
<DataLocation>^HIP.DataModel.EncounterD</DataLocation>
<DefaultData>EncounterDefaultData</DefaultData>
<IdLocation>^HIP.DataModel.EncounterD</IdLocation>
<IndexLocation>^HIP.DataModel.EncounterI</IndexLocation>
<StreamLocation>^HIP.DataModel.EncounterS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
