<#
.SYNOPSIS
    CG Project Folder Structure Creator
.DESCRIPTION
    Run this script to create a standard CG project folder structure.
.PARAMETER projectName
    The name of the project (default: "MyProject").
.PARAMETER projectRoot
    The root directory where the project will be created (default: current directory).
.EXAMPLE
    .\CreateProjectStructure.ps1 -projectName "MyProject" -projectRoot "D:\Projects"
#>

param (
    [string]$projectName = "MyProject",
    [string]$projectRoot = "."
)

# Combine root and project name for full path
$projectPath = Join-Path -Path $projectRoot -ChildPath $projectName

# Create the root project directory
New-Item -ItemType Directory -Path $projectPath -Force | Out-Null

# Define the main folders
$mainFolders = @(
    "00_Project",
    "01_Source",
    "02_Assets",
    "03_Scenes",
    "04_Renders",
    "05_Tools",
    "06_Exports",
    "07_References"
)

# Create main folders
foreach ($folder in $mainFolders) {
    New-Item -ItemType Directory -Path (Join-Path -Path $projectPath -ChildPath $folder) -Force | Out-Null
}

# Create subfolders for Assets
$assetSubFolders = @(
    "Character",
    "Props",
    "Environments"
)

foreach ($asset in $assetSubFolders) {
    $assetPath = Join-Path -Path $projectPath -ChildPath "02_Assets\$asset"
    New-Item -ItemType Directory -Path $assetPath -Force | Out-Null

    # Create subfolders for each asset
    $assetInternalFolders = @(
        "Maya",
        "Textures",
        "Groom",
        "Alembic",
        "3dsMax"
    )

    foreach ($internalFolder in $assetInternalFolders) {
        New-Item -ItemType Directory -Path (Join-Path -Path $assetPath -ChildPath $internalFolder) -Force | Out-Null
    }
}

Write-Host "Project folder structure for '$projectName' created successfully at '$projectPath'."
