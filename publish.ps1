$Vault = "D:\anant\Vezolution 2024\Vezolution obsidian files"
$Content = "D:\Obsidian\Obsidian_Vezo_site\content"

Write-Host "Publishing notes..." -ForegroundColor Cyan

# Remove previously published Markdown files from Quartz.
# index.md is kept because it is our website homepage.
Get-ChildItem $Content -Filter "*.md" -File |
    Where-Object { $_.Name -ne "index.md" } |
    Remove-Item -Force

# Find notes in the original vault that explicitly say publish: true
$Published = Get-ChildItem $Vault -Filter "*.md" -File -Recurse |
    Where-Object {
        $text = Get-Content $_.FullName -Raw
        $text -match '(?m)^publish:\s*true\s*$'
    }

Write-Host "Found $($Published.Count) published note(s)." -ForegroundColor Green

foreach ($File in $Published) {
    $Destination = Join-Path $Content $File.Name

    Copy-Item $File.FullName $Destination -Force

    Write-Host "Published: $($File.Name)"
}

Write-Host ""
Write-Host "Publishing complete." -ForegroundColor Green