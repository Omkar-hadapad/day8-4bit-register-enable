# Day 8 — 4-Bit Register with Enable

<p align="center">
  <b>4-Bit Register with Enable, Synchronous/Asynchronous Reset, Functional Verification & Cadence Genus Synthesis using Verilog HDL.</b>
</p>

<p align="center">
  <code>Specification → Architecture → RTL → Testbench → Simulation → Verification → Synthesis → Timing → Power → PPA → Documentation</code>
</p>

---

## 1. Project Information

| Item                     | Details                                            |
| ------------------------ | -------------------------------------------------- |
| Project                  | **Day 8**                                          |
| Design Title             | `4-Bit Register with Enable`                       |
| Top Module               | `register_4bit_top`                                |
| Domain                   | Digital VLSI / RTL Design                          |
| HDL                      | Verilog HDL                                        |
| Design Type              | Sequential Logic Circuit                           |
| Data Width               | 4-bit                                              |
| Inputs                   | `clk`, `reset_async`, `reset_sync`, `en`, `d[3:0]` |
| Outputs                  | `q_async[3:0]`, `q_sync[3:0]`                      |
| Verification             | Directed Functional Verification                   |
| Simulation Tool          | Cadence NC-Sim                                     |
| Synthesis Tool           | Cadence Genus                                      |
| Genus Version            | `21.14-s082_1`                                     |
| Technology Library       | `tsmc18`                                           |
| Operating Condition      | `fast (balanced_tree)`                             |
| Wireload Mode            | `enclosed`                                         |
| Area Mode                | `timing library`                                   |
| Total Cell Count         | **20**                                             |
| Sequential Cell Count    | **8**                                              |
| Combinational Cell Count | **12**                                             |
| Total Cell Area          | **705.197**                                        |
| Total Reported Power     | **93.0184 µW**                                     |
| Reported Setup Slack     | **+7.685 ns**                                      |
| Clock Constraint         | **10 ns / 100 MHz**                                |
| Timing Status            | **MET** for reported setup path                    |
| Simulation Completion    | **63 ns**                                          |
| Functional Verification  | **PASS with sync-reset test correction pending**   |
| Status                   | **PPA Complete / Verification Refinement Pending** |

---

## 2. Project Overview

This project implements a **4-bit register with enable control** using synthesizable Verilog HDL.

The design contains two 4-bit register implementations:

```text
1. Asynchronous-reset register
2. Synchronous-reset register
```

Both registers support:

```text
Enable = 1 → Load input data
Enable = 0 → Hold previous value
```

The project demonstrates the difference between:

```text
Asynchronous Reset
```

and

```text
Synchronous Reset
```

The design was simulated using Cadence NC-Sim and synthesized using Cadence Genus with the `tsmc18` technology library.

---

## 3. Objective

The objectives of this project are:

* Understand sequential RTL design.
* Understand a 4-bit register.
* Implement enable-controlled data loading.
* Implement hold behavior when enable is disabled.
* Understand asynchronous reset.
* Understand synchronous reset.
* Verify reset behavior relative to the clock.
* Develop a directed functional verification testbench.
* Generate SHM waveform data.
* Synthesize the RTL using Cadence Genus.
* Understand sequential standard-cell mapping.
* Analyze hierarchy after synthesis.
* Analyze standard-cell area.
* Analyze power components.
* Analyze timing and setup slack.
* Interpret PPA results.
* Document actual synthesis results.
* Build a professional GitHub Digital VLSI portfolio project.

---

## 4. Register Concept

A register is a group of flip-flops used to store binary data.

For a 4-bit register:

```text
D[3:0]
  │
  ▼
┌───────────────┐
│               │
│  4-Bit        │
│  Register     │
│               │
└───────┬───────┘
        │
        ▼
      Q[3:0]
```

Each bit is stored in one sequential storage element.

Therefore:

```text
4-bit register
      ↓
4 storage elements
```

The Day-8 design contains two such 4-bit register blocks:

```text
                    register_4bit_top
                           │
              ┌────────────┴────────────┐
              │                         │
              ▼                         ▼
      register_4bit_async       register_4bit_sync
              │                         │
          4 storage                 4 storage
          elements                  elements
```

---

## 5. Register Operation

The basic register behavior is:

|    Reset | Enable | Operation         |
| -------: | -----: | ----------------- |
|   Active |      X | Reset register    |
| Inactive |    `1` | Load `D`          |
| Inactive |    `0` | Hold previous `Q` |

For normal operation:

```text
EN = 1
```

causes:

```text
Q ← D
```

at the active clock edge.

When:

```text
EN = 0
```

the register retains its previous value:

```text
Q ← Q
```

---

## 6. Enable Concept

