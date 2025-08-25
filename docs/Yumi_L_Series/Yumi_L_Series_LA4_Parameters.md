# 1.09 YUMI L-A4 — Default GRBL Parameters

This table lists the default GRBL parameters of the **YUMI L-A4**.


| **Code** | **Parameter**                   | **Default Value** | **Unit**     | **Description**                                              |
| -------: | ------------------------------- | ----------------: | ------------ | ------------------------------------------------------------ |
|      \$0 | Step pulse time                 |                10 | microseconds | Duration of a step pulse. Min 3 µs.                          |
|      \$1 | Step idle delay                 |                 5 | milliseconds | Hold motors briefly before disabling (255 = always enabled). |
|      \$2 | Step pulse invert               |                 0 | mask         | Inverts STEP signal. Bit per axis (00000ZYX).                |
|      \$3 | Step direction invert           |                 0 | mask         | Inverts DIR signal. Bit per axis (00000ZYX).                 |
|      \$4 | Invert step enable pin          |                 0 | boolean      | Inverts the EN driver logic level.                           |
|      \$5 | Invert limit pins               |                 0 | boolean      | Inverts the state of limit switch inputs.                    |
|      \$6 | Invert probe pin                |                 0 | boolean      | Inverts the probe input.                                     |
|     \$10 | Status report options           |                 1 | mask         | Selects which data are reported in status messages.          |
|     \$11 | Junction deviation              |             0.010 | mm           | Controls smoothness of path cornering (smaller = slower).    |
|     \$12 | Arc tolerance                   |             0.002 | mm           | Tolerance for G2/G3 arcs (radial error).                     |
|     \$13 | Report in inches                |                 0 | boolean      | If set, reports position in inches.                          |
|     \$20 | Soft limits enable              |                 0 | boolean      | Enables software limits (requires homing).                   |
|     \$21 | Hard limits enable              |                 0 | boolean      | Enables hardware limits (immediate stop on trigger).         |
|     \$22 | Homing cycle enable             |                 1 | boolean      | Enables the homing sequence.                                 |
|     \$23 | Homing direction invert         |                 3 | mask         | Inverts homing direction per axis (00000ZYX).                |
|     \$24 | Homing locate feed rate         |           300.000 | mm/min       | Slow feed rate for precise switch contact.                   |
|     \$25 | Homing search seek rate         |          3000.000 | mm/min       | Fast feed rate for initial homing search.                    |
|     \$26 | Homing switch debounce delay    |           250.000 | milliseconds | Debounce time between homing phases.                         |
|     \$27 | Homing switch pull-off distance |             1.000 | mm           | Pull-off distance after switch trigger.                      |
|     \$28 | —                               |          1000.000 | —            | Reserved / firmware-specific (not documented).               |
|     \$30 | Maximum spindle speed           |          1000.000 | RPM          | Max spindle speed (PWM = 100%).                              |
|     \$31 | Minimum spindle speed           |             0.000 | RPM          | Min spindle speed (PWM \~0.4% or lowest).                    |
|     \$32 | Laser-mode enable               |                 1 | boolean      | Enables laser mode (no dwell between G1/2/3 when S changes). |
|     \$37 | —                               |                 1 | —            | Reserved / firmware-specific (not documented).               |
|     \$38 | —                               |                 1 | —            | Reserved / firmware-specific (not documented).               |
|     \$40 | —                               |                 1 | —            | Reserved / firmware-specific (not documented).               |
|    \$100 | X-axis travel resolution        |            80.000 | steps/mm     | Resolution of X in steps per mm.                             |
|    \$101 | Y-axis travel resolution        |            80.000 | steps/mm     | Resolution of Y in steps per mm.                             |
|    \$102 | Z-axis travel resolution        |            80.000 | steps/mm     | Resolution of Z in steps per mm.                             |
|    \$103 | A-axis travel resolution        |           100.000 | steps/mm     | Resolution of A in steps per mm.                             |
|    \$104 | B-axis travel resolution        |           100.000 | steps/mm     | Resolution of B in steps per mm.                             |
|    \$105 | C-axis travel resolution        |           100.000 | steps/mm     | Resolution of C in steps per mm.                             |
|    \$110 | X-axis maximum rate             |          6000.000 | mm/min       | Maximum X rapid speed (G0).                                  |
|    \$111 | Y-axis maximum rate             |          6000.000 | mm/min       | Maximum Y rapid speed (G0).                                  |
|    \$112 | Z-axis maximum rate             |          6000.000 | mm/min       | Maximum Z rapid speed (G0).                                  |
|    \$113 | A-axis maximum rate             |          1000.000 | mm/min       | Maximum A rapid speed (G0).                                  |
|    \$114 | B-axis maximum rate             |          1000.000 | mm/min       | Maximum B rapid speed (G0).                                  |
|    \$115 | C-axis maximum rate             |          1000.000 | mm/min       | Maximum C rapid speed (G0).                                  |
|    \$120 | X-axis acceleration             |           500.000 | mm/sec^2     | Acceleration of X (planner).                                 |
|    \$121 | Y-axis acceleration             |           500.000 | mm/sec^2     | Acceleration of Y (planner).                                 |
|    \$122 | Z-axis acceleration             |           500.000 | mm/sec^2     | Acceleration of Z (planner).                                 |
|    \$123 | A-axis acceleration             |           200.000 | mm/sec^2     | Acceleration of A (planner).                                 |
|    \$124 | B-axis acceleration             |           200.000 | mm/sec^2     | Acceleration of B (planner).                                 |
|    \$125 | C-axis acceleration             |           200.000 | mm/sec^2     | Acceleration of C (planner).                                 |
|    \$130 | X-axis maximum travel           |           210.000 | mm           | Usable X travel (soft-limits & homing).                      |
|    \$131 | Y-axis maximum travel           |           297.000 | mm           | Usable Y travel (soft-limits & homing).                      |
|    \$132 | Z-axis maximum travel           |            80.000 | mm           | Usable Z travel (soft-limits & homing).                      |
|    \$133 | A-axis maximum travel           |           300.000 | mm           | Usable A travel.                                             |
|    \$134 | B-axis maximum travel           |           300.000 | mm           | Usable B travel.                                             |
|    \$135 | C-axis maximum travel           |           300.000 | mm           | Usable C travel.                                             |

