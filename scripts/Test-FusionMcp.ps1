[CmdletBinding()]
param([Parameter(Mandatory=$true)][uri]$Endpoint)
$ErrorActionPreference = 'Stop'
$client = Join-Path $PSScriptRoot '..\skills\fusion-360-printing\scripts\invoke-fusion.ps1'
$catalog = & $client -Endpoint $Endpoint -ListTools
$execute = @($catalog.tools | Where-Object name -eq 'fusion_mcp_execute')
if ($execute.Count -ne 1) {
    throw 'fusion_mcp_execute fehlt. Werkzeuge und installierte Fusion-Version manuell pruefen.'
}
$properties = $execute[0].inputSchema.properties
if (-not $properties.featureType -or -not $properties.object) {
    throw 'Das Execute-Schema weicht vom unterstuetzten Skriptformat ab. Erst aktuelles Schema lesen.'
}
$scriptPath = [IO.Path]::GetTempFileName()
try {
    @'
import adsk.core
def run(context):
    print("FUSION_STARTER_VERSION=" + adsk.core.Application.get().version)
'@ | Set-Content -LiteralPath $scriptPath -Encoding UTF8
    $result = & $client -Endpoint $Endpoint -ScriptPath $scriptPath -ReadOnly
    $resultText = $result | ConvertTo-Json -Depth 50
    if ($resultText -notmatch 'FUSION_STARTER_VERSION=([0-9][0-9.]+)') {
        throw 'Der lesende Aufruf lieferte keinen nachweisbaren Fusion-Versionswert.'
    }
    [pscustomobject]@{
        status='PASS'; endpoint=$Endpoint.AbsoluteUri; fusionVersion=$Matches[1];
        discoveredTools=@($catalog.tools).Count; readOnlyCall=$true
    }
} finally {
    Remove-Item -LiteralPath $scriptPath -Force
}