The enable control determines whether new input data is stored.

### Enable = 1

```text
D = 1010

EN = 1

        ↓
     Register
        ↓
Q = 1010
```

### Enable = 0

If:

```text
Q = 1010
D = 0101
EN = 0
```

then:

```text
Q remains 1010
```

The input changes, but the stored value does not.

---

## 7. Asynchronous Reset

An asynchronous reset does not require a clock edge to reset the register.

Conceptually:

```text
RESET_ASYNC
     │
     ▼
┌─────────────┐
│  Register   │
└──────┬──────┘
       │
       ▼
     Q = 0000
```

When asynchronous reset is asserted:

```text
reset_async = 1
```

the register immediately becomes:

```text
Q = 0000
```

even if the clock does not transition.

### Verified Behavior

The simulation demonstrated:

```text
TIME = 37
CLK  = 1
ASYNC_RST = 1

Q_ASYNC = 0000
```

The testbench explicitly reported:

```text
Reset asserted WITHOUT clock edge
```

Therefore, the asynchronous reset behavior passed the tested condition.

---

## 8. Synchronous Reset

A synchronous reset is evaluated on the active clock edge.

Conceptually:

```text
             CLK
              │
              ▼
        ┌───────────┐
RESET ─►│ Flip-Flop │
D ─────►│           │
        └─────┬─────┘
              │
              ▼
              Q
```

When:

```text
reset_sync = 1
```

the register resets when the appropriate clock edge occurs.

Therefore:

```text
Reset asserted
       │
       ▼
Wait for clock edge
       │
       ▼
Q → 0000
```

### Verification Status

The initial Day-8 testbench did **not** hold `reset_sync` high across a rising clock edge.

Therefore, the synchronous-reset test requires correction and rerun before being considered fully verified.

---

## 9. Asynchronous vs Synchronous Reset

| Feature              | Asynchronous Reset         | Synchronous Reset           |
| -------------------- | -------------------------- | --------------------------- |
| Requires clock edge? | No                         | Yes                         |
| Reset timing         | Immediate                  | Clock controlled            |
| Tested in Day 8      | **PASS**                   | **Correction required**     |
| Synthesis hardware   | Reset-capable FF           | Reset-capable/sequential FF |
| Main concept         | Reset independent of clock | Reset sampled with clock    |

### Core Difference

```text
ASYNC RESET

RESET ─────────────► Q
                     immediate


SYNC RESET

RESET ─────► FF ◄──── CLK
               │
               ▼
              Q
          clock edge required
```

---

## 10. Hardware Architecture

The top-level architecture contains two separate 4-bit register blocks.

```text
                         register_4bit_top
                                │
                ┌───────────────┴───────────────┐
                │                               │
                ▼                               ▼
       register_4bit_async             register_4bit_sync
                │                               │
        ┌───────┼───────┐               ┌───────┼───────┐
        ▼       ▼       ▼       ▼       ▼       ▼       ▼       ▼
       DFF0    DFF1    DFF2    DFF3    DFF0    DFF1    DFF2    DFF3
```

Conceptually:

```text
                  ┌────────────────────┐
D[3:0] ──────────►│                    │
EN ──────────────►│ Async Register     │──► Q_ASYNC[3:0]
CLK ─────────────►│                    │
ASYNC_RST ───────►│                    │
                  └────────────────────┘

                  ┌────────────────────┐
D[3:0] ──────────►│                    │
EN ──────────────►│ Sync Register      │──► Q_SYNC[3:0]
CLK ─────────────►│                    │
SYNC_RST ────────►│                    │
                  └────────────────────┘
```

---

## 11. Functional Specification

### Inputs

| Signal        | Width | Description        |
| ------------- | ----: | ------------------ |
| `clk`         |     1 | Clock              |
| `reset_async` |     1 | Asynchronous reset |
| `reset_sync`  |     1 | Synchronous reset  |
| `en`          |     1 | Register enable    |
| `d[3:0]`      |     4 | Input data         |

### Outputs

| Signal         | Width | Description                        |
| -------------- | ----: | ---------------------------------- |
| `q_async[3:0]` |     4 | Asynchronous-reset register output |
| `q_sync[3:0]`  |     4 | Synchronous-reset register output  |

---

## 12. Expected Functional Behavior

### Reset

When asynchronous reset is asserted:

```text
q_async = 0000
```

without waiting for a clock edge.

When synchronous reset is asserted:

```text
q_sync = 0000
```

on the appropriate clock edge.

### Load

When:

```text
en = 1
```

the register loads:

```text
Q ← D
```

### Hold

When:

```text
en = 0
```

the register maintains its previous value.

---

## 13. Testbench Strategy

