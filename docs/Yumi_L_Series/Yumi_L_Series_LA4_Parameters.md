# 1.09 YUMI L-A4 — Default GRBL Parameters

This table lists the default GRBL parameters of the **YUMI L-A4**.

<table>
  <thead>
    <tr>
      <th>Code</th>
      <th>Parameter</th>
      <th>Default Value</th>
      <th>Unit</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color:#f9f9f9">
      <td>$0</td><td>Step pulse time</td><td>10</td><td>microseconds</td><td>Duration of a step pulse. Min 3&nbsp;µs.</td>
    </tr>
    <tr>
      <td>$1</td><td>Step idle delay</td><td>5</td><td>milliseconds</td><td>Short hold before disabling motors (255 = always enabled).</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$2</td><td>Step pulse invert</td><td>0</td><td>mask</td><td>Invert STEP signal. Set axis bit (00000ZYX).</td>
    </tr>
    <tr>
      <td>$3</td><td>Step direction invert</td><td>0</td><td>mask</td><td>Invert DIR signal. Set axis bit (00000ZYX).</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$4</td><td>Invert step enable pin</td><td>0</td><td>boolean</td><td>Inverts the stepper driver enable pin logic level.</td>
    </tr>
    <tr>
      <td>$5</td><td>Invert limit pins</td><td>0</td><td>boolean</td><td>Inverts all limit switch inputs.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$6</td><td>Invert probe pin</td><td>0</td><td>boolean</td><td>Inverts the probe input.</td>
    </tr>
    <tr>
      <td>$10</td><td>Status report options</td><td>1</td><td>mask</td><td>Selects which fields are included in status reports.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$11</td><td>Junction deviation</td><td>0.010</td><td>mm</td><td>Cornering tolerance (smaller = smoother/slower).</td>
    </tr>
    <tr>
      <td>$12</td><td>Arc tolerance</td><td>0.002</td><td>mm</td><td>G2/G3 arc tracing radial error tolerance.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$13</td><td>Report in inches</td><td>0</td><td>boolean</td><td>Report positions in inches when enabled.</td>
    </tr>
    <tr>
      <td>$20</td><td>Soft limits enable</td><td>0</td><td>boolean</td><td>Enable software limits (requires homing).</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$21</td><td>Hard limits enable</td><td>1</td><td>boolean</td><td>Enable hardware limits (immediate stop on trigger).</td>
    </tr>
    <tr>
      <td>$22</td><td>Homing cycle enable</td><td>1</td><td>boolean</td><td>Enable homing sequence.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$23</td><td>Homing direction invert</td><td>3</td><td>mask</td><td>Invert homing search direction per axis (00000ZYX).</td>
    </tr>
    <tr>
      <td>$24</td><td>Homing locate feed rate</td><td>300.000</td><td>mm/min</td><td>Slow feed for precise switch contact.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$25</td><td>Homing search seek rate</td><td>3000.000</td><td>mm/min</td><td>Fast seek to find the limit switch.</td>
    </tr>
    <tr>
      <td>$26</td><td>Homing switch debounce delay</td><td>250.000</td><td>milliseconds</td><td>Debounce delay between homing phases.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$27</td><td>Homing switch pull-off distance</td><td>1.000</td><td>mm</td><td>Retract distance after switch triggers.</td>
    </tr>
    <tr>
      <td>$28</td><td>—</td><td>1000.000</td><td>—</td><td>Reserved / firmware-specific.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$30</td><td>Maximum spindle speed</td><td>1000.000</td><td>RPM</td><td>Max spindle speed (PWM = 100%).</td>
    </tr>
    <tr>
      <td>$31</td><td>Minimum spindle speed</td><td>0.000</td><td>RPM</td><td>Min spindle speed (PWM ~0.4% or lowest).</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$32</td><td>Laser-mode enable</td><td>1</td><td>boolean</td><td>No dwell between G1/G2/G3 when S changes.</td>
    </tr>
    <tr>
      <td>$37</td><td>—</td><td>1</td><td>—</td><td>Reserved / firmware-specific.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$38</td><td>—</td><td>1</td><td>—</td><td>Reserved / firmware-specific.</td>
    </tr>
    <tr>
      <td>$40</td><td>—</td><td>1</td><td>—</td><td>Reserved / firmware-specific.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$100</td><td>X-axis travel resolution</td><td>80.000</td><td>steps/mm</td><td>Steps per millimeter on X.</td>
    </tr>
    <tr>
      <td>$101</td><td>Y-axis travel resolution</td><td>80.000</td><td>steps/mm</td><td>Steps per millimeter on Y.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$102</td><td>Z-axis travel resolution</td><td>80.000</td><td>steps/mm</td><td>Steps per millimeter on Z.</td>
    </tr>
    <tr>
      <td>$103</td><td>A-axis travel resolution</td><td>100.000</td><td>steps/mm</td><td>Steps per millimeter on A.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$104</td><td>B-axis travel resolution</td><td>100.000</td><td>steps/mm</td><td>Steps per millimeter on B.</td>
    </tr>
    <tr>
      <td>$105</td><td>C-axis travel resolution</td><td>100.000</td><td>steps/mm</td><td>Steps per millimeter on C.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$110</td><td>X-axis maximum rate</td><td>6000.000</td><td>mm/min</td><td>Maximum rapid (G0) on X.</td>
    </tr>
    <tr>
      <td>$111</td><td>Y-axis maximum rate</td><td>6000.000</td><td>mm/min</td><td>Maximum rapid (G0) on Y.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$112</td><td>Z-axis maximum rate</td><td>6000.000</td><td>mm/min</td><td>Maximum rapid (G0) on Z.</td>
    </tr>
    <tr>
      <td>$113</td><td>A-axis maximum rate</td><td>1000.000</td><td>mm/min</td><td>Maximum rapid (G0) on A.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$114</td><td>B-axis maximum rate</td><td>1000.000</td><td>mm/min</td><td>Maximum rapid (G0) on B.</td>
    </tr>
    <tr>
      <td>$115</td><td>C-axis maximum rate</td><td>1000.000</td><td>mm/min</td><td>Maximum rapid (G0) on C.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$120</td><td>X-axis acceleration</td><td>500.000</td><td>mm/sec^2</td><td>Planner acceleration for X.</td>
    </tr>
    <tr>
      <td>$121</td><td>Y-axis acceleration</td><td>500.000</td><td>mm/sec^2</td><td>Planner acceleration for Y.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$122</td><td>Z-axis acceleration</td><td>500.000</td><td>mm/sec^2</td><td>Planner acceleration for Z.</td>
    </tr>
    <tr>
      <td>$123</td><td>A-axis acceleration</td><td>200.000</td><td>mm/sec^2</td><td>Planner acceleration for A.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$124</td><td>B-axis acceleration</td><td>200.000</td><td>mm/sec^2</td><td>Planner acceleration for B.</td>
    </tr>
    <tr>
      <td>$125</td><td>C-axis acceleration</td><td>200.000</td><td>mm/sec^2</td><td>Planner acceleration for C.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$130</td><td>X-axis maximum travel</td><td>210.000</td><td>mm</td><td>Usable X travel (soft-limits &amp; homing).</td>
    </tr>
    <tr>
      <td>$131</td><td>Y-axis maximum travel</td><td>297.000</td><td>mm</td><td>Usable Y travel (soft-limits &amp; homing).</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$132</td><td>Z-axis maximum travel</td><td>80.000</td><td>mm</td><td>Usable Z travel (soft-limits &amp; homing).</td>
    </tr>
    <tr>
      <td>$133</td><td>A-axis maximum travel</td><td>300.000</td><td>mm</td><td>Usable A travel.</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>$134</td><td>B-axis maximum travel</td><td>300.000</td><td>mm</td><td>Usable B travel.</td>
    </tr>
    <tr>
      <td>$135</td><td>C-axis maximum travel</td><td>300.000</td><td>mm</td><td>Usable C travel.</td>
    </tr>
  </tbody>
</table>