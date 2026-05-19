# Check Wiring

**Interval:** Every 180 days  
**Difficulty:** Medium  
**Time:** 15 minutes  
**Applies to:** C235, C335, C435

## Why

Vibration and heat cycling can loosen connections over time. Loose wires cause:

- Intermittent thermal runaway errors
- Random disconnects (MCU timeout)
- Fire hazard from loose heater connections

## What You Need

- No special tools (visual inspection)
- Flashlight helpful

## Steps

### 1. Power off completely
Turn off the printer, unplug the power cable. Wait 5 minutes for capacitors to discharge.

### 2. Check hotend wiring
Inspect the wires going to the hotend:

- Heater cartridge wires — firm in connector, no exposed copper
- Thermistor wires — thin, check for nicks or breaks
- Fan wires — not rubbing against moving parts

### 3. Check bed wiring
The bed heater draws high current. Check:

- Bed heater connector — no discoloration or melting
- Bed thermistor wire — not pinched under the bed

### 4. Check motherboard connectors
Open the electronics enclosure:

- All stepper motor connectors seated firmly
- Fan connectors not loose
- No burnt smell or discoloration

### 5. Check smartbox (if equipped)
If you have a HyperDrive smartbox:

- UART/USB cable between motherboard and smartbox secure
- All YMS motor connectors firm
- Dryer heater connector — check for heat damage

### 6. Check cable chains
Inspect the cable chain (if present):

- No wires pinched at the hinges
- Enough slack for full travel
- No wires poking out

### 7. Mark as done
On your SmartPad: **Menu > More > Maintenance > Check Wiring > Done**

## Tips

- Take a photo of the wiring before touching anything — for reference
- If you find a loose connector, don't just push it back — check the terminal crimps
- Any sign of melting or discoloration = replace the connector immediately
