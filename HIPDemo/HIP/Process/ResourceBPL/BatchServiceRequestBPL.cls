/// 
Class HIP.Process.ResourceBPL.BatchServiceRequestBPL Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='HIP.Message.HIPRESTRequest' response='HIP.Message.HIPRESTResponse' height='2000' width='2000' >
<context>
<property name='batchReq' type='ODS.BatchServiceRequest' instantiate='0' />
</context>
<sequence xend='200' yend='600' >
<switch name='AsOperation' xpos='200' ypos='250' xend='200' yend='500' >
<case condition='"Create" = request.Operation' name='IsCreate' >
<sequence name='CreateBatchServiceRequest' xpos='335' ypos='400' xend='201' yend='1091' >
<code name='GetBatchRequestInstance' xpos='200' ypos='250' >
<![CDATA[ set inst = ""
 do ##class(HIP.Core.Utils).GetResourceFromRESTReq(request,.inst,"ODS.BatchServiceRequest")
 set context.batchReq = inst]]>
</code>
<if name='DoesPatientIdMissing?' condition='"" = context.batchReq.Patient.ResourceId' xpos='200' ypos='350' xend='203' yend='967' >
<true>
<code name='MakePatientIdMissingResp' xpos='200' ypos='500' >
<![CDATA[ set response = ##class(HIP.Core.Utils).GetResMissingResp("ODS.BatchServiceRequest","ODS.Patient.ResourceId")]]>
</code>
</true>
<false>
<if name='DoesEncounterIdMissing?' condition='"" = context.batchReq.Encounter.ResourceId' xpos='470' ypos='500' xend='706' yend='1031' >
<true>
<code name='MakeEncounterIdMissingResp' xpos='1132' ypos='658' >
<![CDATA[ set response = ##class(HIP.Core.Utils).GetResMissingResp("ODS.BatchServiceRequest","ODS.Encounter.ResourceId")]]>
</code>
</true>
<false>
<call name='CallOperation' target='HIP.Operation.Resource.BatchServiceRequestOperation' async='0' xpos='362' ypos='633' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</false>
</if>
</false>
</if>
</sequence>
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
