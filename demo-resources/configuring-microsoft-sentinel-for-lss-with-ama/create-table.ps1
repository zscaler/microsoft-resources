az monitor log-analytics workspace table create --resource-group <log analytics resource group> --workspace-name <log analytics workspace name>> -n ZPA_CL --columns TimeGenerated=DateTime Message=String SourceSystem=String RawData=String ManagementGroupName=String Computer=String