<#
    script: calibre-copier.ps1
#>

Get-ChildItem -Path "/home/dbunn/Calibre Library" -Recurse -File -Include *.pdf, *.epub | Copy-Item -Destination "/home/dbunn/DarkPubs"

