# ===============================
# Export Last Logon Report for AD Computers
# ===============================

# Prompt the user for credentials
$credential = Get-Credential -Message "Enter your credentials"

# Define the target OU for the query
$targetOU = "OU=AppStream-Prod,OU=Enterprise (Virtual Desktop),OU=Domain Workstations,DC=tmm,DC=na,DC=corp,DC=toyota,DC=com"

# Get all computer objects in the specified OU and their last logon date
$computers = Get-ADComputer -Filter * -SearchBase $targetOU -Credential $credential -Property Name, LastLogonDate

# Check if any computers were found
if ($computers) {
    # Select the properties you want to export
    $computerList = $computers | Select-Object Name, LastLogonDate
    
    # Export to CSV
    $outputPath = "C:\Users\pa-598730\Downloads\ComputerLastLogonReport.csv"
    $computerList | Export-Csv -Path $outputPath -NoTypeInformation
    
    Write-Host "Report exported to $outputPath" -ForegroundColor Green
} else {
    Write-Host "No computers found in $targetOU." -ForegroundColor Yellow
}

Write-Host "Last logon check completed." -ForegroundColor Cyan
