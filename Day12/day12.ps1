[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $FileName = "input.txt"
)

# Initialize each distance to 0 just in case it is not initialized properly in the process
$distances = @{ North = 0; East = 0; South = 0; West = 0; }
# Directions used for easily turning
$directions = @{ 1 = 'N'; 2 = 'E'; 3 = 'S'; 4 = 'W' }
# Rotation values assuming there is only these 3 values for degrees
$rotations = @{ '90' = 1; '180' = 2; '270' = 3; }
$waypoint = @{ 2 = 10; 1 = 1; } # East 10 and north 1

# East is the default starting direction
$currDir = 2

# Use the location of the current script to append to the filename
# File must be in the same location as the script
$FileName = $PSScriptRoot + "\" + $FileName

# Takes a direction of 'L' or 'R' and a degrees of '90', '180' or '270' and rotates the ship
function Turn-Ship([int]$oldDir, [string]$direction, $degrees) {
    Write-Host "Rotating $direction from " $directions.$oldDir " by $degrees degrees"
    if ($direction -eq 'L') {
        $currDir = $oldDir - $rotations.$degrees
        # If it goes under 1 then it is no longer a direction so adjust it
        if ($currDir -lt 1) {
            $currDir += 4
        }
    } else {
        $currDir = $oldDir + $rotations.$degrees
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

# Move the ship in the given direction by the given amount
function Move-Waypoint([string]$direction, [int]$amount) {
    Write-Host "Adding $amount to $direction"
    switch ($direction) {
        'N' {
            $waypoint.1 += $amount
            Break
        }
        'E' {
            $waypoint.2 += $amount
            Break
        }
        'S' {
            $waypoint.3 += $amount
            Break
        }
        'W' {
            $waypoint.4 += $amount
            Break
        }
    }
}

function Move-Second-Ship([int]$amount) {
    foreach ($key in $waypoint.Keys) {
        Write-Host "Adding $amount to $key : " $directions.$key
        switch ($key) {
            1 {
                $distances["North"] += $waypoint.$key * $amount
                Break
            }
            2 {
                $distances["East"] += $waypoint.$key * $amount
                Break
            }
            3 {
                $distances["South"] += $waypoint.$key * $amount
                Break
            }
            4 {
                $distances["West"] += $waypoint.$key * $amount
                Break
            }
            Default {}
        }
    }
}

function Part-One {
    foreach($line in [System.IO.File]::ReadLines($FileName))
    {
        $dir = $line.substring(0, 1)
        $value = $line.substring(1, $line.length - 1)
        #Write-Host "$dir : $value"
        switch ($dir) {
            {@('L', 'R') -contains $_} {
                $currDir = Turn-Ship $currDir $dir $value
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
    Write-Host ""
}

function Part-Two {
    foreach($line in [System.IO.File]::ReadLines($FileName))
    {
        $dir = $line.substring(0, 1)
        $value = $line.substring(1, $line.length - 1)
        #Write-Host "$dir : $value"
        switch ($dir) {
            {@('L', 'R') -contains $_} {
                $toAdd = @{}
                $toRemove = @()
                foreach ($key in $waypoint.Keys) {
                    $newDir = Turn-Ship $key $dir $value
                    $toAdd.$newDir = $waypoint.$key
                    $toRemove += $key
                }
                foreach ($key in $toRemove) {
                    $waypoint.Remove($key)
                }
                foreach ($key in $toAdd.Keys) {
                    $waypoint.$key = $toAdd.$key
                }
                Break
            }
            'F' {
                Move-Second-Ship $value
                Break
            }
            Default {
                Move-Waypoint $dir $value
            }
        }
        # Display the current values for debugging
        #Write-Host "North: " $distances.North
        #Write-Host "East:  " $distances.East
        #Write-Host "South: " $distances.South
        #Write-Host "West:  " $distances.West
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
}

# Part 1
Write-Host "Part One"
Part-One

# Clear all distances and reset the direction
$distances.North = 0
$distances.East = 0
$distances.South = 0
$distances.West = 0
$currDir = 2

# Part 2
Write-Host "Part Two"
Part-Two