The Day-8 testbench verifies:

```text
1. Initial/reset behavior
2. Load operation
3. Hold operation
4. Second load operation
5. Asynchronous reset
6. Synchronous reset
```

The testbench also prints signal values during simulation.

Important signals include:

```text
CLK
D
EN
SYNC_RST
ASYNC_RST
Q_SYNC
Q_ASYNC
```

---

## 14. Load Test

The first load test uses:

```text
D = 1010
EN = 1
```

At the rising clock edge:

```text
Q_SYNC  = 1010
Q_ASYNC = 1010
```

### Result

```text
LOAD TEST
D      = 1010
Q_SYNC = 1010
Q_ASYNC= 1010
```

Result:

```text
PASS
```

---

## 15. Hold Test

The testbench changes:

```text
D = 0101
EN = 0
```

while the previous stored value is:

```text
1010
```

The outputs remain:

```text
Q_SYNC  = 1010
Q_ASYNC = 1010
```

### Result

```text
HOLD TEST
D      = 0101
Q_SYNC = 1010
Q_ASYNC= 1010
```

This confirms that disabling the enable prevents the register from loading new data.

Result:

```text
PASS
```

---

## 16. Second Load Test

The testbench applies:

```text
D = 1100
EN = 1
```

The registers load:

```text
Q_SYNC  = 1100
Q_ASYNC = 1100
```

### Result

```text
SECOND LOAD TEST
D      = 1100
Q_SYNC = 1100
Q_ASYNC= 1100
```

Result:

```text
PASS
```

---

## 17. Asynchronous Reset Verification

The testbench asserts asynchronous reset while the clock is not required to transition.

At:

```text
TIME = 37
CLK = 1
ASYNC_RST = 1
```

the result becomes:

```text
Q_ASYNC = 0000
```

The testbench explicitly reports:

```text
Reset asserted WITHOUT clock edge
```

### Result

```text
ASYNC RESET TEST : PASS
```

This is an important distinction between asynchronous and synchronous reset behavior.

---

## 18. Synchronous Reset Verification

The testbench attempted to verify synchronous reset.

However, the supplied simulation sequence asserted `SYNC_RST` and then deasserted it before the next rising clock edge.

Therefore:

```text
SYNC_RST = 1
```

was **not present during a rising edge**.

The reported sequence was:

```text
TIME = 50
CLK  = 0
SYNC_RST = 1

TIME = 53
SYNC_RST = 0

TIME = 55
CLK = 1
SYNC_RST = 0
```

Therefore, the reset condition was not sampled at a rising edge.

### Current Status

```text
Synchronous Reset Verification
        ↓
Test sequence requires correction
        ↓
Rerun required
```

This is intentionally documented as incomplete rather than falsely marking it as passed.

---

## 19. Simulation

The design was simulated using:

```text
Cadence NC-Sim
```

The testbench generated an SHM waveform database:

```text
waves.shm
```

using:

```text
database -open waves -into waves.shm -default
```

Signals probed included:

```text
day8_tb.clk
day8_tb.d
day8_tb.en
day8_tb.q_async
day8_tb.q_sync
day8_tb.reset_async
day8_tb.reset_sync
```

---

## 20. Simulation Result

The supplied simulation completed with:

```text
Simulation complete via $finish(1)
at time 63 NS + 0
```

Therefore:

$$
\boxed{\text{Simulation Completion}=63\ ns}
$$

The simulation terminated normally using:

```text
$finish
```

---

## 21. Synthesis Flow

The design was synthesized using Cadence Genus.

```text
Verilog RTL
     ↓
Read / Elaborate
     ↓
Hierarchy
     ↓
Logic Synthesis
     ↓
Boolean Optimization
     ↓
Technology Mapping
     ↓
Standard-Cell Netlist
     ↓
Area / Timing / Power Analysis
```

### Genus Configuration

| Parameter           | Actual Value           |
| ------------------- | ---------------------- |
| Tool                | Cadence Genus          |
| Version             | `21.14-s082_1`         |
| Top Module          | `register_4bit_top`    |
| Technology Library  | `tsmc18`               |
| Operating Condition | `fast (balanced_tree)` |
| Wireload Mode       | `enclosed`             |
| Area Mode           | `timing library`       |
| Report Date         | Sep 30, 2026           |

---

## 22. Synthesis Hierarchy

The Genus hierarchy report gives:

```text
register_4bit_top
│
├── ASYNC_REG : register_4bit_async
│   ├── DFF0 : dff_async_reset
│   ├── DFF1 : dff_async_reset_6
│   ├── DFF2 : dff_async_reset_5
│   └── DFF3 : dff_async_reset_4
│
└── SYNC_REG : register_4bit_sync
    ├── DFF0 : dff_sync_reset
    ├── DFF1 : dff_sync_reset_9
    ├── DFF2 : dff_sync_reset_8
    └── DFF3 : dff_sync_reset_7
```

