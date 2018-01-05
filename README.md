<p align="center">
<img src="https://i.imgur.com/cptqDaD.png" height="96px" width="96px"/>
<br/>
<h3 align="center">Easy Downloader</h3>
<p align="center">Download and Precache files the easy way.</p>
<h2></h2>
</p>
<br />

<p align="center">
<a href="../../releases"><img src="https://img.shields.io/github/release/InvexByte/EasyDownloader.svg?style=flat-square" /></a>
<a href="../../issues"><img src="https://img.shields.io/github/issues/InvexByte/EasyDownloader.svg?style=flat-square" /></a>
<a href="../../pulls"><img src="https://img.shields.io/github/issues-pr/InvexByte/EasyDownloader.svg?style=flat-square" /></a> 
<a href="LICENSE.md"><img src="https://img.shields.io/github/license/InvexByte/EasyDownloader.svg?style=flat-square" /></a>
</p>

## Description
This plugin is a simple downloader plugin which downloads/precaches files on any mod. 

## Instructions
* Compile **easydownloader.sp**
* Copy **easydownloader.smx** to your server.
* Configure files to download/precache by editing text files in **/config/easydownloader**
* Change map on server.

## Configuration
Use file/directory paths relative to gamedir root (so include "sound/", "materials/" etc).  
One file/directory path per line in the relevant config file.  
Directory paths should **NOT** end with a separator character ('/')  
Directories are downloaded recursively.  
Blank lines and comment lines (starting with //) are ignored.  

* **decals.txt** - Uses API function PrecacheDecal. For: **.vtf**,**.vmt**
* **generics.txt** - Uses API function PrecacheGeneric. For: **.pcf**
* **models.txt** - Uses API function PrecacheModel. For: **.mdl**
* **sentencefiles.txt** - Uses API function PrecacheSentenceFile
* **sounds.txt** - Uses API function PrecacheSound. For: **.mp3**, etc
* **downloadonly.txt** - Downloads only. No precaching. For: **.phy**,**.vvd**,**.vtx**,**.vtf**,**.vmt**, etc

## Options

**Extension whitelisting**  
You can whitelist certain extensions when using recursive directory downloading.  
When using this option, only files with the provided extensions will be downloaded/precached.  

Example in **models.txt**:
```
//Download all .mdl files from the folder below
models/player/custom_player/some_folder|exts=.mdl
```

Example in **downloadsonly.txt**:
```
//Download the other model files required
models/player/custom_player/some_folder|exts=.dx90.vtx,.phy,.vvd
materials/models/player/some_folder|exts=.vmt,.vtf
```

## Acknowledgements 
I decided to write this plugin after SM File/Folder Downloader and Precacher (https://forums.alliedmods.net/showthread.php?t=69005) stopped working for me.  
Huge props to SWAT_88 though, RIP buddy ❤️

**Powerlord:** CSGO/DOTA Asterisk fake precache method (https://forums.alliedmods.net/showthread.php?t=237045)

## AlliedModders Plugin Thread
Link: [https://forums.alliedmods.net/showthread.php?t=292207](https://forums.alliedmods.net/showthread.php?t=292207)

## Contributions
Contributions are always welcome!
Just make a [pull request](../../pulls).

## Licence
GNU General Public License v3.0
