# Active Directory Bulk User Provisioning Lab
# Created for a home lab / portfolio environment

Import-Module ActiveDirectory

$CsvPath = ".\users.csv"
$OuName = "Lab_Users"
$DomainDN = (Get-ADDomain).DistinguishedName
$OuPath = "OU=$OuName,$DomainDN"

$DefaultPassword = ConvertTo-SecureString "TempPassword123!" -AsPlainText -Force

# Create OU if it does not already exist
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$OuName'" -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit `
        -Name $OuName `
        -Path $DomainDN `
        -ProtectedFromAccidentalDeletion $false

    Write-Host "Created OU: $OuName" -ForegroundColor Green
}
else {
    Write-Host "OU already exists: $OuName" -ForegroundColor Yellow
}

$Users = Import-Csv $CsvPath

foreach ($User in $Users) {
    $FirstName = $User.FirstName.Trim()
    $LastName = $User.LastName.Trim()
    $Department = $User.Department.Trim()
    $JobTitle = $User.JobTitle.Trim()

    $Username = (($FirstName.Substring(0,1)) + $LastName).ToLower()
    $DisplayName = "$FirstName $LastName"
    $UPN = "$Username@$((Get-ADDomain).DNSRoot)"

    $ExistingUser = Get-ADUser -Filter "SamAccountName -eq '$Username'" -ErrorAction SilentlyContinue

    if ($ExistingUser) {
        Write-Host "Skipped existing user: $Username" -ForegroundColor Yellow
    }
    else {
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
}

Write-Host "Bulk user provisioning complete." -ForegroundColor Green
