/// 
Class HIP.Process.RoutingProcessRoutingRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="HIPProduction.DemoProduction">
<ruleSet name="HIP资源路由规则集" effectiveBegin="" effectiveEnd="">
<rule name="HIPRESTRequest资源路由规则">
<constraint name="msgClass" value="HIP.Message.HIPRESTRequest"></constraint>
<when condition="Document.Type=&quot;Patient&quot;">
<send transform="" target="HIP.Process.ResourceBPL.PatientBPL"></send>
<return></return>
</when>
<when condition="Document.Type=&quot;Encounter&quot;">
<send transform="" target="HIP.Process.ResourceBPL.EncounterBPL"></send>
<return></return>
</when>
<when condition="Document.Type=&quot;BatchServiceRequest&quot;">
<send transform="" target="HIP.Process.ResourceBPL.BatchServiceRequestBPL"></send>
<return></return>
</when>
<when condition="Document.Type=&quot;Diagnosis&quot;">
<send transform="" target="HIP.Process.ResourceBPL.DiagnosisBPL"></send>
<return></return>
</when>
<when condition="Document.Type=&quot;BatchObservation&quot;">
<send transform="" target="HIP.Process.ResourceBPL.BatchObservationBPL"></send>
<return></return>
</when>
<when condition="Document.Type=&quot;ServiceRequest&quot;">
<send transform="" target="HIP.Process.ResourceBPL.ServiceRequestBPL"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
