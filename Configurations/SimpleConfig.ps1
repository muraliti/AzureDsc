Configuration SimpleConfig {
    
    Node "DSCVM01.webserver" {
         
        WindowsFeature IIS {
            Ensure="Present"
            Name= "Web-Server"
            IncludeAllSubFeature = $true
        }
    }
}