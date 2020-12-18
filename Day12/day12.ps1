[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $FileName = "input.txt"
)

# Initialize each distance to 0
$distances = @{ North = 0; East = 0; South = 0; West = 0; }
# Directions used for easily turning
$directions = @{ 1 = 'N'; 2 = 'E'; 3 = 'S'; 4 = 'W' }
# Rotation values assuming there is only these 3 values for degrees
$rotations = @{ '90' = 1; '180' = 2; '270' = 3; }

# East is the default starting direction
$currDir = 2

# Use the location of the current script to append to the filename
# File must be in the same location as the script
$FileName = $PSScriptRoot + "\" + $FileName

# Takes a direction of 'L' or 'R' and a degrees of '90', '180' or '270' and rotates the ship
function Turn-Ship([string]$direction, $degrees) {
    Write-Host "Rotating $direction from " $directions.$currDir " by $degrees degrees"
    if ($direction -eq 'L') {
        $currDir = $currDir - $rotations.$degrees
        # If it goes under 1 then it is no longer a direction so adjust it
        if ($currDir -lt 1) {
            $currDir += 4
        }
    } else {
        $currDir = $currDir + $rotations.$degrees
        # If it goes over 4 then it is no longer a direction so adjust it
        if ($currDir -gt 4) {
            $currDir -= 4
        }
    }

    Write-Host "New direction: " $directions.$currDir

    return $currDir
}

# Move the ship in the given direction by the given amount
function Move-Ship([string]$direction, [int]$amount) {
    Write-Host "Adding $amount to $direction"
    switch ($direction) {
        'N' {
            $distances["North"] += $amount
            Break
        }
        'E' {
            $distances["East"] += $amount
            Break
        }
        'S' {
            $distances["South"] += $amount
            Break
        }
        'W' {
            $distances["West"] += $amount
            Break
        }
    }
}

foreach($line in [System.IO.File]::ReadLines($FileName))
{
    $dir = $line.substring(0, 1)
    $value = $line.substring(1, $line.length - 1)
    #Write-Host "$dir : $value"
    switch ($dir) {
        'L' {
            $currDir = Turn-Ship $dir $value
            Break
        }
        'R' {
            $currDir = Turn-Ship $dir $value
            Break
        }
        'F' {
            Move-Ship $directions.$currDir $value
            Break
        }
        Default {
            Move-Ship $dir $value
        }
    }
    # Display the current values for debugging
    #Write-Host "North: " $distances.North
    #Write-Host "East:  " $distances.East
    #Write-Host "South: " $distances.South
    #Write-Host "West:  " $distances.West
    #Write-Host "Current direction: " $directions.$currDir
}

# Display the end result for each direction
Write-Host "North: " $distances.North
Write-Host "East:  " $distances.East
Write-Host "South: " $distances.South
Write-Host "West:  " $distances.West

# Work out the manhattan distance
$distV = $distances.North - $distances.South
$distH = $distances.East - $distances.West
$distV = [Math]::Abs($distV)
$distH = [Math]::Abs($distH)
$manhattan = $distV + $distH
Write-Host "Manhattan Distance = $manhattan"