### Hierarchy Levels

```text
Level 0 → register_4bit_top

Level 1 → register_4bit_async
           register_4bit_sync

Level 2 → Individual register instances
```

This confirms that Genus recognized the intended two-register-block hierarchy.

---

## 23. Standard-Cell Mapping

The supplied Genus cell report contains:

| Standard Cell | Instances |        Area |
| ------------- | --------: | ----------: |
| `DFFHQX1`     |         4 |     212.890 |
| `INVXL`       |         4 |      26.611 |
| `MXI2X1`      |         4 |      93.139 |
| `NOR2X1`      |         4 |      39.917 |
| `SDFFRHQX1`   |         4 |     332.640 |
| **Total**     |    **20** | **705.197** |

### Cell Structure

```text
4 × DFFHQX1
4 × SDFFRHQX1
4 × MXI2X1
4 × NOR2X1
4 × INVXL
----------------
20 total cells
```

The exact mapping of every standard cell to a particular RTL submodule should not be inferred solely from the aggregate cell report.

---

## 24. Cell-Type Classification

The supplied report gives:

| Type           | Instances |        Area |   Area % |
| -------------- | --------: | ----------: | -------: |
| Sequential     |         8 |     545.530 |    77.4% |
| Inverter       |         4 |      26.611 |     3.8% |
| Logic          |         8 |     133.056 |    18.9% |
| Physical cells |         0 |       0.000 |     0.0% |
| **Total**      |    **20** | **705.197** | **100%** |

### Important Observation

Sequential cells dominate the area:

$$
\boxed{77.4\%}
$$

This is expected for a register-oriented design.

---

## 25. Area Analysis

The supplied hierarchy/area report gives:

| Metric               |      Result |
| -------------------- | ----------: |
| Total Cell Count     |      **20** |
| Total Cell Area      | **705.197** |
| Net Area             |   **0.000** |
| Total Area           | **705.197** |
| Sequential Cells     |       **8** |
| Logic/Inverter Cells |      **12** |

Therefore:

$$
\boxed{\text{Total Area}=705.197}
$$

The value is retained in the Genus library/tool area units reported by the tool.

No unsupported conversion to `µm²` is made.

---

## 26. Area Contribution

The two main sequential blocks contribute:

```text
ASYNC_REG
Cells = 8
Area  = 359.251

SYNC_REG
Cells = 12
Area  = 345.946
```

Total:

$$
359.251+345.946=705.197
$$

Therefore:

$$
\boxed{705.197}
$$

The asynchronous block represents approximately:

$$
\boxed{50.94\%}
$$

of total reported area.

The synchronous block represents approximately:

$$
\boxed{49.06\%}
$$

of total reported area.

These percentages are calculated from the supplied Genus area values.

---

## 27. Power Analysis

The supplied Genus power report gives:

```text
Instance: /register_4bit_top
Power Unit: W
PDB Frame: /stim#0/frame#0
```

### Total Power

$$
P_{total}=9.30184\times10^{-5}W
$$

Therefore:

$$
\boxed{P_{total}=93.0184\ \mu W}
$$

---

## 28. Power Breakdown

| Category  |          Leakage |       Internal |      Switching |          Total | Contribution |
| --------- | ---------------: | -------------: | -------------: | -------------: | -----------: |
| Register  |      0.013825 µW |     80.2897 µW |    0.576299 µW | **80.8798 µW** |   **86.95%** |
| Logic     |      0.004979 µW |     1.48347 µW |     1.24120 µW | **2.72965 µW** |    **2.93%** |
| Clock     |                0 |              0 |     9.40896 µW | **9.40896 µW** |   **10.12%** |
| Other     |                0 |              0 |              0 |              0 |           0% |
| **Total** | **0.0188037 µW** | **81.7731 µW** | **11.2265 µW** | **93.0184 µW** |     **100%** |

---

## 29. Power Interpretation

The largest power category is:

```text
Register = 86.95%
```

The second-largest category is:

```text
Clock = 10.12%
```

The logic contribution is:

```text
Logic = 2.93%
```

The total power components are:

$$
P_{total}
=
P_{leakage}
+
P_{internal}
+
P_{switching}
$$

Using the reported values:

$$
P_{total}
=
1.88037\times10^{-8}
+
8.17731\times10^{-5}
+
1.12265\times10^{-5}
$$

$$
\boxed{P_{total}=9.30184\times10^{-5}W}
$$

or:

$$
\boxed{93.0184\ \mu W}
$$

