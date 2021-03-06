# Exchange OWA Connectivity Test
# Cameron Murray (cam@camm.id.au)
# Steven Pan (stevenpan@gmail.com

Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010

$status = 0;
$desc = "";
$latency = -1;
$url = "";

#create password file
#$my_secure_password_string = convertto-securestring "222222" -asplaintext -force
#$my_encrypted_string = convertfrom-securestring $my_secure_password_string -key (1..16)
#$my_encrypted_string > password.txt

$password = convertto-securestring (get-content scripts\password.txt) -key (1..16)
$login = New-Object -TypeName System.Management.Automation.PsCredential -ArgumentList "INGEEK\panlmyj",$password

#-MailboxCredential:$login
#-URL:https://172.30.1.14/owa
#-MailboxCredential:$login -TrustAnySSLCertificate 

test-owaconnectivity -URL:https://mail.yinji.com.cn/owa -MailboxCredential:$login | ForEach-Object {
#    if($_.Result -like "Success") {
#        $latency=$_.LatencyInMillisecondsString;
#        $status=0
#    } elseif($_.Result -like "Failure") {
#        $desc="OWA Failure"
#        $status=2;
#    } else {
#        # Somethings up..
#        $status=3;
#        $desc="Unknown Failure"
#    }
    $url = $_.URL;
    $latency=$_.LatencyInMillisecondsString;
#    echo $_.Result
}

if ($latency -eq "-1") {
    Write-Host "CRITICAL: " + $desc + " " + $url
    $status=3
} else {
    Write-Host "OK: OWA $url check latency $latency ms"
} 

exit $status;

