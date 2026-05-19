# Lubricate X/Y Rails

**Interval:** Every 30 days  
**Difficulty:** Easy  
**Time:** 5 minutes  
**Applies to:** C235, C335, C435

## Why

The X and Y linear rails and guide blocks accumulate dust and dried lubricant over time. Without regular lubrication, you'll notice:

- Increased noise during fast moves
- Layer shifts at high acceleration
- Premature wear on the linear bearings

## What You Need

- **Lubricant oil** (not grease) — PTFE-based or sewing machine oil
- Lint-free cloth or paper towel

!!! warning "Use oil, not grease"
    For X/Y linear rails, always use **lubricant oil**. Grease is too thick and attracts dust on horizontal rails. Save grease for the Z lead screw.

## Steps

### 1. Home the printer
Run a full home (`G28`) so you can access the full rail length.

### 2. Power off motors
Send `M84` to disable stepper motors. This lets you slide the carriage freely by hand.

### 3. Clean the rails
Wipe both X and Y rails with a dry lint-free cloth to remove old oil and dust.

### 4. Apply oil
Apply 2-3 drops of lubricant oil along each rail. Move the carriage back and forth by hand to distribute evenly.

- **X rail:** along the horizontal rail at the front of the gantry
- **Y rail:** along the two guide rails on each side of the bed

### 5. Wipe excess
Remove any excess oil with the cloth. The rails should look slightly wet, not dripping.

### 6. Mark as done
On your SmartPad: **Menu > More > Maintenance > Lubricate X/Y Rails > Done**

## Tips

- If you print daily, consider lubricating every 2 weeks instead of monthly
- Listen for unusual sounds during printing — squeaking means the rails are dry
- Never use WD-40 — it evaporates quickly and leaves residue
