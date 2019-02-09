/// 
Class HIP.Process.ResourceBPL.BatchObservationBPL Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='HIP.Message.HIPRESTRequest' response='HIP.Message.HIPRESTResponse' height='2000' width='2000' >
<context>
<property name='batchObs' type='ODS.BatchObservation' instantiate='0' />
</context>
<sequence xend='200' yend='950' >
<switch name='AsOperation' xpos='200' ypos='250' xend='200' yend='850' >
<case condition='"Create" = request.Operation' name='IsCreate' >
<code name='GetBatchObservationInstance' xpos='335' ypos='400' >
<![CDATA[ set inst = ""
 do ##class(HIP.Core.Utils).GetResourceFromRESTReq(request,.inst,"ODS.BatchObservation")
 set context.batchObs = inst]]>
</code>
<if name='DoesEncounterIdMissing?' condition='"" = context.batchObs.Encounter.ResourceId' xpos='335' ypos='500' xend='335' yend='750' >
<true>
<code name='MakeEncounterIdMissingResp' xpos='605' ypos='650' >
<![CDATA[ set response = ##class(HIP.Core.Utils).GetResMissingResp("ODS.BatchObservation","ODS.Encounter.ResourceId")]]>
</code>
</true>
<false>
<call name='CallOperation' target='HIP.Operation.Resource.BatchObservationOperation' async='0' xpos='335' ypos='650' >
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
