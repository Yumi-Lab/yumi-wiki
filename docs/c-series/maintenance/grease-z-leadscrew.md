# Grease Z Lead Screw

**Interval:** Every 90 days  
**Difficulty:** Easy  
**Time:** 5 minutes  
**Applies to:** C235, C335, C435

## Why

The Z lead screw carries the full weight of the X gantry and hotend. Dried grease causes:

- Z wobble artifacts (visible as periodic ridges on tall prints)
- Increased Z motor current draw
- Accelerated wear on the anti-backlash nut

## What You Need

- **Lubricant grease** (lithium or PTFE-based)
- Lint-free cloth

!!! tip "Grease, not oil"
    Unlike X/Y rails, the Z lead screw benefits from **grease** because it stays in place and doesn't evaporate as fast on the vertical screw.

## Steps

### 1. Raise the Z axis
Move Z to the top: `G1 Z250 F300` (adjust for your printer height).

### 2. Power off Z motor
Send `M84 Z` to release the Z stepper.

### 3. Clean the lead screw
Wipe the exposed lead screw with a dry cloth from top to bottom.

### 4. Apply grease
Apply a thin line of grease along the lead screw threads. Use your finger or the cloth to spread it evenly along the full length.

### 5. Run Z up and down
Re-enable motors and run `G1 Z10 F300` then `G1 Z250 F300` a few times to distribute the grease through the nut.

### 6. Wipe excess
Clean any grease that squeezed out around the nut.

### 7. Mark as done
On your SmartPad: **Menu > More > Maintenance > Grease Z Lead Screw > Done**

## Tips

- Don't over-grease — a thin coat is enough
- If you see black residue on the screw, it means the old grease was catching dust — clean more thoroughly
- The anti-backlash nut is a wear part, replace it if you feel play in Z
