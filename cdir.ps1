function cdir() {
<#
.SYNOPSIS
    This function name is short for colorful directory. It will output the usual results of a dir, ls, or Get-ChildItem,
    but each line (excluding the header) will be a random color. As a health precaution, the random colors are off. Recurses by default.

.DESCRIPTION
    cdir should not be used instead of dir, unlike dir, each file or directory is not treated as an object. Rather, the objects
    dir provides are utilized by piping it to this function's definition and displayed as colored text with the Write-Host function.
    This is a function for fun and just a way to mimic dir but change it slightly.

.PARAMETER Path
    By default, the value of this parameter is the current working directory. The path can be specified in the call.

.PARAMETER Color
    Boolean for whether or not to use the random color formatting. Set to false by default so no one has a seizure.

.EXAMPLE
    Colorfully prints the entire contents of the C:\ drive with random colors for each line (excluding the header)
    PS C:\> cdir -Color $true

.NOTES
    Author: Corey Buckley
    Last Edit: 2018-05-02
    Version 1.0 - initial release of cdir

#>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false)] #Decorator for Parameters. Mandatory is default false, but put for reference
        [string]$path=".", #Set default value of current directory
        [boolean]$color=$false
    )
    Process {
        dir -r $path | ForEach-Object {
            $formatPattern = "{0,-6}`t{1,25}`t{2,10} {3,-25}"; #Mode, LastWriteTime, Length, and Name will be used for the string interpolation
            $colors = "Yellow", "Red", "White", "Blue", "Green", "Magenta", "Black";
            $initial = 0; #will be used as a debounce
        } {
        $bg = if($color) { Get-Random -InputObject $colors; } else { "black"}
        $fg = if($color) { Get-Random -InputObject $colors; } else { "white"}
        if ($initial -eq 0) {
            $dirPath = $_.FullName.TrimEnd($_.Name); #Because DirectoryName is only for files and PSPath includes
                                                     #the Powershell path, just take the whole path and remove the
                                                     #file or directory name at end
            Write-Host -BackgroundColor "black" -ForegroundColor "white" "`n    Directory:" $dirPath;
            $header = "`n`n"+$formatPattern -f ("Mode","LastWriteTime","Length","Name")
            Write-Host -BackgroundColor "black" -ForegroundColor "white" $header
            $underlines = $formatPattern -f ("----","-------------","------","----");
            Write-Host -BackgroundColor "black" -ForegroundColor "white" $underlines
        }
        $record = $formatPattern -f ($_.Mode.ToString(),$_.LastWriteTime.ToString(),$_.Length.ToString(),$_.Name)
        Write-Host -BackgroundColor $bg -ForegroundColor $fg $record
        $initial = 1;
        }
    }
}
