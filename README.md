# 🚦 Traffic Light Controller with Pedestrian Crossing  
A Verilog FSM-Based Smart Traffic System

## 📌 Overview  
This project implements a **smart traffic light controller** with **pedestrian crossing support** using Verilog.  
The system ensures safe traffic flow by managing **vehicle signals**, **pedestrian signals**, and **button-triggered pedestrian requests**. It uses a **finite state machine (FSM)** along with internal timers to handle signal durations.

---

## 🧠 Features  
- Four FSM states  
  - Vehicle Green  
  - Vehicle Yellow  
  - Pedestrian Green  
  - All Red  
- Pedestrian button request with latch mechanism  
- Configurable timing parameters  
- Failsafe output logic  
- Easy to simulate and test  

---

## 🗂 FSM State Diagram  
 ┌──────────────┐
 │  VEH_GREEN   │
 └──────┬───────┘
        │ ped_req & timer>=GREEN
        ▼
 ┌──────────────┐
 │  VEH_YELLOW  │
 └──────┬───────┘
        │ timer>=YELLOW
        ▼
 ┌──────────────┐
 │  PED_GREEN   │
 └──────┬───────┘
        │ timer>=PED
        ▼
 ┌──────────────┐
 │   ALL_RED    │
 └──────┬───────┘
        │ timer>=ALL_RED
        ▼
 (back to VEH_GREEN)

---

## 🛠 Module Description  

### **Inputs**
| Name     | Type | Description            |
|----------|------|------------------------|
| clk      | wire | System clock           |
| reset    | wire | Asynchronous reset     |
| ped_btn  | wire | Pedestrian button      |

### **Outputs**
| Name       | Width | Description            |
|------------|--------|------------------------|
| veh_light  | 3 bits | Vehicle lights {R,Y,G} |
| ped_light  | 2 bits | Pedestrian lights {R,G}|

---

## ⏱ Timing Parameters  
All timing values are reduced for simulation:

| Parameter       | Value (ticks) | Description               |
|-----------------|----------------|---------------------------|
| GREEN_TICKS     | 10             | Vehicle green duration    |
| YELLOW_TICKS    | 5              | Yellow duration           |
| PED_TICKS       | 10             | Pedestrian green duration |
| ALL_RED_TICKS   | 5              | All red safety duration   |

---

## ✔ Key Functional Blocks  

### **1. Pedestrian Request Latch**  
- Stores button request only during vehicle-green  
- Resets automatically after pedestrian green time completes  

### **2. State + Timer Register**  
- Updates FSM state  
- Increments timer on each clock cycle  

### **3. Next-State Logic**  
- Controls transitions between FSM states  
- Based on timer values and pedestrian request  

### **4. Output Logic**  
- Controls vehicle and pedestrian LEDs  
- Depends only on current FSM state  

---

## 📂 File Structure  

---

## ▶ Simulation  
You can simulate using Vivado, ModelSim, Icarus Verilog, or EDA Playground.

Example command (Icarus Verilog):

```sh
iverilog -o traffic traffic_light_ped.v tb_traffic_light.v
vvp traffic

---

If you want, I can also generate:  
✅ Testbench code  
✅ Block diagram image  
✅ GitHub project description  
Just tell me!
