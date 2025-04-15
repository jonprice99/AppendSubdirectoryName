# AppendSubdirectoryName

## Synopsis
Appends the name of each subdirectory in a directory to its files and optionally moves the files to a new directory.

## Description
- Appends the name of each subdirectory located in a directory to its respective files in the form **[SubdirectoryName]_[Filename]**.
- Optionally moves the files after they are renamed from each subdirectory in the origin directory to a new, specified directory.
- If the new directory to hold the files does not already exist at the specified path, it will be created by the script.

## Parameters
- DirectoryPath: *(Mandatory - String)* The filepath of the directory which holds subdirectories that contain files.
- MoveItems: *(Optional - Boolean; default = False)* True/False flag to move renamed files to unified directory.
- DestinationPath *(Optional - String)* The filepath of the unified directory to hold the renamed files after move from original directory.

## Running the Script (Examples)
```ps 
.\AppendSubdirectoryName.ps1 "C:\...\Directory"
```
```ps
.\AppendSubdirectoryName.ps1 "D:\...\OldDirectory" -MoveItems $true "C:\...\NewDirectory"
```

## Notes
This version of the script is designed for use on a directory with the following structure:
```
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
```
As such, this script may not work as intended with different file structures where there are files in the root directory or additional subdirectories alongside files within subdirectories.
