# Import the Active Directory module to access AD-related commands
Import-Module ActiveDirectory

# Define the number of days for which users are considered inactive
$Days = 90

# Define a calculated property to convert password expiry time to human-readable format
$PasswordExpiryDate = @{
    Name="PWExpiryDate"
    Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}
}

# Retrieve user accounts from Active Directory based on specific criteria, OU redacted for confidentiality
Get-ADUser -Filter {
    Enabled -eq $True -and
    PasswordNeverExpires -eq $False -and
    PasswordLastSet -gt 0
} -SearchBase "" -Properties Name,LastLogonDate, msDS-UserPasswordExpiryTimeComputed,Manager,Company,Mail |

# Filter user accounts based on last logon date and distinguished name, OU redacted for confidentiality
Where-Object {
    ($_.LastLogonDate -lt (Get-Date).AddDays(-$Days)) -and
    ($_.LastLogonDate -ne $NULL) -and
    ($_.DistinguishedName -notmatch '')
} |

# Sort the filtered user accounts selecting specific properties for output
Sort-Object | Select-Object Name, LastLogonDate, $PasswordExpiryDate,
    @{
        Name = 'Manager'
        Expression = {$_.Manager -replace 'CN=|,..=.'}
    },
    Company, Mail |

# Export the selected user account information to a CSV file
Export-Csv "C:\Temp\LastLoginOver90Days.csv" -NoTypeInformation -Encoding UTF8
