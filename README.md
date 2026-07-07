# Active Directory Bulk User Provisioning Lab

## Overview

This project demonstrates how PowerShell can be used to automate user account creation in Active Directory. The script reads employee information from a CSV file, creates an Organizational Unit, generates usernames, and provisions new user accounts inside Active Directory.

This lab was created as part of my IT Analyst / Identity and Access Management portfolio.

## Skills Demonstrated

- PowerShell scripting
- Active Directory administration
- User provisioning
- Organizational Unit management
- Identity and Access Management fundamentals
- CSV-based automation
- Basic error handling

## Project Files

| File | Description |
|---|---|
| `Create-LabUsers.ps1` | PowerShell script that creates users in Active Directory |
| `users.csv` | Sample employee data used by the script |
| `README.md` | Project documentation |

## How It Works

The script performs the following actions:

1. Imports the Active Directory PowerShell module.
2. Reads user data from `users.csv`.
3. Creates an OU named `Lab_Users` if it does not already exist.
4. Generates a username using the first initial and last name.
5. Checks if the user already exists.
6. Creates the user account if it does not already exist.
7. Sets department and job title fields.
8. Requires the user to change their password at first logon.

## Example CSV Format

```csv
FirstName,LastName,Department,JobTitle
Johnny,Young,IT,IT Support Analyst
Sarah,Johnson,HR,HR Coordinator
Michael,Brown,Finance,Financial Analyst