---

## 30. Power Observation

The report shows:

```text
Register power = 86.95%
Sequential area = 77.4%
```

Therefore, the sequential storage portion is the dominant hardware contributor to both:

```text
Area
Power
```

Conceptually:

```text
Sequential Storage
       │
       ├────────► Area = 77.4%
       │
       └────────► Power = 86.95%
```

This is an observation from the supplied synthesis and power reports.

---

## 31. Timing Analysis

The supplied Genus timing report gives:

```text
Path 1: MET
Setup Check
```

### Timing Information

| Parameter         |                    Result |
| ----------------- | ------------------------: |
| Path Status       |                   **MET** |
| Path Group        |                     `clk` |
| Startpoint        |                    `d[3]` |
| Endpoint          | `ASYNC_REG/DFF3/q_reg/SI` |
| Capture Edge      |                `10000 ps` |
| Setup Time        |                  `315 ps` |
| Clock Uncertainty |                 `1000 ps` |
| Input Delay       |                 `1000 ps` |
| Required Time     |                 `8685 ps` |
| Data Path Delay   |                    `0 ps` |
| Slack             |               **7685 ps** |

Therefore:

$$
\boxed{\text{Setup Slack}=7685\ ps}
$$

or:

$$
\boxed{\text{Setup Slack}=7.685\ ns}
$$

---

## 32. Timing Calculation

The report gives:

$$
T_{capture}=10000\ ps
$$

$$
T_{setup}=315\ ps
$$

$$
T_{uncertainty}=1000\ ps
$$

Therefore:

$$
T_{required}
=
10000-315-1000
$$

$$
\boxed{T_{required}=8685\ ps}
$$

The input delay is:

$$
T_{input}=1000\ ps
$$

Therefore:

$$
Slack
=
8685-1000
$$

$$
\boxed{Slack=7685\ ps}
$$

or:

$$
\boxed{Slack=7.685\ ns}
$$

---

## 33. Timing Status

The reported timing path is:

```text
MET
```

Therefore:

```text
Setup timing constraint → PASS
```

The design has positive slack:

```text
+7.685 ns
```

which means the reported setup check meets its specified timing requirement.

---

## 34. Clock Constraint

The timing report uses:

```text
Capture Clock Edge = 10000 ps
```

Therefore the clock period is:

$$
T_{clk}=10\ ns
$$

The corresponding constrained clock frequency is:

$$
f=\frac{1}{10ns}
$$

$$
\boxed{f=100MHz}
$$

However, the supplied timing path has:

```text
Data Path = 0 ps
```

and terminates at a scan-input-related pin:

```text
ASYNC_REG/DFF3/q_reg/SI
```

Therefore, this report should **not** be used by itself to claim the true maximum operating frequency of the register design.

The accurate statement is:

> The design is constrained with a 10 ns clock period (100 MHz), and the reported setup path has +7.685 ns slack.

---

## 35. Important Timing Observation

The reported path is:

```text
d[3]
 ↓
ASYNC_REG/DFF3/q_reg/SI
```

with:

```text
Data Path = 0 ps
```

Therefore, the 0 ps value should **not** be interpreted as the physical propagation delay of the complete register.

It is the data-path delay reported by Genus for this particular constrained path.

The timing result is therefore documented exactly as reported rather than extrapolated into an unsupported Fmax claim.

---

## 36. PPA Summary

PPA represents:

```text
Power
Performance
Area
```

### Actual Day-8 Results

| PPA Metric           |       Actual Result |
| -------------------- | ------------------: |
| **Area**             |         **705.197** |
| **Total Power**      |      **93.0184 µW** |
| **Setup Slack**      |       **+7.685 ns** |
| Clock Constraint     | **10 ns / 100 MHz** |
| Total Cells          |              **20** |
| Sequential Cells     |               **8** |
| Logic/Inverter Cells |              **12** |
| Timing Status        |             **MET** |

### PPA Representation

```text
┌─────────────────────────────────────────┐
│       DAY 8 — PPA RESULTS               │
├─────────────────────────────────────────┤
│ Area        : 705.197                   │
│ Power       : 93.0184 µW                │
│ Setup Slack : +7.685 ns                 │
│ Clock       : 10 ns / 100 MHz           │
│ Cells       : 20                        │
│ Sequential  : 8                         │
│ Timing      : MET                       │
└─────────────────────────────────────────┘
```

---

## 37. Optimization Considerations

The current synthesis result is treated as the **baseline implementation**.

The most important observations are:

### Area

Sequential cells consume:

```text
77.4% of total cell area
```

### Power

Registers consume:

```text
86.95% of total reported power
```

### Timing

The reported setup path has:

