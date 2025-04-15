<#
.SYNOPSIS
    Appends the name of each subdirectory in a directory to its files and optionally moves the files to a new directory.

.DESCRIPTION
    Appends the name of each subdirectory located in a directory to its respective files in the form [SubdirectoryName]_[Filename].
    Optionally moves the files after they are renamed from each subdirectory in the origin directory to a new, specified directory.
    If the new directory to hold the files does not already exist at the specified path, it will be created by the script.

.PARAMETER DirectoryPath
    (Mandatory - String) The filepath of the directory which holds subdirectories that contain files.

.PARAMETER MoveItems
    (Optional - Boolean; default = False) True/False flag to move renamed files to unified directory.

.PARAMETER DestinationPath
    (Optional - String) The filepath of the unified directory to hold the renamed files after move from original directory.

.EXAMPLE
    .\AppendSubdirectoryName.ps1 "C:\...\Directory"

.EXAMPLE
    .\AppendSubdirectoryName.ps1 "D:\...\OldDirectory" -MoveItems $true "C:\...\NewDirectory"

.NOTES
    Author: Jonathan Price
    Date: 15 APR 2025
    Version: 1.0

    This version of the script is designed for use on a directory with the following structure:
        <Directory>
            <Subdirectory>
                <File>
                <...>
                <File>
            <...>
            <Subdirectory>
                <File>
                <...>
                <File>
    As such, this script may not work as intended with different file structures where there are files in the root directory or additional subdirectories alongside files within subdirectories.
#>

param (
    [Parameter(Mandatory = $True)][string]$DirectoryPath,
    [Parameter(Mandatory = $False)][bool]$MoveItems = $False,
    [Parameter(Mandatory = $False)][string]$DestinationPath
)

if (Test-Path $DirectoryPath) {
    Get-ChildItem -Path $DirectoryPath

    # Define the root directory
    $rootDir = $DirectoryPath

    # Get all subdirectories
    $subDirs = Get-ChildItem -Path $rootDir -Directory

    Write-Host "Renaming files. Please wait..."

    foreach ($subDir in $subDirs) {
        # Get all files in the subdirectory
        $files = Get-ChildItem -Path $subDir.FullName -File

        foreach ($file in $files) {
            # Construct the new file name
            $newFileName = "$($subDir.Name)_$($file.Name)"
            $newFilePath = Join-Path -Path $subDir.FullName -ChildPath $newFileName

            # Rename the file
            Rename-Item -Path $file.FullName -NewName $newFilePath
        }
    }

    Write-Host "File renaming process complete!"

    # Check if the user wants to move all the items from the subdirectories to a single, unified directory
    if ($MoveItems && $DestinationPath -isnot [null]) {
        # Create the destination directory if the path does not exist
        if (-not (Test-Path $DestinationPath)) {
            Write-Host "Destination does not exist. Creating new directory..."
            
            try {
                New-Item -Path $DestinationPath -ItemType Directory

                # Move the items
                Write-Host "Moving files from source to destination. Please wait..."
                Get-ChildItem -Path $SourcePath -Recurse -File | Move-Item -Destination $DestinationPath
                
                Write-Host "Cleaning up old source folder. Please wait..."
                Remove-Item -Path $SourcePath -Recurse -Force
                
                Write-Host "File moving process complete!"
            }
            catch {
                <#Do this if a terminating exception happens#>
                Write-Output "An error occurred: $_"
            }
        }
    } elseif ($DestinationPath -is [null]) {
        Write-Host "Destination path cannot be empty/null."
    }
}
else {
    Write-Host "The directory path provided does not exist."
}