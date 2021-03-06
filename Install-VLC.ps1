$VLC_Install = "vlc-2.0.5-win32"
IF ((Test-Path -Path "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe") -eq $True) { 
$Current_Install     = (Get-Item "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe").VersionInfo.FileVersion
$Current_Install     = $Current_Install.Split(".")
$Current_Array_Count = $Current_Install.Count
}
$New_Install     = (Get-Item "\\sturgeon\NETLOGON\network_deploy_software\vlc\$VLC_Install.exe").BaseName -replace "vlc-" -replace "-win32"
$New_Install     = $New_Install.Split(".")
$New_Array_Count = $New_Install.Count

Function Update-VLC { 
    Param (
        [String]
        $Name
    )
        $Uninstall_Arguments = (
                            "/S" #Silent
                           )
        &"C:\Program Files (x86)\VideoLAN\VLC\uninstall.exe" $Uninstall_Arguments
        Remove-Item "C:\Program Files (x86)\VideoLAN\*" -Force -ErrorAction SilentlyContinue -Recurse
        Start-Sleep -Seconds 10
        $Install_Arguments = (
                        "/S", #Silent
                        "/L=1033", #English Language, Why not?
                        "--no-qt-privacy-ask", #Doesn't open the first dialog when VLC Runs
                        "--no-qt-updates-notif" #I don't know if it stops update notifications
                     )
        &"\\sturgeon\NETLOGON\network_deploy_software\vlc\$Name" $Install_Arguments
}
#Is it even installed?
IF ((Test-Path -Path "C:\Program Files (x86)\VideoLAN\VLC") -eq $False) {
            $Install_Arguments = (
                        "/S", #Silent
                        "/L=1033", #English Language, Why not?
                        "--no-qt-privacy-ask", #Doesn't open the first dialog when VLC Runs
                        "--no-qt-updates-notif" #I don't know if it stops update notifications
                     )
            &"\\sturgeon\NETLOGON\network_deploy_software\vlc\$VLC_Install" $Install_Arguments
}
ELSE {
    # lt = Less Than
    # le = Less Than / Equal To                    

    IF     ([int]$Current_Install[0] -lt [int]$New_Install[0]) 
             {
               Update-VLC -Name $VLC_Install
             }
    ELSEIF (
            ([int]$Current_Install[0] -le [int]$New_Install[0]) -and 
            ([int]$Current_Install[1] -lt [int]$New_Install[1])
           ) {
               #Commands Here 
               Update-VLC -Name $VLC_Install
             }
    ELSEIF (
            ([int]$Current_Install[0] -le [int]$New_Install[0]) -and 
            ([int]$Current_Install[1] -le [int]$New_Install[1]) -and 
            ([int]$Current_Install[2] -lt [int]$New_Install[2])
           ) {
                #Commands Here
    	    Update-VLC -Name $VLC_Install
             }
    ELSEIF (
            ([int]$Current_Install[0] -le [int]$New_Install[0]) -and 
            ([int]$Current_Install[1] -le [int]$New_Install[1]) -and 
            ([int]$Current_Install[2] -le [int]$New_Install[2]) -and
            ([int]$Current_Install[4] -lt [int]$New_Install[4])
           ) {
                #Commands Here 
                Update-VLC -Name $VLC_Install
             }
    Else     {Exit}
}