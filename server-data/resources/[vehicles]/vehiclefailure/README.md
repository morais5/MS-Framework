# Realistic Vehicle Failure

This is a mod for FiveM / GTA V that aims to create realistic vehicle failure.

## Features:
### Realistic Vehicle Failure
* Makes the vehicle fail faster and more realistic.
* Shooting windows, kicking the car, throwing baseballs or snowballs at it will NOT disable the car!
* Shooting at the engine or fuel tank will damage the vehicle, but not necessarily disable it completely.
* When sustaining a certain amount of damage, the car will begin to degrade quickly and finally die.
* Car will slow down progressively as damage increases.
* Increases visual damage a lot  (Please note that visual damage doesn’t sync well to other players)
* A vehicle that's upside down or on its side can't be turned over by the usual steering trick.
* Car doesn't just stop suddenly when hitting something, but will often degrade, smoke and sputter before dying, and finally roll to a stop.
* Optional limp mode. If enabled, the vehicle will not die completely, but be able to drive very slowly.
* Car will not catch fire or explode, not even when landing on the roof.
* Car is still reenterable, so you can fix it with a trainer.
* Everything is configurable so you can fine tune the behavior to your liking
* You can still put armor on the car to improve its resistance to abuse.
* Sunday driver feature: Smooth acceleration and braking. Easy speed control makes it much easier to drive a steady slow speed. Brake holder feature prevents vehicle from switching direction after braking, and keeps the brakelight on while holding the brake.

### Realistic Vehicle Repair
* Type /repair in the chat to repair your vehicle. There are two types of repairs, depending on your location:
#### At the mechanic
* If you are at a mechanic your vehicle will be completely fixed, as good as new.
* Mechanics are located several places in San Andreas. Look for the blips on the map.
#### Not at a mechanic
* If you are not at a mechanic, you may be able to perform a DIY emergency repair in the field.
* You can only reattach the oil plug once or twice, but after that, the vehicle will be beyond repair.
* An emergency repair in the field will only make the car drivable, not completely fixed. A minor accident will most likely kill the car again.
* If you let the damaged car sit too long, the oil will drain completely, preventing further repairs.
* Electric vehicles can not be fixed by you, only by a mechanic. Technology is complex, and chewing gum just won't fix a dead battery.

## Configuration

Lots of settings in config.lua.
Each option is explained in the file.
Be careful. Weird settings can cause weird behavior.
If you restart the script (as you should after changing the settings) exit the car first, or spawn/steal a new car after. Failure to do so may cause odd behavior of the current car.

## Compatibility
Known to be incompatible with BVA (Basic Vehicle Actions). Tested with BVA v2.01. If you turn off the vehicle using BVA, it is rendered inoperable. This is due to a bad implementation in BVA that sets the fuel tank health to zero when turning off the vehicle.

## Download

https://github.com/iEns/RealisticVehicleFailure/archive/master.zip

## Installation

Disable or remove other vehicle health scripts. Running two or more vehicle health scripts will give unpredictable results 

### FiveM Server

If you run a FiveM server, you know what to do... but these are the basic instructions, in case you forgot:

* Copy the .lua files to a new folder in your Resources folder
* Add a line to your config: start [foldername]
* Restart server or
* Refresh + start [foldername]

Where [foldername] is the folder in Resources where the .lua files are located.