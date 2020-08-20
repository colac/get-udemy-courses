# Get CentOS VM IP from Hyper-V environment
# Date: 20/08/2020
# if needed to be dynamic just request user to type VM name

Import-Module Hyper-V

try{
    $vm_input = "CentOS"
    Start-VM -VMName $vm_input -ErrorAction Stop
    $vm = Get-VM -Name $vm_input
    $centosIPs = $vm.NetworkAdapters.IPAddresses
    Write-Host $centosIPs
}
catch{
    write-host "An error occurred that could not be resolved.`nPlease validate the VM name." -ForegroundColor Red
    exit
}

#wait for IPs from $vm
$i = 0
while (!$centosIPs -and ($i -le 15)){
    write-host "No IPs yet"
    Start-Sleep -Seconds 4
    $i++
    if($i -eq 15){
    Write-Host write-host "An error occurred and no IP was returned.`nPlease validate the VM." -ForegroundColor Red
    exit
    }
}

#get ipv4 IP 
foreach($IP in $centosIPs){
    $pattern = "^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$"
    if($IP -match $pattern){
    $VMipv4 = $Matches.0
    }
}

#copy IP to windows clipboard
$VMipv4 | clip
Write-Host "VM IP:" $VMipv4 -ForegroundColor Green
Write-Host "VM Notes:" $vm.Notes -ForegroundColor Green
Write-Host "IP copied to clipboard, paste in SSH software, if you don't intend to use PowerShell window." -ForegroundColor Green
start-process powershell -ArgumentList "ssh.exe hugo@$VMipv4"