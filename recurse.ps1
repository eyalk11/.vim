Write-Host "started"

$x=Get-ChildItem -Path 'C:\Users\ekarni\.vim\plugged'
$x | ForEach-Object -Process {
        If (Test-Path -Path ($_.FullName+"\\.git"))
        {
            cd $_.FullName
            $e= cat .\.git\config
            $z=git status
            #Write-Host $_.FullName
            #Write-Host $z
            if ( ($e -like "*eyalk11*") -or  ($e -like "*eyalk5*") -or ($z -like "*modified*") -or ($z -like "*ahead*") -or ($z -like "*diverged*") -or  (!($z -like "*date*")) )
            {
                Write-Host $_.FullName 
               $e             | Out-File -FilePath ("C:\Users\ekarni\.vim\tmp\"+ $_.Name+ ".config" )
               $z             | Out-File -FilePath ("C:\Users\ekarni\.vim\tmp\" + $_.Name+ ".status" )
               git diff  --patch  | Out-File -FilePath ("C:\Users\ekarni\.vim\tmp\" + $_.Name+ ".diff" )
               git log --max-count=1 | Out-File -Append -FilePath ("C:\Users\ekarni\.vim\tmp\" + $_.Name+ ".status" )


            }
        }
    } 
