<#
 # Nnetwork monitoring with powershell
#>

Function monitoring {
  [CmdletBinding()]
    Param(
      $ComputerName    
    )

  #add to csv file 'namepc,ip'"
  $ComputerName = Import-Csv "c:\monitoringpc.csv"
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
}

  monitoring