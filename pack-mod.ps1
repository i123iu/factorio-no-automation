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

# Create zip file
Compress-Archive -Path "$tempDir\$modName" -DestinationPath $zipName -Force

# Clean up temp directory
Remove-Item $tempDir -Recurse -Force

Write-Host "`nSuccessfully created $zipName" -ForegroundColor Green
