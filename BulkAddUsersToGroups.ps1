# Import the Active Directory module to access AD-related commands
Import-Module ActiveDirectory

# Initialize arrays to store user and group names
$users = @()
$groups = @()

# Import data from CSV file containing user-group mappings
Import-CSV C:\temp\groups.csv | ForEach-Object {
    # Add user and group names to their respective arrays
    $users += $_.user
    $groups += $_.group
}

# Iterate through each group in the groups array
foreach ($group in $groups) {
    # Filter out any empty users from the users array
    $membersToAdd = $users | Where-Object { $_ }

    # Check if there are users to add to the group
    if ($membersToAdd.Count -gt 0) {
        try {
            # Attempt to add users to the group
            Add-ADGroupMember -Identity $group -Members $membersToAdd -ErrorAction Stop -WhatIf

            # Display success message for each user added to the group
            foreach ($user in $membersToAdd) {
                Write-Host "'$user' added to '$group'"
            }
        } catch {
            # Display error message if adding users to the group fails
            Write-Host "An error occurred while adding users to the group '$group': $_"
        }
    } else {
        # Display message if there are no users to add to the group
        Write-Host "No users to add to the group '$group'."
    }
}
