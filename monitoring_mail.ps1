<#
 # Nnetwork monitoring with send e-mail notifications
#>


  [CmdletBinding()]
    Param(
      # Enter local e-mail server 
      $PSEmailServer = "mail.example.local",
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
       # Change -To "<admin@example.com>"
        Send-MailMessage -From "networkmon@example.com<networkmon@example.com>" -To "<admin@example.com>"  -Encoding UTF8 -Subject "$ComputerITName ($Computer) - is UP $(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')" -Body "$ComputerITName ($Computer) - is UP $(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')" -BodyAsHtml
      }
      else{
       # Change -To "<admin@example.com>"
        Send-MailMessage -From "networkmon@example.com<networkmon@example.com>" -To "<admin@example.com>" -Encoding UTF8 -Subject "$ComputerITName ($Computer) - is DOWN $(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')" -Body "$ComputerITName ($Computer) - is DOWN $(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')" -BodyAsHtml
      }
      Start-Sleep -Seconds 1
    }
  }