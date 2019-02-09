/// 
Class HIP.Process.ResourceBPL.EncounterBPL Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='HIP.Message.HIPRESTRequest' response='HIP.Message.HIPRESTResponse' height='2000' width='2000' >
<context>
<property name='ent' type='ODS.Encounter' instantiate='0' />
</context>
<sequence xend='200' yend='1300' >
<switch name='AsOperation' xpos='200' ypos='250' xend='200' yend='1200' >
<case condition='"Read" = request.Operation' name='IsRead' >
<call name='ReadOperation' target='HIP.Operation.Resource.EncounterOperation' async='0' xpos='335' ypos='400' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='"Create" = request.Operation' name='IsCreate' >
<code name='GetEncounterInstance' xpos='605' ypos='400' >
<![CDATA[ set inst = ""
 do ##class(HIP.Core.Utils).GetResourceFromRESTReq(request,.inst,"ODS.Encounter")
 set context.ent = inst]]>
</code>
<if name='DoesPatientRefMissing?' condition='"" = context.ent.Subject' xpos='605' ypos='500' xend='605' yend='1100' >
<true>
<code name='MakeDependantMissingResp' xpos='605' ypos='650' >
<![CDATA[ set response = ##class(HIP.Core.Utils).GetResMissingResp("ODS.Encounter","ODS.Patient")]]>
</code>
</true>
<false>
<call name='CreateOperation' target='HIP.Operation.Resource.EncounterOperation' async='0' xpos='892' ypos='796' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</false>
</if>
</case>
<default name='default' />
</switch>
</sequence>
</process>
}

Storage Default
{
<Type>%Library.CacheStorage</Type>
}

}
