class car
{
    #Props
    [Int32] $topSpeed
    [string] $colour
    
    # Static Props
    Static [string] $UK = "Right"
    Static [string] $US = "Left"

    # Hidden Props

    Hidden [string] $cO2Output

    #paramless constructor
    car ()
    {

    }

    #constructor
    car ([int32]$topSpeed,[string]$colour)
    {
        $this.topSpeed = $topSpeed
        $this.colour = $colour
    }

    # Method
    # add turbo 10% boost to top speed
    [String] addTurbo()
    {
        $this.topSpeed = $this.topSpeed + (($this.topSpeed / 100)*10)

        return "boost added top speed is now :"+$this.topSpeed     
    }

    #Static method
    Static [string] getTopSpeed()
    {
        return [car]::topspeed
    }
}