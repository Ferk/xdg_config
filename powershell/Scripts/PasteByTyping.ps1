
# It "types" the contents of the clipboard.
# Useful when pasting doesn't work (eg. RDP or VM not sharing clipboard)

$content = Get-Clipboard

Write-Output "____ CONTENT TO PASTE ____" $content "__________________________"
Write-Output "  Press Ctrl+C to abort"

timeout 7
if ($?) {
  $content.ToCharArray() | ForEach-Object {[System.Windows.Forms.SendKeys]::SendWait($_)}
}
