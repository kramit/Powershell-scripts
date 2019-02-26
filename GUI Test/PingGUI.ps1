 
#===========================================================================
# XAML Created From Visual studio
#===========================================================================
$inputXML = @"
<Window x:Class="WpfApp2.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp2"
        mc:Ignorable="d"
        Title="MainWindow" Height="450" Width="800">
    <Grid>
        <TextBlock x:Name="textBlock" HorizontalAlignment="Left" Margin="326,59,0,0" TextWrapping="Wrap" Text="TextBlock" VerticalAlignment="Top"/>
        <Button x:Name="button" Content="Button" HorizontalAlignment="Left" Margin="82,52,0,0" VerticalAlignment="Top" Width="75" RenderTransformOrigin="-2.466,-5.073"/>
        <TextBox x:Name="textBox" HorizontalAlignment="Left" Height="23" Margin="326,80,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="120"/>
         <Button x:Name="ExitButton" Content="Exit" HorizontalAlignment="Left" Margin="82,356,0,0" VerticalAlignment="Top" Width="75"/>
            <ListView x:Name="listView" HorizontalAlignment="Left" Height="135" Margin="249,192,0,0" VerticalAlignment="Top" Width="361">
            <ListView.View>
                <GridView>
                    <GridViewColumn Header="ComputerName"/>
                    <GridViewColumn Header="RemoteAddress"/>
                    <GridViewColumn Header="PingSucceeded"/>
                </GridView>
            </ListView.View>
        </ListView>

    </Grid>
</Window>
"@ 
   
#===========================================================================
# Parse info from Visual Studio
#===========================================================================


$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML
 
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
try{
    $Form=[Windows.Markup.XamlReader]::Load( $reader )
}
catch{
    Write-Warning "Unable to parse XML, with error: $($Error[0])`n Ensure that there are NO SelectionChanged or TextChanged properties in your textboxes (PowerShell cannot process them)"
    throw
}
 
#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================
  
$xaml.SelectNodes("//*[@Name]") | %{"trying item $($_.Name)";
    try {Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop}
    catch{throw}
    }
 
Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable WPF*
}
 
Get-FormVariables
 
#===========================================================================
# Use this space to add code to the various form elements in your GUI
#===========================================================================

##Change some names and sizes of elements
$WPFbutton.Content = "Go Go IP Test" 
$WPFbutton.Width = 100
$WPFtextBlock.Text = "Enter the IP to Test"
$WPFtextBox.text = "8.8.8.8"


## add the get net ip info
function test-netip  {
param($ip)
Test-Connection -ComputerName $ip | select address, responsetime, ResponseTimeToLive                                             
}


## add the function to the on click of the button populated by the contents of the textbox
$WPFbutton.Add_Click({
test-netip -ip $WPFtextBox.Text | % {$WPFlistView.AddText($_)}
})



## Add exit button action to close window                         
$WPFExitButton.Add_Click({$form.Close()}) 





#===========================================================================
# Shows the form
#===========================================================================

$Form.ShowDialog() | out-null
 
 