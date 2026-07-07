# Active Directory Bulk User Creation Lab
# This script reads users from users.csv and creates them in Active Directory.

Import-Module ActiveDirectory

# File name
$CsvPath = ".\users.csv"

# OU name where users will be created
$OuName = "Lab_Users"

# Default starter password
$DefaultPassword = ConvertTo-SecureString "TempPassword123!" -AsPlainText -Force

# Get domain information
$DomainDN = (Get-ADDomain).DistinguishedName
$DomainDNS = (Get-ADDomain).DNSRoot
$OuPath = "OU=$OuName,$DomainDN"

# Create the OU if it does not exist
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$OuName'" -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name $OuName -Path $DomainDN -ProtectedFromAccidentalDeletion $false
    Write-Host "Created OU: $OuName" -ForegroundColor Green
}
else {
    Write-Host "OU already exists: $OuName" -ForegroundColor Yellow
}

# Import users from CSV
$Users = Import-Csv $CsvPath

foreach ($User in $Users) {

    $FirstName = $User.FirstName.Trim()
    $LastName = $User.LastName.Trim()
    $Department = $User.Department.Trim()
    $JobTitle = $User.JobTitle.Trim()

    # Username format: first initial + last name
    $BaseUsername = (($FirstName.Substring(0,1)) + $LastName).ToLower()
    $Username = $BaseUsername
    $Counter = 1

    # If username already exists, add a number
    while (Get-ADUser -Filter "SamAccountName -eq '$Username'" -ErrorAction SilentlyContinue) {
        $Username = "$BaseUsername$Counter"
        $Counter++
    }

    $DisplayName = "$FirstName $LastName"
    $UPN = "$Username@$DomainDNS"

    New-ADUser `
        -Name $DisplayName `
        -GivenName $FirstName `
        -Surname $LastName `
        -DisplayName $DisplayName `
        -SamAccountName $Username `
        -UserPrincipalName $UPN `
        -Department $Department `
        -Title $JobTitle `
        -AccountPassword $DefaultPassword `
        -Path $OuPath `
        -Enabled $true `
        -ChangePasswordAtLogon $true

    Write-Host "Created user: $Username - $DisplayName" -ForegroundColor Cyan
}

Write-Host "All users have been created." -ForegroundColor Green
