# ====================================================================
# Script: DeleteADComputers.ps1
# Purpose: Delete computer objects from a specific OU in Active Directory
# Author: Koteshwar
# ====================================================================

# Specify the path to the input file containing computer names
$inputFile = "C:\Users\pa-598730\Desktop\DeleteADObjects\computerinput.txt"

# Prompt the user for credentials
$credential = Get-Credential -Message "Enter your credentials"

# Check if the input file exists
if (-not (Test-Path $inputFile)) {
    Write-Host "Input file not found: $inputFile" -ForegroundColor Red
    exit
}

# Read computer names from the input file
$computers = Get-Content $inputFile

# Define the target OU for deletion
$targetOU = "OU=WorkSpaces-Prod,OU=Enterprise (Virtual Desktop),OU=Domain Workstations,DC=tmm,DC=na,DC=corp,DC=toyota,DC=com"

# Loop through each computer and remove them if they are in the specified OU
foreach ($computer in $computers) {
    # Search for the computer object in the target OU
    $computerObject = Get-ADComputer -Filter "Name -eq '$computer'" -SearchBase $targetOU -Credential $credential

    if ($computerObject) {
        Write-Host "Removing computer: $computer" -ForegroundColor Yellow
        # Remove the computer object from Active Directory
        $computerObject | Remove-ADObject -Recursive -Confirm:$false -Credential $credential
    } else {
        Write-Host "Computer $computer not found in $targetOU or doesn't exist." -ForegroundColor Cyan
    }
}

Write-Host "Removal process completed." -ForegroundColor Green