```text
+7.685 ns slack
```

Therefore, the current design is not timing-limited according to the supplied path.

Potential future optimization directions include:

* Reduce unnecessary sequential hardware.
* Evaluate enable implementation.
* Evaluate reset architecture.
* Examine clock-related power.
* Analyze register-cell selection.
* Compare area/power trade-offs of different register implementations.
* Re-run timing after every structural change.

No numerical optimization improvement is claimed because no optimized implementation has yet been synthesized.

---

## 38. Verification Results

### Load Test

```text
D      = 1010
Q_SYNC = 1010
Q_ASYNC= 1010
```

```text
PASS
```

### Hold Test

```text
D      = 0101
Q_SYNC = 1010
Q_ASYNC= 1010
```

```text
PASS
```

### Second Load Test

```text
D      = 1100
Q_SYNC = 1100
Q_ASYNC= 1100
```

```text
PASS
```

### Asynchronous Reset

```text
Reset asserted WITHOUT clock edge
Q_ASYNC = 0000
```

```text
PASS
```

### Synchronous Reset

The initial test did not keep `SYNC_RST` asserted through a rising clock edge.

```text
STATUS = CORRECTION REQUIRED
```

---

## 39. Verification Status

| Verification Item               | Status                      |
| ------------------------------- | --------------------------- |
| RTL simulation                  | **PASS**                    |
| Load operation                  | **PASS**                    |
| Hold operation                  | **PASS**                    |
| Second load                     | **PASS**                    |
| Asynchronous reset              | **PASS**                    |
| Synchronous reset               | **Correction required**     |
| SHM waveform generation         | **Generated**               |
| Gate-level verification         | **Not separately reported** |
| Functional coverage             | **Not performed**           |
| Constrained-random verification | **Not performed**           |
| Formal verification             | **Not performed**           |
| UVM                             | **Not performed**           |

---

## 40. Simulation Evidence

The supplied NC-Sim output includes:

```text
TIME=5
CLK=1
SYNC_RST=0
ASYNC_RST=0
EN=1
D=1010
Q_SYNC=1010
Q_ASYNC=1010
```

Then:

```text
LOAD TEST
D      = 1010
Q_SYNC = 1010
Q_ASYNC= 1010
```

Hold behavior:

```text
HOLD TEST
D      = 0101
Q_SYNC = 1010
Q_ASYNC= 1010
```

Second load:

```text
SECOND LOAD TEST
D      = 1100
Q_SYNC = 1100
Q_ASYNC= 1100
```

Asynchronous reset:

```text
ASYNC RESET TEST

Reset asserted WITHOUT clock edge

Q_ASYNC = 0000
```

Simulation completion:

```text
Simulation complete via $finish(1)
at time 63 NS + 0
```

---

## 41. Common Design Mistakes

### 1. Confusing Synchronous and Asynchronous Reset

Incorrect assumption:

```text
Both resets work immediately.
```

Correct:

```text
Async reset → independent of clock edge

Sync reset → requires active clock edge
```

### 2. Changing D While Enable Is 0

Changing `D` does not change the stored value when:

```text
EN = 0
```

### 3. Testing Sync Reset Without a Clock Edge

For synchronous reset verification:

```text
SYNC_RST = 1
        ↓
Rising CLK edge
        ↓
Q = reset value
```

The reset must actually be high at the active edge.

### 4. Assuming RTL Hierarchy Equals Standard-Cell Hierarchy

The RTL contains register modules, while synthesis maps them into library-specific cells.

### 5. Treating Area as Physical µm² Without Evidence

The report provides:

```text
705.197
```

in the Genus library/tool area units.

No unsupported conversion is made.

### 6. Treating 0 ps Data Path as Real Register Delay

The reported 0 ps is the path delay for the particular timing path reported by Genus.

### 7. Claiming Maximum Frequency From This Path

The report establishes:

```text
10 ns clock constraint
+7.685 ns slack
```

but does not establish the true maximum operating frequency because the reported data path is 0 ps and terminates at a scan-input-related pin.

---

## 42. Project Evidence

Recommended repository evidence:

```text
images/
├── verification_console.png
├── register_waveform.png
├── hierarchy_report.png
├── cell_area_report.png
├── power_report.png
└── timing_report.png
```

Only actual screenshots generated from the project should be added.

Recommended report files:

```text
reports/
├── hierarchy_report.txt
├── area_report.txt
├── cell_area_report.txt
├── power_report.txt
└── timing_report.txt
```

---

## 43. Repository Structure

