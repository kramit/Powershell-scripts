Function Get-CorpOSInfo {
<#
.SYNOPSIS
Retreives operating system, BIOS, and computer information from one or
more computers.
.DESCRIPTION
This command retrieves specific information from each computer. The
command uses CIM, so it will only work with computers where Windows
Remote Management (WinRM) has been enabled and Windows Management
Framework (WMF) 3.0 or later is installed.
.PARAMETER ComputerName
One or more computer names, as strings. IP addresses are not accepted.
You should only use canonical names from Active Directory. This
parameter accepts pipeline input. Computer names must be in the form
LON-XXYY, where "XX" can be a 2- or 3-character designation, and 
"YY" can be 1 or 2 digits.
.EXAMPLE
 Get-Content names.txt | Get-CorpOSInfo
This example assumes that names.txt includes one computer name per
line, and will retrieve information from each computer listed.
.EXAMPLE
 Get-CorpOSInfo -ComputerName LON-DC1
This example retrieves information from one computer.
#>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage='One or more computer names')]
        [Alias('HostName')]
        [ValidatePattern('LON-\w{2,3}\d{1,2}')]
        [string[]]$ComputerName
    )

    PROCESS {
        foreach ($computer in $ComputerName) {
            Write-Verbose "Connecting to $computer"

            try {
                $os = Get-CimInstance -ComputerName $computer -ClassName Win32_OperatingSystem -ErrorAction Stop
                $compsys = Get-CimInstance -ComputerName $computer -ClassName Win32_ComputerSystem -ErrorAction Stop
                $bios = Get-CimInstance -ComputerName $computer -ClassName Win32_BIOS -ErrorAction Stop
                
                $properties = @{'ComputerName'=$computer;
                            'OSVersion'   = $os.caption;
                            'SPVersion'   = $os.servicepackmajorversion;
                            'BIOSSerial'  = $bios.serialnumber;
                            'Manufacturer'= $compsys.manufacturer;
                            'Model'       = $compsys.model}
                $output = New-Object -TypeName PSObject -Property $properties
                Write-Output $output

            } catch {
                Write-Warning "$computer failed - logged to c:\errors.txt"
                $computer | out-file "c:\errors.txt" -Append
            } #trycatch

        }
    }

}