Write-Host "=== Git Repository Status Checker Started ===" -ForegroundColor Green
Write-Host ""

# Initialize counters for summary
$totalRepos = 0
$eyalkRepos = 0
$modifiedRepos = 0
$unpushedRepos = 0
$divergedRepos = 0
$processedRepos = @()

# Ensure tmp directory exists
$tmpDir = "C:\Users\ekarni\.vim\tmp"
if (!(Test-Path $tmpDir)) {
    New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null
}

$repos = Get-ChildItem -Path 'C:\Users\ekarni\.vim\plugged'
$repos | ForEach-Object -Process {
    If (Test-Path -Path ($_.FullName + "\.git")) {
        $totalRepos++
        Set-Location $_.FullName
        
        # Get git config and status
        $config = Get-Content .\.git\config -ErrorAction SilentlyContinue
        $status = git status --porcelain=v1 --branch 2>$null
        $statusLong = git status 2>$null
        
        # Check if it's an eyalk repo
        $isEyalkRepo = ($config -like "*eyalk11*") -or ($config -like "*eyalk5*")
        if ($isEyalkRepo) { $eyalkRepos++ }
        
        # Extract all remote URLs
        $remoteEntries = git remote -v 2>$null
        $remoteUrls = $remoteEntries | ForEach-Object {
            if ($_ -match '^(\S+)\s+(\S+)\s+\((?:fetch|push)\)$') {
                "$($matches[1]): $($matches[2])"
            }
        } | Sort-Object -Unique
        
        # Parse git status for various conditions
        $hasModified = $status -match '^[MADRCU]'
        $hasUntracked = $status -match '^\?\?'
        $hasStaged = $status -match '^[MADRCU][^?]'
        
        # Check branch status (ahead/behind/diverged)
        $branchStatus = ""
        $isPushed = $true
        if ($status -match '## .+\[(.+)\]') {
            $branchInfo = $matches[1]
            if ($branchInfo -match 'ahead (\d+)') {
                $branchStatus += "ahead $($matches[1]) "
                $isPushed = $false
                $unpushedRepos++
            }
            if ($branchInfo -match 'behind (\d+)') {
                $branchStatus += "behind $($matches[1]) "
            }
            if ($branchInfo -match 'ahead \d+, behind \d+') {
                $branchStatus = "diverged"
                $divergedRepos++
            }
        } elseif ($statusLong -like "*ahead*") {
            $branchStatus = "ahead"
            $isPushed = $false
            $unpushedRepos++
        } elseif ($statusLong -like "*diverged*") {
            $branchStatus = "diverged"
            $divergedRepos++
        }
        
        # Check if repo needs attention
        $needsAttention = $isEyalkRepo -or $hasModified -or $hasUntracked -or $hasStaged -or !$isPushed -or ($branchStatus -ne "")

        if ($true) {
            if ($hasModified -or $hasUntracked -or $hasStaged) { $modifiedRepos++ }

            Write-Host "Repository: $($_.Name)" -ForegroundColor $(if ($needsAttention) { "Yellow" } else { "White" })
            Write-Host "Path: $($_.FullName)" -ForegroundColor Gray
            
            if ($remoteUrls) {
                Write-Host "Remotes:" -ForegroundColor Cyan
                foreach ($entry in $remoteUrls) {
                    Write-Host "  $entry" -ForegroundColor Cyan
                }
                if ($isEyalkRepo) {
                    Write-Host "*** EYALK REPO ***" -ForegroundColor Magenta
                }
            }
            
            # Push status
            if ($isPushed -and $branchStatus -eq "") {
                Write-Host "Push Status: ✓ Up to date" -ForegroundColor Green
            } elseif ($branchStatus -ne "") {
                Write-Host "Push Status: ⚠ $branchStatus" -ForegroundColor Red
            } else {
                Write-Host "Push Status: ⚠ Needs push" -ForegroundColor Red
            }
            
            # Working directory status
            if ($hasStaged) {
                Write-Host "Staged Changes: ✓ Yes" -ForegroundColor Yellow
            }
            if ($hasModified) {
                Write-Host "Modified Files: ✓ Yes" -ForegroundColor Yellow
            }
            if ($hasUntracked) {
                Write-Host "Untracked Files: ✓ Yes" -ForegroundColor Yellow
            }
            if (!$hasModified -and !$hasUntracked -and !$hasStaged) {
                Write-Host "Working Directory: ✓ Clean" -ForegroundColor Green
            }
            
            Write-Host ""
            
            # Save detailed information to files
            $config | Out-File -FilePath ("$tmpDir\" + $_.Name + ".config") -Encoding UTF8
            $statusLong | Out-File -FilePath ("$tmpDir\" + $_.Name + ".status") -Encoding UTF8
            git diff --patch | Out-File -FilePath ("$tmpDir\" + $_.Name + ".diff") -Encoding UTF8
            git log --max-count=1 --oneline | Out-File -Append -FilePath ("$tmpDir\" + $_.Name + ".status") -Encoding UTF8
            $remoteUrls | Out-File -FilePath ("$tmpDir\" + $_.Name + ".remotes") -Encoding UTF8
            # Add to processed repos for summary
            $repoInfo = @{
                Name = $_.Name
                Path = $_.FullName
                Remote = $remoteUrl
                IsEyalk = $isEyalkRepo
                HasModified = $hasModified
                HasUntracked = $hasUntracked
                HasStaged = $hasStaged
                BranchStatus = $branchStatus
                IsPushed = $isPushed
            }
            $processedRepos += $repoInfo
        }
    }
}

# Print Summary
Write-Host "=== SUMMARY ===" -ForegroundColor Green
Write-Host "Total repositories scanned: $totalRepos" -ForegroundColor White
Write-Host "Repositories needing attention: $($processedRepos.Count)" -ForegroundColor Yellow
Write-Host "Eyalk repositories: $eyalkRepos" -ForegroundColor Magenta
Write-Host "Repositories with modifications: $modifiedRepos" -ForegroundColor Yellow
Write-Host "Repositories with unpushed commits: $unpushedRepos" -ForegroundColor Red
Write-Host "Repositories with diverged branches: $divergedRepos" -ForegroundColor Red
Write-Host ""

if ($processedRepos.Count -gt 0) {
    Write-Host "=== DETAILED SUMMARY ===" -ForegroundColor Green
    $processedRepos | ForEach-Object {
        $status = @()
        if ($_.IsEyalk) { $status += "EYALK" }
        if ($_.HasModified) { $status += "Modified" }
        if ($_.HasUntracked) { $status += "Untracked" }
        if ($_.HasStaged) { $status += "Staged" }
        if (!$_.IsPushed) { $status += "Unpushed" }
        if ($_.BranchStatus -ne "") { $status += $_.BranchStatus }
        
        $statusStr = $status -join ", "
        Write-Host "$($_.Name): $statusStr" -ForegroundColor $(if ($_.IsEyalk) { "Magenta" } else { "Yellow" })
    }
}

Write-Host ""
Write-Host "=== Git Repository Status Checker Completed ===" -ForegroundColor Green

# Return to original directory
Set-Location "C:\Users\ekarni\.vim"
