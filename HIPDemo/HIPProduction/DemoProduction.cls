Class HIPProduction.DemoProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="HIPProduction.DemoProduction" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="HIP.Service.RESTHandlerService" Category="" ClassName="HIP.Service.RESTHandlerService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HIP.Process.RoutingProcess</Setting>
  </Item>
  <Item Name="HIP.Process.RoutingProcess" Category="" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="Validation"></Setting>
    <Setting Target="Host" Name="BusinessRuleName">HIP.Process.RoutingProcessRoutingRule</Setting>
    <Setting Target="Host" Name="ResponseFrom">*</Setting>
    <Setting Target="Host" Name="RuleLogging">a</Setting>
  </Item>
  <Item Name="HIP.Operation.Resource.PatientOperation" Category="" ClassName="HIP.Operation.Resource.PatientOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HIP.Operation.Resource.EncounterOperation" Category="" ClassName="HIP.Operation.Resource.EncounterOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HIP.Process.ResourceBPL.PatientBPL" Category="" ClassName="HIP.Process.ResourceBPL.PatientBPL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HIP.Process.ResourceBPL.EncounterBPL" Category="" ClassName="HIP.Process.ResourceBPL.EncounterBPL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="HIP.Operation.Resource.BatchServiceRequestOperation" Category="" ClassName="HIP.Operation.Resource.BatchServiceRequestOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TopicHandlerName">HIP.Process.EventEngine.EventHandlerBPL</Setting>
  </Item>
  <Item Name="HIP.Process.ResourceBPL.BatchServiceRequestBPL" Category="" ClassName="HIP.Process.ResourceBPL.BatchServiceRequestBPL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HIP.Operation.Resource.DiagnosisOperation" Category="" ClassName="HIP.Operation.Resource.DiagnosisOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HIP.Process.ResourceBPL.DiagnosisBPL" Category="" ClassName="HIP.Process.ResourceBPL.DiagnosisBPL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HIP.Operation.Resource.BatchObservationOperation" Category="" ClassName="HIP.Operation.Resource.BatchObservationOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HIP.Process.ResourceBPL.BatchObservationBPL" Category="" ClassName="HIP.Process.ResourceBPL.BatchObservationBPL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="EnsLib.PubSub.PubSubOperation" Category="" ClassName="EnsLib.PubSub.PubSubOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HIP.Process.EventEngine.EventHandlerBPL" Category="" ClassName="HIP.Process.EventEngine.EventHandlerBPL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HISSubscriber" Category="" ClassName="HIS.Proxy.Operation.HISServiceSoap" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SOAPCredentials">LocalSOAP</Setting>
  </Item>
  <Item Name="HIP.Operation.Resource.ServiceRequestOperation" Category="" ClassName="HIP.Operation.Resource.ServiceRequestOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HIP.Process.ResourceBPL.ServiceRequestBPL" Category="" ClassName="HIP.Process.ResourceBPL.ServiceRequestBPL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
