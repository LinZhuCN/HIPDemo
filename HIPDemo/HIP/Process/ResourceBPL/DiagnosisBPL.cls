/// 
Class HIP.Process.ResourceBPL.DiagnosisBPL Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='HIP.Message.HIPRESTRequest' response='HIP.Message.HIPRESTResponse' height='2000' width='2000' >
<context>
<property name='diag' type='ODS.Diagnosis' instantiate='0' />
</context>
<sequence xend='200' yend='950' >
<switch name='AsOperation' xpos='200' ypos='250' xend='200' yend='850' >
<case condition='"Read" = request.Operation' name='IsRead' >
<call name='ReadOperation' target='HIP.Operation.Resource.DiagnosisOperation' async='0' xpos='335' ypos='400' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='"Create" = request.Operation' name='IsCreate' >
<code name='GetDiagnosisInstance' xpos='605' ypos='400' >
<![CDATA[ set inst = ""
 do ##class(HIP.Core.Utils).GetResourceFromRESTReq(request,.inst,"ODS.Diagnosis")
 set context.diag = inst]]>
</code>
<if name='DoesEncounterRefMissing?' condition='"" = context.diag.Encounter' xpos='605' ypos='500' xend='605' yend='750' >
<true>
<code name='MakeDependantMissingResp' xpos='875' ypos='650' >
<![CDATA[ set response = ##class(HIP.Core.Utils).GetResMissingResp("ODS.Diagnosis","ODS.Encounter")]]>
</code>
</true>
<false>
<call name='CreateOperation' target='HIP.Operation.Resource.DiagnosisOperation' async='0' xpos='605' ypos='650' >
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