```text
day8-4bit-register/
│
├── README.md
│
├── rtl/
│   ├── dff_async_reset.v
│   ├── dff_sync_reset.v
│   ├── register_4bit_async.v
│   ├── register_4bit_sync.v
│   └── register_4bit_top.v
│
├── tb/
│   └── day8_tb.v
│
├── simulation/
│   ├── console_output.txt
│   └── waves.shm/
│
├── synthesis/
│   ├── genus.tcl
│   └── netlist/
│
├── reports/
│   ├── hierarchy_report.txt
│   ├── area_report.txt
│   ├── cell_area_report.txt
│   ├── power_report.txt
│   └── timing_report.txt
│
├── images/
│   ├── verification_console.png
│   ├── register_waveform.png
│   ├── hierarchy_report.png
│   ├── cell_area_report.png
│   ├── power_report.png
│   └── timing_report.png
│
└── docs/
    └── project_report.pdf
```

---

## 44. Industry Relevance

Registers with enable and reset are fundamental RTL structures used throughout digital systems.

Applications include:

* CPU datapaths
* Pipeline registers
* Control registers
* Configuration registers
* State machines
* Counters
* Shift registers
* Register files
* Communication interfaces
* ASIC datapaths
* FPGA designs
* SoC control logic

### Skills Demonstrated

```text
Sequential Logic
        ↓
Flip-Flops
        ↓
Enable Control
        ↓
Synchronous Reset
        ↓
Asynchronous Reset
        ↓
Verilog RTL
        ↓
Directed Verification
        ↓
NC-Sim
        ↓
Cadence Genus
        ↓
Standard-Cell Mapping
        ↓
Area Analysis
        ↓
Power Analysis
        ↓
Timing Analysis
        ↓
PPA Analysis
        ↓
GitHub Documentation
```

---

## 45. GATE / Interview Relevance

Important concepts demonstrated by this project include:

* Flip-flops
* Registers
* Sequential circuits
* Clock edges
* Enable control
* Synchronous reset
* Asynchronous reset
* Setup timing
* Clock uncertainty
* Input delay
* Data arrival time
* Required time
* Slack
* Standard-cell mapping
* Sequential cell area
* Dynamic/internal power
* Clock power

### Core Difference

```text
ASYNC RESET

RESET ─────────► Register
                    │
                    ▼
                  Q=0


SYNC RESET

RESET ────────┐
              ▼
             Register ◄── CLK
                │
                ▼
               Q=0
```

---

## 46. Interview Questions

### Basic

**Q1. What is a register?**

A register is a group of flip-flops used to store multiple bits of binary information.

**Q2. Why does a 4-bit register require four storage elements?**

Because each flip-flop stores one bit.

**Q3. What does an enable signal do?**

It controls whether new input data is loaded into the register.

---

### Enable

**Q4. What happens when `EN = 1`?**

The register loads the input data at the active clock edge.

**Q5. What happens when `EN = 0`?**

The register retains its previous value.

---

### Reset

**Q6. What is an asynchronous reset?**

A reset that can change the register output without waiting for a clock edge.

**Q7. What is a synchronous reset?**

A reset that takes effect on the active clock edge.

**Q8. What is the key difference between them?**

```text
Async reset → clock independent

Sync reset → clock dependent
```

---

### Verification

**Q9. Why did the synchronous-reset test require correction?**

Because `SYNC_RST` was deasserted before the next rising clock edge, so the reset was never sampled at an active edge.

**Q10. Why is this a testbench problem rather than necessarily an RTL problem?**

Because the test stimulus did not apply the synchronous reset condition at the required clock edge.

---

### Synthesis

**Q11. How many total standard-cell instances were reported?**

```text
20
```

**Q12. How many sequential cells were reported?**

```text
8
```

**Q13. What was the total reported area?**

```text
705.197
```

---

### Timing

**Q14. What is the reported setup slack?**

```text
+7685 ps
= +7.685 ns
```

**Q15. What is the constrained clock period?**

```text
10 ns
```

**Q16. What is the corresponding clock frequency?**

```text
100 MHz
```

**Q17. Can this report alone establish the true maximum frequency?**

No. The reported path has 0 ps data-path delay and terminates at a scan-input-related pin, so it is not sufficient to establish a meaningful internal register-to-register Fmax.

---

### Power / PPA

**Q18. What is the total reported power?**

```text
93.0184 µW
```

**Q19. Which category consumes the most power?**

```text
Register = 86.95%
```

**Q20. What percentage of area is sequential?**

```text
77.4%
```

---

## 47. Tiny Memory

```text
4-Bit Register
       │
       ├── D[3:0]
       ├── CLK
       ├── EN
       ├── RESET
       │
       └── Q[3:0]
```

### Enable

```text
EN = 1 → LOAD
EN = 0 → HOLD
```

### Reset

