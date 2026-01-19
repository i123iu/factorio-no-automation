# Pack Factorio mod for submission

$modName = "factorio-no-automation"
$zipName = "$modName.zip"
$tempDir = ".\temp-pack"
$modDir = ".\$modName"

# Remove existing zip and temp directory if they exist
if (Test-Path $zipName) {
    Remove-Item $zipName -Force
    Write-Host "Removed existing $zipName"
}

if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}

# Create temp directory structure
New-Item -ItemType Directory -Path "$tempDir\$modName" -Force | Out-Null

# Files and folders to exclude
$excludeItems = @(
    ".vscode",
    ".gitignore",
    ".git",
    "icon.png",
    "pack-mod.ps1",
    "temp-pack",
    "$zipName"
)

# Copy all items except excluded ones
Get-ChildItem -Path . | Where-Object {
    $item = $_
    $shouldExclude = $false
    
    foreach ($exclude in $excludeItems) {
        if ($item.Name -eq $exclude) {
            $shouldExclude = $true
            break
        }
    }
    
    -not $shouldExclude
} | ForEach-Object {
    Copy-Item $_.FullName -Destination "$tempDir\$modName" -Recurse -Force
    Write-Host "Copied: $($_.Name)"
}

# Create zip file with forward slashes for cross-platform compatibility
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.IO.Compression

if (Test-Path $zipName) {
    Remove-Item $zipName -Force
}

$zip = [System.IO.Compression.ZipFile]::Open($zipName, [System.IO.Compression.ZipArchiveMode]::Create)

try {
    $tempDirFullPath = (Resolve-Path $tempDir).Path
    Get-ChildItem -Path "$tempDir\$modName" -Recurse -File | ForEach-Object {
        $relativePath = $_.FullName.Substring($tempDirFullPath.Length + 1).Replace('\', '/')
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $relativePath) | Out-Null
        Write-Host "Added to zip: $relativePath"
    }
} finally {
    $zip.Dispose()
}

# Clean up temp directory
Remove-Item $tempDir -Recurse -Force

Write-Host "`nSuccessfully created $zipName" -ForegroundColor Green
