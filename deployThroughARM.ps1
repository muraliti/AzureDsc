# Define All Global Constants Here

$test = "MyPassword"
$ParametersJsonFile = $PSScriptRoot + '\azuredeploy-parameters.json'
$TemplatesJsonFile = $PSScriptRoot + '\azuredeploy.json'


cls

# To make sure the Azure PowerShell module is available after you install
# Get-Module –ListAvailable

$pw = ConvertTo-SecureString $test -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("MyEmail@Domain.com",$pw) 
Add-AzureRmAccount -Credential $cred


# Azure Variables and Constants
$sub = Get-AzureRmSubscription 
$subId = $sub.SubscriptionId
$deploymentName = "InstallVM-ArrowAutomation-PowerShell-" +  $(get-date -f MM-dd-yyyy_HH_mm_ss)

$ResourceGroup_ArrowAutomation = 'ArrowAutomation'
$LocationWestCentralUS = "westcentralus"



#Select your subscription if you have more than one
#Select-AzureSubscription -SubscriptionName "My Subscription Name"

#$AutomationAccountName = [System.Guid]::NewGuid().toString()
$AutomationAccountName = "dscAzureAutomation"


#New-AzureRmResourceGroup -Name $ResourceGroupName -Location $LocationWestCentralUS
New-AzureRmAutomationAccount -ResourceGroupName $ResourceGroup_ArrowAutomation -Name $AutomationAccountName -Location $LocationWestCentralUS -Plan Free

$RegistrationInfo = Get-AzureRmAutomationRegistrationInfo -ResourceGroupName $ResourceGroup_ArrowAutomation -AutomationAccountName $AutomationAccountName

#Set the parameter values for the template
$Params = @{
    accountName = $AutomationAccountName
    regionId = $LocationWestCentralUS
    registrationKey = $RegistrationInfo.PrimaryKey
    registrationUrl = $RegistrationInfo.Endpoint
    dscCompilationJobId = [System.Guid]::NewGuid().toString()
    runbookJobId = [System.Guid]::NewGuid().toString()
    jobScheduleId = [System.Guid]::NewGuid().toString()
    timestamp = (Get-Date).toString()
}

#$TemplateURI = 'https://raw.githubusercontent.com/azureautomation/automation-packs/master/102-sample-automation-setup/azuredeploy.json'

New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroup_ArrowAutomation -TemplateParameterObject $Params -TemplateFile $TemplatesJsonFile
