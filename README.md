# [Activate Background Music](https://github.com/Jerajo/activate-background-music)

<iframe width="560" height="315" src="https://www.youtube.com/embed/lRAu6ZpLEJI?ecver=1" frameborder="0" allowfullscreen></iframe>

#### This is an extension package for activate-power-mode that allow you to listen your favorite music while you are on Combo Mode.

## Requirements

Needs Activate-Power-Mode package installed.

## Usage

- Activate with <kbd>Alt</kbd>-<kbd>A</kbd> or through the command panel with `Activate Background Music: Toggle`. Use the command again to deactivate.

- or activate by going `settings/packages/activate-background-music/enable`

**IMPORTANT: When `Background Music` is enabled, music won't play until you reach the activation threshold on activate-power-mode settings.**

## Install

With the atom package manager:
```bash
apm install activate-background-music
```
Or Settings ➔ Packages ➔ Search for `activate-background-music`

## Settings

### Play Intro Audio

* **Enable/Disable**
* Path to Audio
* Volume

### Play Background Music - Actions

<table class="Actions" style="text-align:center">

  <tr>  <th></th> <th colspan="5">EXECUTION</th>  </tr>

  <tr>  <th>LAPSETYPE</th> <td>Streak</td> <td>Time</td>  <td></td> <td></td> <td></td>  </tr>

  <tr>  <th>ACTIONS</th> <th colspan="2">DURINGSTREAK</th> <th>ENDSTREAK</th> <th>NEXTLEVEL</th> <th>ENDMUSIC</th>  </tr>

  <tr>  <td>None</td> <td colspan="2">X</td> <td>X</td> <td>X</td> <td>X</td>  </tr>

  <tr>  <td>Play</td> <td colspan="2">X</td> <td></td> <td>X</td> <td>X</td>  </tr>

  <tr>  <td>Pause</td> <td colspan="2">X</td> <td></td> <td>X</td> <td></td>  </tr>

  <tr>  <td>Stop</td> <td colspan="2">X</td> <td>X</td> <td>X</td> <td></td>  </tr>

  <tr>  <td>Repeat</td> <td colspan="2">X</td> <td>X</td> <td>X</td> <td>X</td>  </tr>

  <tr>  <td>Previous</td> <td colspan="2">X</td> <td>X</td> <td>X</td> <td>X</td>  </tr>

  <tr>  <td>Next</td> <td colspan="2">X</td> <td>X</td> <td>X</td> <td>X</td>  </tr>

</table>

### Commands

<table>

  <tr>  <th>SHORTCUT</th> <th>NAME</th> <th>DESCRIPTION</th>  </tr>

  <tr>  <td>alt-a</td> <td>Toggle</td> <td>Enable/Disable the plugin</td>  </tr>

  <tr>  <td>shift-alt-p</td> <td>Play/Pasue (Toggle)</td> <td>Play/Pause the music</td>  </tr>

  <tr>  <td>shift-alt-s</td> <td>Stop</td> <td>Stop  the music</td>  </tr>

  <tr>  <td>shift-alt-r</td> <td>Repeat</td> <td>Repeat the music</td>  </tr>

  <tr>  <td>shift-alt-m</td> <td>Mute (Toggle)</td> <td>Mute (Toggle) On/Off</td>  </tr>

  <tr>  <td>alt-right</td> <td>Next</td> <td>Switch to the next music</td>  </tr>

  <tr>  <td>alt-left</td> <td>Previous</td> <td>Switch to the previous music</td>  </tr>

  <tr>  <td>alt-up</td> <td>VolumeUp</td> <td>Turn up the music</td>  </tr>

  <tr>  <td>alt-down</td> <td>VolumeDown</td> <td>Turn down the music</td>  </tr>

</table>
