#!/bin/bash - 
#===============================================================================
#
#          FILE: installnvim.sh
# 
#         USAGE: ./installnvim.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 10/21/2019 19:01
#      REVISION:  ---
#===============================================================================

$ErrorActionPreference = "Stop"                          # Treat errors as terminating errors
function Exit-OnError {
    param($exit_code, $last_command)
    if ($exit_code -ne 0) {
        Write-Error "`"$last_command`" command failed with exit code $exit_code."
        exit $exit_code
    }
}

Write-Host "usage: new-version-zip-filename (ie nightly)" 
Remove-Item -Path nvim-win64.tar.gz -ErrorAction Ignore
Invoke-WebRequest -Uri ("https://github.com/neovim/neovim/releases/download/" + $args[0] + "/nvim-win64.tar.gz") -OutFile nvim-win64.tar.gz
Exit-OnError $LASTEXITCODE $LASTCOMMAND

if (Test-Path -Path nvim-temp) {
    Write-Host "moving temp to last temp" 
    Remove-Item -Path ./neovim-lasttemp -ErrorAction Ignore
    Move-Item -Path nvim-temp -Destination nvim-lasttemp
}

Move-Item -Path nvim-osx64 -Destination nvim-temp
Expand-Archive -Path nvim-win64.tar.gz -DestinationPath ./ -Force
#mv $2 nvim-osx64
