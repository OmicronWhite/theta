Theta
=============
*Theta* is a continuation of All Out War 2: The Omega Project.

Come join our IRC channel! We're at `irc.zandronum.com #theta`.  
Also check out our forums at [theta.plussean.co.uk](http://theta.plussean.co.uk).

[![Support us on ModDB](http://button.moddb.com/popularity/medium/mods/28018.png)](http://www.moddb.com/mods/theta)

##Maps
 * __AOW01__ - Red Zone
 * __AOW02__ - Barrens
 * __AOW03__ - Disk Defrag
 * __AOW04__ - Oasis
 * __AOW05__ - Virtual Zone
 * __AOW06__ - Glacier
 * __AOW07__ - Sand Canyon
 * __AOW08__ - Valley
 * __AOW09__ - Infected

 To see the status of maps and what maps are coming, see [this issue tracker ticket](https://github.com/PlusGit/theta/issues/42).

## Get
The [releases page](https://github.com/PlusGit/theta/releases) is the most up-to-date source of *stable* releases of Theta. For development builds, see the [Building](https://github.com/PlusGit/theta#building) section below.

You can also get some stable releases from our [ModDB page](http://www.moddb.com/mods/theta/downloads) and [TSPG Britsteel](http://britsteel.allfearthesentinel.net/wads), but these may be outdated.

## Hosting
__IWAD:__ `doom2.wad`

__WADs:__ (must be loaded in this order)
 - `skulltag_content_2.1a.pk3` - [Download](http://grandvoid.sickedwick.net/wads/skulltag_content2.1a.pk3) - While Theta is mostly independant of Skulltag, it still needs some bits and bobs.
 - `theta_base_X.XX.X.pk3` - [Check for Latest Release](https://github.com/PlusGit/theta/releases)
 - `theta_code_X.XX.X.pk3` - [Check for Latest Release](https://github.com/PlusGit/theta/releases)
 - `theta_maps_X.XX.X.pk3` - [Check for Latest Release](https://github.com/PlusGit/theta/releases)
 - `theta_music_X.XX.X.pk3` - [Check for Latest Release](https://github.com/PlusGit/theta/releases)

## Building
### Windows
If you're on Windows, building Theta is really easy!  
Just clone the repo or [download it as a zip](https://github.com/PlusGit/theta/archive/master.zip), then run `build.bat` or `build_from-zip.bat` respectvely.
Tools will run in 64-bit if they can, if you don't want them to then just run `build.bat /FORCEWIN32`.
### Linux
It's slightly more complicated on Linux:

####Install needed packages
__Debian/Ubuntu/Linux Mint/etc__
```bash
sudo apt-get install gcc g++ p7zip-full git
```
__Arch Linux__
```bash
sudo pacman -S gcc p7zip git
```
####Initialise your enviroment  
`cd` to where you cloned theta, and then:
```bash
utilities/linux/initenv.sh
```
to prepare your enviroment.

Then, you can just run `./build.sh` in your Theta root directory (use `-n` option to build without a version).

## Credits
 - Voltlock, for creating *All Out War*
 - The *Omega* Team for creating *All Out War 2: The Omega Project*, which *Theta* is a fork of
 - The *Theta* Team, for developing *All Out War 2: The Theta Project*
 - [Freedoom](https://freedoom.github.io/), for creating an open-source Doom IWAD, which *Theta* will soon use resources from.
