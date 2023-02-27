<# -*- shell-script -*-
 PowerShell/Microsoft.PowerShell_profile.ps1

 Install some recomended modules with the line below:
  Find-Module PSReadline,Get-ChildItemColor | Install-Module -AllowClobber
#>

# PSReadLine configuration, if available
if (Get-Module -ListAvailable PSReadLine) {
        Import-Module PSReadLine # make sure it's enabled

        Set-PSReadlineKeyHandler -Key Tab -Function Complete
        Set-PSReadLineOption -PredictionSource History

        Set-PSReadLineKeyHandler -Key Ctrl+P -Function HistorySearchBackward
        Set-PSReadlineKeyHandler -Key Ctrl+N -Function HistorySearchForward
}


<#
.SYNOPSIS
    Colored Prompt.
#>
function prompt {
        $ESC = [char]27 # escape sequence
        $PSCOLOR = "$ESC[$((-not ${LASTEXITCODE})?32:31)m" # red on error else green
        $PSPWD = $executionContext.SessionState.Path.CurrentLocation.ToString().Replace($HOME,'~')
        "$ESC[33m$(Get-Date -UFormat '%H:%M:%S') ${PSCOLOR}PS $ESC[94m${PSPWD}$ESC[0m$('>' * ($nestedPromptLevel + 1)) "
}


# Some aliases I got used to
New-Alias which Get-Command
New-Alias ll    $((Get-Module -ListAvailable Get-ChildItemColor)? "Get-ChildItemColor" : "Get-ChildItem")


<#
.SYNOPSIS
    Create a file or update its modified time to the current time
.PARAMETER Path
    Path to the file to touch.
#>
function touch {
  Param([Parameter(Mandatory=$true)] [string]$Path)
  if (Test-Path -LiteralPath $Path) {
    (Get-Item -Path $Path).LastWriteTime = Get-Date
  } else {
    New-Item -Type File -Path $Path
  }
}