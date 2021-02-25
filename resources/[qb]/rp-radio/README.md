# rp-radio
An in-game radio which makes use of the mumble-voip radio API for FiveM

### Exports
Getters

| Export           | Description                                         | Return type |
| ---------------- | --------------------------------------------------- | ----------- |
| IsRadioOpen      | Check if player is holding radio                    | bool        |
| IsRadioOn        | Check if radio is switched on                       | bool        |
| IsRadioAvailable | Check if player has a radio                         | bool        |
| IsRadioEnabled   | Check if radio is enabled                           | bool        |
| CanRadioBeUsed   | Check if radio can be used                          | bool        |

Setters
 
| Export                          | Description                                                 | Parameter(s)  |
| ------------------------------- | ----------------------------------------------------------- | ------------- |
| SetRadioEnabled                 | Set if the radio is enabled or not                          | bool          |
| SetRadio                        | Set if player has a radio or not                            | bool          |
| SetAllowRadioWhenClosed         | Allow player to broadcast when closed                       | bool          |
| AddPrivateFrequency             | Make a frequency private                                    | int           |
| RemovePrivateFrequency          | Make a private frequency public                             | int           |
| GivePlayerAccessToFrequency     | Give a player access to use a private frequency             | int           |
| RemovePlayerAccessToFrequency   | Remove a players access to use a private frequency          | int           |
| GivePlayerAccessToFrequencies   | Give a player access to use multiple private frequencies    | int, int, ... |
| RemovePlayerAccessToFrequencies | Remove a players access to use multiple private frequencies | int, int, ... |

### Commands

| Command    | Description              |
| ---------- | ------------------------ |
| /radio     | Open/close the radio     |
| /frequency | Choose radio frequency   |

### Events

| Event        | Description                      | Paramters(s)           |
| ------------ | -------------------------------- | ---------------------- |
| Radio.Toggle | Opens/close the radio            | none                   |
| Radio.Set    | Set if player has a radio or not | bool                   |

### Preview

- [MP4](https://imgur.com/bAT0mls)
