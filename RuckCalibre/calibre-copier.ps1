<#
    script: calibre-copier.ps1
    last edit: 2026-09-21
    author: Dean Bunn
#>

#Calibre Library Location
[string]$CalibreLibraryLoc = "/home/dbunn/Calibre Library"

#Calibre Export Location
[string]$CalibreExportLoc = "/home/dbunn/DarkCalibre";

#Calibre Daily Export Location
[string]$CalibreDailyExportLoc = $CalibreExportLoc + "/DarkCalibre-" + (Get-Date -Format "yyyyMMdd").ToString();

#Calibre Compressed Archive Path
[string]$CalibreArchivePath = "/home/dbunn/DarkCalibre/DarkCalibre-" + (Get-Date -Format "yyyy-MM-dd").ToString() + ".zip";

#Calibre Minimum Item Count
[int]$CalibreMinCnt = 380;

#Check to See If Calibre Library and Export Location Exists
if((Test-Path -Path $CalibreLibraryLoc) -eq $true -and (Test-Path -Path $CalibreExportLoc) -eq $true -and (Test-Path -Path $CalibreArchivePath -PathType Leaf) -eq $false)
{

    #If Export Location Doesn't Exist, Create It
    if((Test-Path -Path $CalibreDailyExportLoc) -eq $false)
    {
        #Create Required Main Export Folder
        New-Item -Path $CalibreDailyExportLoc -ItemType "Directory";

        #Pause Script for X Seconds to Give Folder Time to Show Up
        Start-Sleep -Seconds 5;
    }

    #Get Export Folder Information
    $exportFldr = Get-Item -Path $CalibreDailyExportLoc

    #Var for Age In Minutes of Export Folder
    [int]$nExportFldrAgeMinutes = ((Get-Date) - $exportFldr.CreationTime).Minutes;

    #Var for Item Count of Export Folder
    [int]$nExportFldrItemCnt = (Get-ChildItem -Path $CalibreDailyExportLoc -File).Count;

    #Check to See If Export Folder Older that 20 Minutes
    if($nExportFldrAgeMinutes -gt 20 -and $nExportFldrItemCnt -eq 0)
    {
        #Export Calibre Library Epub and PDF Files to Export Location
        Get-ChildItem -Path $CalibreLibraryLoc -Recurse -File -Include *.pdf, *.epub | Copy-Item -Destination $CalibreDailyExportLoc
    }

    #Check Exported Items Count and Only After Minimum is Hit Then Create Zip File 
    if($nExportFldrItemCnt -gt $CalibreMinCnt)
    {
        Compress-Archive -Path $CalibreDailyExportLoc -DestinationPath $CalibreArchivePath
    }

}






