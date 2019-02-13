/// 
Class HIP.Process.ResourceBPL.BatchServiceRequestBPL Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='HIP.Message.HIPRESTRequest' response='HIP.Message.HIPRESTResponse' height='2000' width='2000' >
<context>
<property name='batchReq' type='ODS.BatchServiceRequest' instantiate='0' />
<property name='eventMsg' type='HIP.Message.Events.HIPResourceEventMsg' instantiate='0' />
<property name='idList' type='%String' collection='list' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='k1' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='idString' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='600' >
<switch name='AsOperation' xpos='200' ypos='250' xend='200' yend='500' >
<case condition='"Create" = request.Operation' name='IsCreate' >
<sequence name='CreateBatchServiceRequest' xpos='335' ypos='400' xend='200' yend='1400' >
<code name='GetBatchRequestInstance' xpos='200' ypos='250' >
<![CDATA[ set inst = ""
 do ##class(HIP.Core.Utils).GetResourceFromRESTReq(request,.inst,"ODS.BatchServiceRequest")
 set context.batchReq = inst]]>
</code>
<if name='DoesPatientIdMissing?' condition='"" = context.batchReq.Patient.ResourceId' xpos='200' ypos='350' xend='200' yend='1300' >
<true>
<code name='MakePatientIdMissingResp' xpos='200' ypos='500' >
<![CDATA[ set response = ##class(HIP.Core.Utils).GetResMissingResp("ODS.BatchServiceRequest","ODS.Patient.ResourceId")]]>
</code>
</true>
<false>
<if name='DoesEncounterIdMissing?' condition='"" = context.batchReq.Encounter.ResourceId' xpos='470' ypos='500' xend='470' yend='1200' >
<true>
<code name='MakeEncounterIdMissingResp' xpos='470' ypos='650' >
<![CDATA[ set response = ##class(HIP.Core.Utils).GetResMissingResp("ODS.BatchServiceRequest","ODS.Encounter.ResourceId")]]>
</code>
</true>
<false>
<call name='CallOperation' target='HIP.Operation.Resource.BatchServiceRequestOperation' async='0' xpos='740' ypos='650' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
<if name='ServiceRequestSaved' condition='"200" = response.Code' xpos='740' ypos='750' xend='740' yend='1100' >
<true>
<code name='BuildSavedIdList' xpos='875' ypos='900' >
<![CDATA[ Set idArr = $LFS(response.ResourceId,",")
 for i=1:1:($LL(idArr))
 {
     Do context.idList.Insert($LIST(idArr,i))
 }]]>
</code>
<foreach name='IterateSavedIdList' property='context.idList' key='context.k1' xpos='875' ypos='1000' xend='200' yend='1100' >
<assign name="GetOneId" property="context.idString" value="context.idList.GetAt(context.k1)" action="set" xpos='200' ypos='250' />
<if name='IdNotEmpty' condition='"" &apos;= context.idString' xpos='200' ypos='350' xend='200' yend='1000' >
<true>
<assign name="EventType_CreateServiceRequest" property="context.eventMsg.Type" value="&quot;ODS.ServiceRequest&quot;" action="set" xpos='335' ypos='500' />
<assign name="EventName_CreateServiceRequest" property="context.eventMsg.Event" value="&quot;Created&quot;" action="set" xpos='335' ypos='600' />
<assign name="ResourceId_CreateServiceRequest" property="context.eventMsg.ResourceId" value="context.idString" action="set" xpos='335' ypos='700' />
<call name='SendServiceRequestCreatedEvent' target='HIP.Process.EventEngine.EventHandlerBPL' async='1' xpos='335' ypos='800' >
<request type='HIP.Message.Events.HIPResourceEventMsg' >
<assign property="callrequest" value="context.eventMsg" action="set" />
</request>
<response type='Ens.Response' />
</call>
<assign name="ResetIdString" property="context.idString" value="&quot;&quot;" action="set" xpos='335' ypos='900' />
</true>
</if>
</foreach>
</true>
</if>
</false>
</if>
</false>
</if>
</sequence>
</case>
<case condition='"Update" = request.Operation' name='IsUpdate' >
<sequence name='UpdateBatchServiceRequest' xpos='605' ypos='400' xend='200' yend='1400' >
<code name='GetBatchRequestInstance' xpos='200' ypos='250' >
<![CDATA[ set inst = ""
 do ##class(HIP.Core.Utils).GetResourceFromRESTReq(request,.inst,"ODS.BatchServiceRequest")
 set context.batchReq = inst]]>
</code>
<if name='DoesPatientIdMissing?' condition='"" = context.batchReq.Patient.ResourceId' xpos='200' ypos='350' xend='200' yend='1300' >
<true>
<code name='MakePatientIdMissingResp' xpos='200' ypos='500' >
<![CDATA[ set response = ##class(HIP.Core.Utils).GetResMissingResp("ODS.BatchServiceRequest","ODS.Patient.ResourceId")]]>
</code>
</true>
<false>
<if name='DoesEncounterIdMissing?' condition='"" = context.batchReq.Encounter.ResourceId' xpos='470' ypos='500' xend='470' yend='1200' >
<true>
<code name='MakeEncounterIdMissingResp' xpos='470' ypos='650' >
<![CDATA[ set response = ##class(HIP.Core.Utils).GetResMissingResp("ODS.BatchServiceRequest","ODS.Encounter.ResourceId")]]>
</code>
</true>
<false>
<call name='CallUpdateOperation' target='HIP.Operation.Resource.BatchServiceRequestOperation' async='0' xpos='740' ypos='650' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
<if name='ServiceRequestUpdated' condition='"200" = response.Code' xpos='740' ypos='750' xend='740' yend='1100' >
<true>
<code name='BuildUpdatedIdList' xpos='875' ypos='900' >
<![CDATA[ Set idArr = $LFS(response.ResourceId,",")
 for i=1:1:($LL(idArr))
 {
     Do context.idList.Insert($LIST(idArr,i))
 }]]>
</code>
<foreach name='IterateUpdatedIdList' property='context.idList' key='context.k1' xpos='875' ypos='1000' xend='200' yend='1200' >
<assign name="GetOneId" property="context.idString" value="context.idList.GetAt(context.k1)" action="set" xpos='200' ypos='250' />
<if name='IdNotEmpty' condition='"" &apos;= context.idString' xpos='200' ypos='350' xend='200' yend='1100' >
<true>
<assign name="EventType_UpdateServiceRequest" property="context.eventMsg.Type" value="&quot;ODS.ServiceRequest&quot;" action="set" xpos='335' ypos='500' />
<assign name="EventName_UpdateServiceRequest" property="context.eventMsg.Event" value="&quot;Updated&quot;" action="set" xpos='335' ypos='600' />
<assign name="ResourceId_UpdateServiceRequest" property="context.eventMsg.ResourceId" value="context.idString" action="set" xpos='335' ypos='700' />
<assign name="Status_UpdateServiceRequest" property="context.eventMsg.Status" value="response.Status" action="set" xpos='335' ypos='800' />
<call name='SendServiceRequestCreatedEvent' target='HIP.Process.EventEngine.EventHandlerBPL' async='1' xpos='335' ypos='900' >
<request type='HIP.Message.Events.HIPResourceEventMsg' >
<assign property="callrequest" value="context.eventMsg" action="set" />
</request>
<response type='Ens.Response' />
</call>
<assign name="ResetIdString" property="context.idString" value="&quot;&quot;" action="set" xpos='335' ypos='1000' />
</true>
</if>
</foreach>
</true>
</if>
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
