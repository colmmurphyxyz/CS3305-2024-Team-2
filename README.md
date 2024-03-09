# Sands of Orisis
![Game title: Sands of Orisis](./Doc_Images/gametitle.png)  

# Contents
- [Sands of Orisis](#sands-of-orisis)
- [Contributors:](#contributors-)
- [Synopsis](#synopsis)
- [How to Play](#how-to-play)
  * [Creating a lobby and starting a round](#creating-a-lobby-and-starting-a-round)
  * [Early Game](#early-game)
  * [Mid Game](#mid-game)
  * [Late Game](#late-game)
- [Installation](#installation)
  * [Linux](#linux)
  * [Mac](#mac)
  * [Windows](#windows)

# Contributors:  
- [Colm Murphy](https://github.com/colmmurphyxyz)
- [Darragh Murphy](https://github.com/Durph21)
- [Ben Shorten](https://github.com/benshorten72)
- [David Wilson](https://github.com/Szazlo)

Sands of Orisis is a Real Time Strategy game developed in [Godot](https://github.com/godotengine/godot) 4 as our submission for CS3305 - Team Software Project
# Synopsis
Orisis has been recently discovered to hold the incredibly rare and valuable resource, unobtainium. You, commander of a fleet, have landed near a deposit of unobtainium to find that you are not the only one to have discovered this planet's treasure.
Face off in 1v1 battles with another player as you compete for control over ore deposits of iron and unobtainium. As each player obtains more resources they can progress further up the technology tree, allowing the construction of powerful machines with the help of scientific laboratories and weapons barracks.

# How to Play
## Creating a lobby and starting a round
- Find a friend on the same local network and launch the game
- If Hosting, simply enter your name, a port to host on and hit `Host Game`
  	- Share your IP address with your friend so they can join you.
  	- You can find this by running `ifconfig -a` on Mac/Linux, or `ipconfig` in a Windows Command Prompt
  	- It will generally be of the form `192.168.x.y`, `172.x.y.z` or `10.x.y.z`
- If joining, Enter the IP and port provided by your friend, and hit `Join Game`
- When prompted press the button to start the game
## Early Game
![image](https://github.com/colmmurphyxyz/CS3305-2024-Team-2/assets/65133392/5d70caa8-2dbb-47c6-a753-1d83eb2a1baf)
- You will enter the game with nothing but a Headquarters and a nearby iron deposit.
- Both players will slowly receive iron over time
- Right click your HQ to train a drone and build a mine in the nearby iron deposit
- Assign your drone to repair the mine by selecting the drone and right-clicking the mine
- When the mine is repaired you can then assign your drone gather iron from the mine and transport it back to the HQ
- Use your iron to build a barracks, unlocking the *sniper* and *bruiser* units
## Mid Game
![image](https://github.com/colmmurphyxyz/CS3305-2024-Team-2/assets/65133392/0f71f2ca-118c-484a-8105-4f7617575e10)
- When you feel ready, venture out to the centre of the map and wage war for control of the valueable *unobtainium* deposits
- Build a Science Laboratory and defend your army with the hulking *warden* unit
- Sneak behind enemy lines and investigate the battlefield with the nimble, but weak *scout*
- Sabotage your opponent's operations by destroying their mines and blockading their paths
## Late Game
![image](https://github.com/colmmurphyxyz/CS3305-2024-Team-2/assets/65133392/63c37961-74cb-443b-a014-4887c1131139)
- It is time for you to wipe your opponent from the face of Orisis and claim her wealth of unobtainium all for yourself
- Assemble an army and command them to attack your enemy's HQ directly
- Use the insanely overpowered ***Fusion Screecher*** to incinerate entire infantries with a single blast of its _lazer_
- Only when their headquarters is reduced to rubble will they be forced to surrender and declare you the Ruler of Orisis


# Installation
## Linux
- Head to the [Releases](https://github.com/colmmurphyxyz/CS3305-2024-Team-2/releases) page and download the `sandsoforosis_linux.x86_64` binary and `sandsoforisis_linux.sh` scripts
- with both files in the same directory, run the `sandsoforisis_linux.sh` script
## Mac
 - Download `sandsoforisis_mac.x86_64.zip` from the [Releases](https://github.com/colmmurphyxyz/CS3305-2024-Team-2/releases) page
 - Run RTS.app file
## Windows
- Download `sandsoforisis_windows.x86_64.zip` from the [Releases](https://github.com/colmmurphyxyz/CS3305-2024-Team-2/releases) page
- extract the zip archive and run `sandsoforisis_windows.x86_64.exe`
- Windows Defender may give you some grief. We promise you we come in peace
