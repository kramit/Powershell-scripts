class Fruit {

[string]$name
[string]$colour

Fruit([string]$name,[string]$colour)
{
$this.name = $name
$this.colour = $colour
}

}

$thing = [Fruit]::new('apple','green')


