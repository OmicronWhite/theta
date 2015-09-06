Theta
=============
*Theta* is a continuation of All Out War 2: The Omega Project.

##Maps
 * __AOW01__ - Red Zone
 * __AOW02__ - Barrens
 * __AOW03__ - Disk Defrag
 * __AOW04__ - Oasis
 * __AOW05__ - Virtual Zone
 * __AOW06__ - Glacier
 * __AOW07__ - Sand Canyon

Come join our IRC channel! We're at `irc.zandronum.com #theta`.

##Building
### Windows
If you're on Windows, building Theta is really easy!  
Just clone the repo or [download it as a zip](https://github.com/PlusGit/theta/archive/master.zip), then run `build.bat` or `build_from-zip.bat` respectvely.
Tools will run in 64-bit if they can, if you don't want them to then just run `build.bat /FORCEWIN32`.
### Linux
It's slightly more complicated on Linux:

__Install needed packages__  
```bash
sudo apt-get install gcc g++ p7zip-full git premake4
```
__Initialise your enviroment__  
`cd` to where you cloned theta, and then:
```bash
utilities/linux/initenv.sh
```
to prepare your enviroment.

Then, you can just run `./build.sh` in your Theta root directory (use `-n` option to build without a version).
