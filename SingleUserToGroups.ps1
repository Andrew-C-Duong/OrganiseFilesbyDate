Import-Module ActiveDirectory

# Replace with username
$User = ''

# Import from csv list with groups 
$Groups = Import-CSV C:\temp\groups.csv

$Groups

# Loop through the array of groups and add the user to each group
foreach ($Group in $Groups) 
{
    $GroupName = $Group.Group

    # Skip processing if the Group name is empty
    if ([string]::IsNullOrEmpty($GroupName)) 
    {
        continue
    }
    
    # Add user to groups
    Add-ADGroupMember -Identity $GroupName -Members $User

}