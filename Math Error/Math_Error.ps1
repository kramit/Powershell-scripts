do {

write-host " value is $x "

$x = ($x + 0.1)

} until ($x -gt 10)

$x = 1