```text
ASYNC RESET → no clock edge required

SYNC RESET  → active clock edge required
```

### Day-8 Actual Results

```text
Total Cells   : 20
Sequential    : 8
Area          : 705.197
Power         : 93.0184 µW
Slack         : +7.685 ns
Clock         : 10 ns / 100 MHz
Timing        : MET
Simulation    : 63 ns
Async Reset   : PASS
Sync Reset    : Correction required
```

---

## 48. Learning Outcome

```text
Register Concept
        ↓
4-Bit Register
        ↓
Enable Control
        ↓
Load / Hold
        ↓
Asynchronous Reset
        ↓
Synchronous Reset
        ↓
Verilog RTL
        ↓
Testbench
        ↓
Simulation
        ↓
Reset Verification
        ↓
Cadence Genus
        ↓
Hierarchy Analysis
        ↓
Standard-Cell Mapping
        ↓
Area Analysis
        ↓
Power Analysis
        ↓
Timing Analysis
        ↓
PPA
        ↓
GitHub Documentation
        ↓
Interview Preparation
```

### Core Engineering Question

> **What hardware does this RTL create?**

### Answer

The Day-8 RTL creates two 4-bit register structures: one with asynchronous reset and one with synchronous reset. Genus mapped the synthesized design to **20 standard-cell instances**, including **8 sequential cells**, **4 inverters**, and **8 logic cells**, with a total reported cell area of **705.197**.

---

## 49. Project Status

```text
Specification             ✓ COMPLETE
Architecture              ✓ COMPLETE
RTL                       ✓ COMPLETE
Testbench                 ✓ COMPLETE
Load Verification         ✓ PASS
Hold Verification         ✓ PASS
Second Load               ✓ PASS
Async Reset Verification  ✓ PASS
Sync Reset Verification   ⚠ CORRECTION REQUIRED
Simulation                ✓ COMPLETE
Waveform Database         ✓ GENERATED
Synthesis                 ✓ COMPLETE
Hierarchy                 ✓ COMPLETE
Cell Mapping              ✓ COMPLETE
Area                      ✓ COMPLETE
Power                     ✓ COMPLETE
Timing                    ✓ COMPLETE
PPA                       ✓ COMPLETE
Optimization              ○ BASELINE
Documentation             ✓ COMPLETE
```

---

## 50. Final Day-8 Results

```text
┌────────────────────────────────────────────┐
│       DAY 8 — 4-BIT REGISTER               │
├────────────────────────────────────────────┤
│ Top Module       : register_4bit_top       │
│ Technology       : tsmc18                   │
│ Total Cells      : 20                      │
│ Sequential Cells : 8                       │
│ Area             : 705.197                 │
│ Power            : 93.0184 µW              │
│ Setup Slack      : +7.685 ns                │
│ Clock Constraint : 10 ns / 100 MHz         │
│ Timing Status    : MET                      │
│ Simulation       : 63 ns                   │
│ Async Reset      : PASS                     │
│ Sync Reset       : Correction Required      │
│ Project Status   : PPA Complete             │
└────────────────────────────────────────────┘
```

### Evidence-Based Conclusion

The Day-8 4-bit register design was synthesized successfully using Cadence Genus. The reported implementation contains **20 standard-cell instances**, including **8 sequential cells**, with a total cell area of **705.197**. The supplied power-analysis frame reports **93.0184 µW** total power. The reported setup timing path meets its 10 ns constraint with **+7.685 ns slack**.

Functional simulation successfully demonstrated load, hold, second-load, and asynchronous-reset behavior. The synchronous-reset test requires a corrected stimulus sequence in which `SYNC_RST` remains asserted through a rising clock edge before Day 8 can be considered fully verification-complete.

---

## 51. Next Project — Day 9

# 4-Bit Shift Register

The next project extends the register concepts into sequential data movement.

```text
Serial Input
     │
     ▼
┌──────┐   ┌──────┐   ┌──────┐   ┌──────┐
│ FF3  │ → │ FF2  │ → │ FF1  │ → │ FF0  │
└──────┘   └──────┘   └──────┘   └──────┘
                                      │
                                      ▼
                               Serial Output
```
## Author

**Omkar Kalmesh Hadapad**

B.E. Electronics & Communication Engineering
SDM Institute of Technology, Ujire, Karnataka

### Focus Areas

```text
Digital VLSI
RTL Design
Verilog / SystemVerilog
ASIC Design
Design Verification
Cadence Genus
Cadence Innovus
Digital Logic
PPA Analysis
```

### Day 8 Project

**4-Bit Register with Enable — RTL → Simulation → Verification → Genus Synthesis → Timing → Power → PPA → Documentation**

**Next: Day 9 — 4-Bit Shift Register**
