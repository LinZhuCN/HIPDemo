/// 
Class HIP.Process.ResourceBPL.PatientBPL Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='HIP.Message.HIPRESTRequest' response='HIP.Message.HIPRESTResponse' height='2000' width='2000' >
<sequence xend='192' yend='621' >
<call name='CallPatientBO' target='HIP.Operation.Resource.PatientOperation' async='0' xpos='200' ypos='349' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</sequence>
</process>
}

Storage Default
{
<Type>%Library.CacheStorage</Type>
}

}
