[DscLocalConfigurationManager()]
Configuration ConfigureLCMforAAPull
{
    param
    (
        [Parameter(Mandatory=$True)]
        $RegistrationUrl,

        [Parameter(Mandatory=$True)]
        [PSCredential]$RegistrationKey,

        [Int]$RefreshFrequencyMins = 30,
            
        [Int]$ConfigurationModeFrequencyMins = 15,
            
        [String]$ConfigurationMode = "ApplyAndMonitor",
            
        [String]$NodeConfigurationName = "SimpleConfig.DSCVM01.webserver",

        [Boolean]$RebootNodeIfNeeded= $True,

        [String]$ActionAfterReboot = "ContinueConfiguration",

        [Boolean]$AllowModuleOverwrite = $True,

        [String]$Timestamp = ""
    )

    if(!$RefreshFrequencyMins -or $RefreshFrequencyMins -eq "")
    {
        $RefreshFrequencyMins = 30
    }

    if(!$ConfigurationModeFrequencyMins -or $ConfigurationModeFrequencyMins -eq "")
    {
        $ConfigurationModeFrequencyMins = 15
    }

    if(!$ConfigurationMode -or $ConfigurationMode -eq "")
    {
        $ConfigurationMode = "ApplyAndMonitor"
    }

        if(!$ActionAfterReboot -or $ActionAfterReboot -eq "")
    {
        $ActionAfterReboot = "ContinueConfiguration"
    }

    if(!$NodeConfigurationName -or $NodeConfigurationName -eq "")
    { 
        $ConfigurationNames = "SimpleConfig.DSCVM01.webserver"
    }
    else
    {
        $ConfigurationNames = @($NodeConfigurationName)
    }  

    Settings
    {
        RefreshFrequencyMins = $RefreshFrequencyMins
        RefreshMode = "PULL"
        ConfigurationMode = $ConfigurationMode
        AllowModuleOverwrite  = $AllowModuleOverwrite
        RebootNodeIfNeeded = $RebootNodeIfNeeded
        ActionAfterReboot = $ActionAfterReboot
        ConfigurationModeFrequencyMins = $ConfigurationModeFrequencyMins
    }

    ConfigurationRepositoryWeb AzureAutomationDSC
    {
        ServerUrl = $RegistrationUrl
        RegistrationKey = $RegistrationKey.GetNetworkCredential().Password
        ConfigurationNames = $ConfigurationNames
    }

    ResourceRepositoryWeb AzureAutomationDSC
    {
        ServerUrl = $RegistrationUrl
        RegistrationKey = $RegistrationKey.GetNetworkCredential().Password
    }

    ReportServerWeb AzureAutomationDSC
    {
        ServerUrl = $RegistrationUrl
        RegistrationKey = $RegistrationKey.GetNetworkCredential().Password
    }
}