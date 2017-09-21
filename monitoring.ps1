<#
 # Nnetwork monitoring with powershell
#>


  [CmdletBinding()]
    Param(
      $ComputerName    
    )

  $ScriptPath = $PSScriptRoot
  $ScriptPath = Split-Path $MyInvocation.MyCommand.Path
  $ComputerName = Import-Csv "$ScriptPath\monitoringpc.csv"
  $Count = @{}
  $Countnok = @{} 

  while ($True){

    foreach ($Computeritem in $ComputerName){

      $Computer = $Computeritem.ip
      $ComputerITName = $Computeritem.Name

          if (($Count.$Computer) -eq $null){
           $Count.add($Computer,"True") 
          }
          if (($Countnok.$Computer) -eq $null){
            $Countnok.add($Computer,"True") 
          }

      $Countnok.$Computer = $Count.$Computer
      $Count.$Computer = Test-Connection -BufferSize 32 -Count 4 -Delay 4 -ComputerName $Computer -Quiet

      if (($Countnok.$Computer) -eq ($Count.$Computer)){
       # NOTHING
      }
      elseif ($Count.$Computer){
        Write-Host -Object "$ComputerITName ($Computer) - is UP $(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')"
      }
      else{
        Write-Host -Object "$ComputerITName ($Computer) - is DOWN $(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')"
      }
      Start-Sleep -Seconds 1
    }
  }
