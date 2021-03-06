$VCServerName = "hpvvcs001"
$VC = Connect-VIServer $VCServerName

$allowedDifferenceSeconds = 20 
$body = $null 
get-view -ViewType HostSystem -Property Name, ConfigManager.DateTimeSystem  | %{ 
    #get host datetime system    
    $dts = get-view $_.ConfigManager.DateTimeSystem

    #get host time    
    $t = $dts.QueryDateTime()

    #calculate time difference in seconds    
    $s = ( $t - [DateTime]::UtcNow).TotalSeconds

    #check if time difference is too much    
    if([math]::abs($s) -gt $allowedDifferenceSeconds){
        #print host and time difference in seconds        
        $body += ("On " + $_.Name + " the time difference is "  + $s + " seconds`r" | Out-String) 
    }
    else{
        $body +=  ("Time on " + $_.Name + " within allowed range`r" | Out-String)
    }
}

$smtpSrv = "smtp.det.nsw.edu.au"
$from = "upvutl001@det.nsw.edu.au"
$to = "ITInfraservvmwaresupport@det.nsw.edu.au"
$subject = "VM Host Time Report"
$msg = new-object Net.Mail.MailMessage($from,$to,$subject,$body)

$smtp = new-object Net.Mail.SMTPclient($smtpSrv)

$smtp.send($msg)

