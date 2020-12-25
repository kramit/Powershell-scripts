# compute the fib to 4 mil

$var = 1, 2

do {
    $nextfib = $var[-1] + $var[-2]

    $var += $nextfib

    Write-Host $var[-1]

} until ($var[-1] -gt 4000000)

Write-Host $var

## list only even

$evenvar = @()

foreach ($item in $var) {

    if ($item % 2 -eq 0) {
        $evenvar += $item
    }
    else {
        
    }
    
}
write-host "even fib to 4mil are"
Write-Host $evenvar