Import-Module $PSScriptRoot\carClass.ps1


# Using Static "new" method
$redSportsCar = [car]::new("100","red")

# Using New-Object. Parameters for Argument list are positional and required by the constructor.
$blueSportsCar = New-Object car -ArgumentList "100", "red"

# Using a HashTable. Note: requires default or parameterless constructor.
$greenSportsCar = [car]@{
    topSpeed = "100"
    colour = "green"
}

# Dynamic Object Type using a variable name.
$type = "Car"
$whiteSportsCar = New-Object -TypeName $type 