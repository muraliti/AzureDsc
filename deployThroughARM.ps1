#Connect to your Azure account
Login-AzureRmAccount

#Select your subscription if you have more than one
#Select-AzureSubscription -SubscriptionName "My Subscription Name"

$ResourceGroupName = "ArrowAutomation"
$AutomationAccountName = "dscAzureAutomation"
$Location = "westcentralus"

New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location
New-AzureRmAutomationAccount -ResourceGroupName $ResourceGroupName -Name $AutomationAccountName -Location $Location -Plan Free

$RegistrationInfo = Get-AzureRmAutomationRegistrationInfo -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName

#Set the parameter values for the template
$Params = @{
    accountName = $AutomationAccountName
    regionId = $Location
    registrationKey = $RegistrationInfo.PrimaryKey
    registrationUrl = $RegistrationInfo.Endpoint
    dscCompilationJobId = [System.Guid]::NewGuid().toString()
    runbookJobId = [System.Guid]::NewGuid().toString()
    jobScheduleId = [System.Guid]::NewGuid().toString()
    timestamp = (Get-Date).toString()
}

$ParametersJsonFile = $PSScriptRoot + '\azuredeploy-parameters.json'
$TemplatesJsonFile = $PSScriptRoot + '\azuredeploy.json'

New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateParameterObject $Params -TemplateFile $TemplatesJsonFile 

