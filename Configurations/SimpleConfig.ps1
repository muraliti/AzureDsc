Configuration SimpleConfig {
    
    Node "DSCVM01.webserver" {
         
        WindowsFeature IIS {
            Ensure="Present"
            Name= "Web-Server"
            IncludeAllSubFeature = $true
        }        
        WindowsFeature InstallIISConsole
        {
            Name="Web-Mgmt-Console"
            Ensure="Present"
        }
        WindowsFeature InstallDotNet45
        {
            Name="Web-Asp-Net45"
            Ensure="Present"
        }        
    }
}