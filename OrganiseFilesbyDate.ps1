$ParentDir  = "G:\PhoneVids\*"
$DestDir = "G:\PhoneVideos"
$Files = Get-ChildItem -path $ParentDir -Recurse

$Files | Rename-Item -NewName {$_.LastWriteTime.toString("dd-MM-yyyy-HH-mm-ss") + $_.Extension}

foreach ($Files in $Files)
{
    $Year = $Files.LastWriteTime.Year.ToString()
    $Month = $Files.LastWriteTime.ToString('MMMM')
    $Directory = $DestDir + "\" + $year + "\" + $month

    # Create directory if it doesn't exsist
    if(-not (Test-Path $Directory))
    {
        New-Item -Path $Directory -ItemType Directory    
    }
 
    # Move File to new location
    $Files | Move-Item -Destination $Directory
}