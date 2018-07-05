$page = Invoke-WebRequest -Uri http://pages.cs.wisc.edu/~ballard/bofh/bofhserver.pl -Method Get
$line = $page.ParsedHtml.getElementsByTagName('font') | Select-Object -ExpandProperty innertext
$excuse = $line[1]
Write-Host "Todays excuse is" 
write-host "$excuse"

