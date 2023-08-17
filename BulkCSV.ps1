Import-Module ActiveDirectory

# Replace the following array with the names of the groups you want to add the user to
#$data  = Import-CSV C:\temp\groups.csv

#$data

$users = @()
$groups += @()

Import-CSV C:\temp\groups.csv | ForEach-Object {
    $user += $_.user
    $groups += $_.group
} 

#$users
#$groups


#Loop through the array of groups and add the user to each group
foreach ($Group in $Groups) 
{
    $GroupName = $Group.Group

    # Skip processing if the Group name is empty
    if ([string]::IsNullOrEmpty($GroupName)) 
    {
        continue
    }
    
    Add-ADGroupMember -Identity $GroupName -Members $User

}