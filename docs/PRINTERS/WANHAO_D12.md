# Klipper Wanhao D12 installation

![WANHAO D12 230/300/400/500](/img/Printers/Wanhao/wanhao_d12_banner.png)

This procedure is for anyone who has a WANHAO D12 and a SmartPad klipper control device.

## Please read the procedure first

You are responsible for all operations carried out on your equipment. This procedure explains how to set up klipper on your printer. It has been tested and is fully functional.

This procedure has been tested and approved for Ruby 1.2 motherboards. Do not install it on other motherboards.

# Hardware and software :

**First Step: Identify your motherboard model and motor driver connections.**
We recommend updating your printer to the official MARLIN 2 release available at [Wanhao France](https://formation.wanhaofrance.com/slides/slide/firmware-d12-230-758?fullscreen=0&fullscreen=1).

If you have a BLTouch and cannot find your specific firmware, do not worry. The most critical step is to ensure axis homing is working and to check if all motors, including the extruder motor, are rotating correctly. If everything checks out, navigate to `Settings` > `About` to view all the details for upgrading to Klipper with the smart pad.

![WANHAO D12 230/300/400/500 update to klipper](/img/Printers/Wanhao/wanhao_D12_Marlin2_to_klipper.png)
Visit the GIT HUB YUMI-CONFIG: [https://github.com/Yumi-Lab/yumi-config](https://github.com/Yumi-Lab/yumi-config).
Download the `printer.cfg` file and the Klipper firmware according to the Marlin2 'ABOUT' menu.
![WANHAO D12 230/300/400/500 update to klipper](/img/Printers/Wanhao/wanhao_d12_github_yumi-config.png)

Please read the `readme.txt` file to rename the `*.bin` file appropriately.
After renaming the file according to the `readme.txt`, place the `.bin` file in the root folder of your microSD card and insert it into your printer.
Wait for the update to complete without turning off the printer.
Remove your microSD card and reboot your printer.
To finalize, open your MAINSAIL INTERFACE at http://yumios.local or http://"smartpad ip".
Finally, go to the Machine menu and replace the `printer.cfg` with the one you just downloaded from GitHub. Please click to save & restart.

# Slicer profile
## Orcaslicer
    
    comming soon

# Print

I recommend starting with a calibration cube. 

https://www.thingiverse.com/thing:1278865

Once you've got a perfect cube, you can start printing 😉
