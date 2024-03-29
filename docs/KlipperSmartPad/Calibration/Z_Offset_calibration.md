# 2.2 Extruder calibration

## From Mainsail

From the dashboard, switch to the Console section.
Run command `G28` to reposition the head on its origin point.
You can run the `G28` command by clicking on the `Home` button

![Zoffset](/img/KlipperSmartPad/Z_Offset_Calibration/Zoffset001.png)

Run command:
```
G28
PROBE_CALIBRATE
```
Carry out the adjustment with the sheet of paper.
Make sure that the nozzle is clean and clear of any filament residue
which could distort measurements.
Now you need to set the Z position using the TESTZ command.
The principle is simple: you need to gradually lower your nozzle
to perfectly adjust the height between your platen and the nozzle. Position
a sheet of paper and use the interface
to raise or lower the Z.

![Zoffset](/img/KlipperSmartPad/Z_Offset_Calibration/Zoffset002.png)

Once the head is correctly set, run the `ACCEPT` command and then
```
SAVE_CONFIG
```
Mainsail will restart and your configuration will be saved.
Change the `G28` command to reposition the head at its origin point