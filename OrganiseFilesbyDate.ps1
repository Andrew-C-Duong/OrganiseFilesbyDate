# Folder containing videos to be sorted
$ParentDir  = "G:\PhoneVids\*" 

# Folder videos should be moved into
$DestDir = "G:\PhoneVideos"


# Recursive function to rename files based on time and date metadata of video
$Files = Get-ChildItem -path $ParentDir -Recurse
$Files | Rename-Item -NewName {$_.LastWriteTime.toString("dd-MM-yyyy-HH-mm-ss") + $_.Extension}

# Extract year and month from LastWriteTime property of file then move to folders based on year and month
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
 
    # Move file to new location
    $Files | Move-Item -Destination $Directory
}
