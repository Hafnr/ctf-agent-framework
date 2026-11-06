[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ChallengeDir,

    [Parameter(Mandatory = $true)]
    [ValidatePattern('^AP-[0-9]+$')]
    [string]$Id,

    [ValidatePattern('^(START|AP-[0-9]+)$')]
    [string]$Parent = 'START',

    [Parameter(Mandatory = $true)]
    [string]$Hypothesis,

    [string]$Test = '',
    [string]$Result = '',

    [ValidateSet('untested', 'in-progress', 'rejected', 'inconclusive', 'confirmed')]
    [string]$Status = 'in-progress',

    [string]$Evidence = '',
    [Nullable[int]]$Depth
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $ChallengeDir -PathType Container)) {
    throw "Challenge directory does not exist: $ChallengeDir"
}

$challengePath = (Resolve-Path -LiteralPath $ChallengeDir).Path
$templatePath = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\Templates\Attack Path Canvas Template.canvas'))
$canvasPath = Join-Path $challengePath 'attack-path.canvas'
$eventsPath = Join-Path $challengePath 'attack-events.jsonl'
$livePath = Join-Path $challengePath 'LIVE Attack Status.md'

if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) {
    throw "Canvas template not found: $templatePath"
}

if (-not (Test-Path -LiteralPath $canvasPath -PathType Leaf)) {
    Copy-Item -LiteralPath $templatePath -Destination $canvasPath
}

$canvas = Get-Content -LiteralPath $canvasPath -Raw | ConvertFrom-Json
$nodeId = $Id.ToUpperInvariant()
$parentId = $Parent.ToUpperInvariant()

$nodes = [Collections.Generic.List[object]]::new()
@($canvas.nodes) | ForEach-Object { $nodes.Add($_) }
$edges = [Collections.Generic.List[object]]::new()
@($canvas.edges) | ForEach-Object { $edges.Add($_) }

$existingNode = $nodes | Where-Object { $_.id -eq $nodeId } | Select-Object -First 1
$parentNodeKey = if ($parentId -eq 'START') { 'start' } else { $parentId }

if (-not $Depth.HasValue) {
    if ($parentId -eq 'START') {
        $resolvedDepth = 1
    }
    else {
        $parentNode = $nodes | Where-Object { $_.id -eq $parentNodeKey } | Select-Object -First 1
        if ($null -eq $parentNode) {
            throw "Parent node does not exist in the canvas: $parentId"
        }
        $depthMatch = [regex]::Match([string]$parentNode.text, '(?im)^Depth\s+([0-9]+)\s*$')
        if (-not $depthMatch.Success) {
            throw "Could not derive depth from parent node: $parentId"
        }
        $resolvedDepth = [int]$depthMatch.Groups[1].Value + 1
    }
}
else {
    if ($Depth.Value -lt 1) {
        throw 'Depth must be 1 or greater for an attack-path node.'
    }
    $resolvedDepth = $Depth.Value
}

$safeHypothesis = $Hypothesis.Trim()
$safeTest = $Test.Trim()
$safeResult = $Result.Trim()
$safeEvidence = $Evidence.Trim()

$textParts = [Collections.Generic.List[string]]::new()
$textParts.Add("# $nodeId")
$textParts.Add("**Status:** $Status")
$textParts.Add("**Hypothesis:** $safeHypothesis")
if ($safeTest) { $textParts.Add("**Test:** $safeTest") }
if ($safeResult) { $textParts.Add("**Result:** $safeResult") }
if ($safeEvidence) { $textParts.Add("**Evidence:** $safeEvidence") }
$textParts.Add("Depth $resolvedDepth")
$nodeText = $textParts -join "`n`n"

$color = switch ($Status) {
    'confirmed' { '4' }
    'rejected' { '1' }
    'inconclusive' { '3' }
    'in-progress' { '5' }
    default { $null }
}

if ($null -eq $existingNode) {
    $sameColumnCount = @($nodes | Where-Object { [int]$_.x -eq ($resolvedDepth * 380) }).Count
    $node = [pscustomobject][ordered]@{
        id = $nodeId
        type = 'text'
        text = $nodeText
        x = $resolvedDepth * 380
        y = $sameColumnCount * 300
        width = 320
        height = 240
    }
    if ($null -ne $color) {
        $node | Add-Member -NotePropertyName color -NotePropertyValue $color
    }
    $nodes.Add($node)
}
else {
    $existingNode.text = $nodeText
    if ($null -eq $color) {
        $existingNode.PSObject.Properties.Remove('color')
    }
    elseif ($null -eq $existingNode.PSObject.Properties['color']) {
        $existingNode | Add-Member -NotePropertyName color -NotePropertyValue $color
    }
    else {
        $existingNode.color = $color
    }
}

$edgeId = "edge-$parentNodeKey-$nodeId"
$existingEdge = $edges | Where-Object { $_.id -eq $edgeId } | Select-Object -First 1
if ($null -eq $existingEdge) {
    $edges.Add([pscustomobject][ordered]@{
        id = $edgeId
        fromNode = $parentNodeKey
        fromSide = 'right'
        toNode = $nodeId
        toSide = 'left'
        toEnd = 'arrow'
        label = 'tested'
    })
}

$canvas.nodes = @($nodes)
$canvas.edges = @($edges)
$json = $canvas | ConvertTo-Json -Depth 20
$tempCanvas = "$canvasPath.tmp"
$utf8 = [Text.UTF8Encoding]::new($false)
[IO.File]::WriteAllText($tempCanvas, $json + [Environment]::NewLine, $utf8)
Move-Item -LiteralPath $tempCanvas -Destination $canvasPath -Force

$timestamp = [DateTimeOffset]::Now.ToString('o')
$event = [ordered]@{
    timestamp = $timestamp
    id = $nodeId
    parent = $parentId
    depth = $resolvedDepth
    hypothesis = $safeHypothesis
    test = $safeTest
    result = $safeResult
    status = $Status
    evidence = $safeEvidence
}
$eventLine = ($event | ConvertTo-Json -Compress) + [Environment]::NewLine
[IO.File]::AppendAllText($eventsPath, $eventLine, $utf8)

$liveNote = @"
# Live Attack Status

> [!info] Last agent update
> $timestamp

- **Path:** $nodeId
- **Parent:** $parentId
- **Depth:** $resolvedDepth
- **Status:** $Status
- **Hypothesis:** $safeHypothesis
- **Test:** $safeTest
- **Result:** $safeResult
- **Evidence:** $safeEvidence

## Live attack tree

![[attack-path.canvas]]

## Event journal

See `attack-events.jsonl` for the append-only machine-readable event stream and `worklog.md` for the detailed human-readable record.
"@
[IO.File]::WriteAllText($livePath, $liveNote.TrimEnd() + [Environment]::NewLine, $utf8)

Write-Output "$nodeId $Status (depth $resolvedDepth) -> $canvasPath"
