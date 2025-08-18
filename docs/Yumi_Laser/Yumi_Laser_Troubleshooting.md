# 1.8 Troubleshooting

This section lists common issues encountered during the operation of the **YUMI Laser Series**, along with their possible causes and recommended solutions.

<img src="../../img/Yumi_laser/troubleshooting/yumi_laser_troubleshooting.png" width="600" alt="YUMI Laser Troubleshooting">

---

## 1. Laser Does Not Turn On

**Possible causes:**
- Power adapter not connected or faulty
- Power switch in OFF position
- Loose cable connections
- Defective laser module

**Solutions:**
1. Verify that the 12V power supply is plugged in and functioning.
2. Check the main power switch on the laser.
3. Inspect all cable connections.
4. Test with another laser head if available.

---

## 2. Laser Fires but Does Not Engrave/Cut

**Possible causes:**
- Laser power set too low
- Incorrect focus distance
- Material not compatible
- Lens dirty or damaged

**Solutions:**
1. Increase power in software settings.
2. Re-adjust the laser focus using the provided gauge.
3. Use approved materials only.
4. Clean or replace the lens.

---

## 3. Uneven Engraving or Cutting

**Possible causes:**
- Air Assist not working properly
- Bed surface uneven
- Material not fixed securely
- Dirty optics

**Solutions:**
1. Check Air Assist pump and tubing.
2. Level the honeycomb bed.
3. Secure material with clips or magnets.
4. Clean laser lens and mirrors.

---

## 4. Wi-Fi Connection Issues

**Possible causes:**
- Incorrect SSID or password
- Weak Wi-Fi signal
- IP conflict on the network
- Firmware not updated

**Solutions:**
1. Re-enter correct Wi-Fi credentials.
2. Move the laser closer to the router.
3. Assign a fixed IP in your router settings.
4. Update the machine’s firmware.

---

## 5. Software Cannot Detect the Laser

**Possible causes:**
- USB cable faulty or disconnected
- Incorrect COM port selected
- Driver not installed
- Laser in Wi-Fi mode only

**Solutions:**
1. Use the supplied USB cable or a known good one.
2. Select the correct COM port in LightBurn or LaserGRBL.
3. Install the CH340 driver.
4. Switch to USB mode if needed.

---

## 6. Burning or Excessive Charring on Material

**Possible causes:**
- Power too high for material
- Speed too low
- Air Assist disabled

**Solutions:**
1. Reduce laser power.
2. Increase movement speed.
3. Enable Air Assist for cleaner cuts.

---

## Related Pages

- [1.2 Safety Guidelines](Yumi_Laser/Yumi_Laser_Safety.md)
- [1.4 LightBurn Setup and First Engraving](Yumi_Laser/Yumi_Laser_LightBurn.md)
- [1.5 LaserGRBL Setup and First Engraving](Yumi_Laser/Yumi_Laser_LaserGRBL.md)
- [1.6 Wireless Control](Yumi_Laser/Yumi_Laser_Wireless.md)

---

**Suggested images:**
- `../../img/Yumi_laser/troubleshooting/no_power.png` – laser not turning on
- `../../img/Yumi_laser/troubleshooting/no_cut.png` – laser firing without cutting
- `../../img/Yumi_laser/troubleshooting/uneven_cut.png` – uneven engraving
- `../../img/Yumi_laser/troubleshooting/wifi_error.png` – Wi-Fi issue example
