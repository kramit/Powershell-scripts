function Reset-Course
{
  <#
      .SYNOPSIS
      Course Reverting Script
      .DESCRIPTION
      This will revert a course on all the servers it is running on
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$false, Position=0)]
    [System.String]
    $coursename,
    
    [Parameter(Mandatory=$false, Position=1)]
    [Object]
    $servers = (Get-ADComputer -SearchBase "OU=HV,OU=Hyper-v,OU=Servers,OU=Domain Computers,DC=godeploy,DC=labs" -filter *)
  )
  


  #make sessions to each server
  $sessions = New-PSSession -ComputerName $servers.name -Credential 

  #main loop
  
  foreach($session in $sessions){

invoke-command -Session $session {

  param(
  $coursename
  )

  ## get list of running VMS

  $runningvms = get-vm | Where-Object {$_.name -like "*$coursename*" -and $_.status -eq "running"}

  ##loop each vm and apply last snapshot

  foreach ($runningvm in $runningvms.name){
    Write-Host "Applying last snapshot to $runningvm"
    $runningvm | Get-VMSnapshot | Restore-VMSnapshot -Confirm:$true
  }



  } -ArgumentList $coursename
  }
  }