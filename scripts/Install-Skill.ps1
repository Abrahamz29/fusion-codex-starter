[CmdletBinding()]
param(
    [string]$SkillsRoot = (Join-Path $env:USERPROFILE '.agents\skills')
)
$ErrorActionPreference = 'Stop'
$source = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\skills\fusion-360-printing'))
$destination = [IO.Path]::GetFullPath((Join-Path $SkillsRoot 'fusion-360-printing'))
if (-not (Test-Path -LiteralPath (Join-Path $source 'SKILL.md') -PathType Leaf)) {
    throw 'Das Startpaket ist unvollstaendig: SKILL.md fehlt.'
}
function Get-Inventory([string]$Root) {
    $prefix = $Root.TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
    @(Get-ChildItem -LiteralPath $Root -File -Recurse -Force | ForEach-Object {
        $_.FullName.Substring($prefix.Length) + '|' + (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
    } | Sort-Object)
}
if (Test-Path -LiteralPath $destination) {
    if (-not (Test-Path -LiteralPath $destination -PathType Container)) {
        throw "Das Ziel ist kein Ordner: $destination"
    }
    $expected = @(Get-Inventory $source)
    $actual = @(Get-Inventory $destination)
    if (($expected.Count -ne $actual.Count) -or (Compare-Object $expected $actual)) {
        throw "Vorhandener Skill weicht ab und wurde NICHT ueberschrieben: $destination. Erst vergleichen und sichern."
    }
    Write-Output "Skill bereits identisch vorhanden: $destination"
    return
}
New-Item -ItemType Directory -Path $SkillsRoot -Force | Out-Null
Copy-Item -LiteralPath $source -Destination $destination -Recurse
if (Compare-Object @(Get-Inventory $source) @(Get-Inventory $destination)) {
    throw "Kopie unvollstaendig: $destination"
}
Write-Output "Skill installiert und per SHA256 geprueft: $destination"
