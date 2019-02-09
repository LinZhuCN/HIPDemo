/// 
Class HIP.Process.EventEngine.EventHandlerBPL Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='HIP.Message.Events.HIPResourceEventMsg' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='Topic' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='1024' />
</parameters>
</property>
<property name='DomainName' type='%String' initialexpression='"HIP"' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='PubSubResp' type='EnsLib.PubSub.Response' instantiate='0' />
<property name='IterKey' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='PubTarget' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='800' >
<assign name="Add Resource Name To Topic" property="context.Topic" value="request.Type" action="set" xpos='200' ypos='250' />
<switch name='As Resource' xpos='200' ypos='350' xend='200' yend='600' >
<case condition='"ODS.ServiceRequest" = request.Type' name='IsServiceRequest' >
<sequence name='GetSubscribersForServiceRequest' xpos='335' ypos='500' xend='200' yend='800' >
<assign name="Set Event" property="context.Topic" value="context.Topic_&quot;.&quot;_request.Event" action="set" xpos='200' ypos='250' />
<if name='IsUpdate?' condition='"Updated" = request.Event' xpos='200' ypos='350' xend='200' yend='600' >
<true>
<trace name='update' value='"TO Be implemented"' xpos='335' ypos='500' />
</true>
</if>
<call name='Find Subsribers' target='EnsLib.PubSub.PubSubOperation' async='0' xpos='200' ypos='700' >
<request type='EnsLib.PubSub.Request' >
<assign property="callrequest.DomainName" value="context.DomainName" action="set" />
<assign property="callrequest.Topic" value="context.Topic" action="set" />
</request>
<response type='EnsLib.PubSub.Response' >
<assign property="context.PubSubResp" value="callresponse" action="set" />
</response>
</call>
</sequence>
</case>
<default name='default' />
</switch>
<foreach name='DispatchToSubsribers' property='context.PubSubResp.TargetList' key='context.IterKey' xpos='200' ypos='700' xend='200' yend='450' >
<assign name="GetTarget" property="context.PubTarget" value="context.PubSubResp.TargetList.GetAt(context.IterKey).Name" action="set" xpos='200' ypos='250' />
<call name='PublishTheEvent' target='@context.PubTarget' async='1' xpos='200' ypos='350' >
<request type='HIS.Proxy.Request.GetEventRequest' >
<assign property="callrequest.pRequest.Event" value="request.Event" action="set" />
<assign property="callrequest.pRequest.Type" value="request.Type" action="set" />
<assign property="callrequest.pRequest.ResourceId" value="request.ResourceId" action="set" />
<assign property="callrequest.pRequest.PreVersion" value="request.PreVersion" action="set" />
</request>
<response type='Ens.Response' />
</call>
</foreach>
</sequence>
</process>
}

Storage Default
{
<Type>%Library.CacheStorage</Type>
}

}
