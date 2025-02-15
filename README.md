# FPGA-Based Image Processing System

## Project Overview
This project implements an image processing system on an FPGA using Verilog. The system processes image data using convolution techniques, buffering, and control logic to manipulate pixel data efficiently. The implementation includes various modules that work together to handle image data flow, apply transformations, and verify correctness through simulation.

## Project Structure
The project is structured as follows:


---

## Modules Description

### **1. Convolution Module (`conv.v`)**
This module implements a convolution operation on an image using a kernel filter. The convolution is performed using a sliding window over the pixel data.

#### **Key Features:**
- Accepts pixel data from the image control module.
- Applies a 3x3 convolution kernel.
- Outputs the processed pixel data.

---

### **2. Image Control Module (`imagecontrol.v`)**
This module manages the pixel flow, ensuring that the data is correctly formatted and synchronized for processing.

#### **Key Features:**
- Receives raw pixel data.
- Coordinates image processing tasks.
- Sends data to the convolution module.

---

### **3. Line Buffer Module (`line_buffer.v`)**
The line buffer stores and processes image lines, providing data for convolution while maintaining a pipeline structure.

#### **Key Features:**
- Buffers multiple lines of the image.
- Provides a continuous pixel stream to the convolution module.
- Ensures proper alignment for filtering.

---

### **4. Top Module (`top.v`)**
This is the main module that integrates all components and handles input/output communication.

#### **Key Features:**
- Connects convolution, buffering, and image control modules.
- Manages data synchronization.
- Outputs processed image data.

---

### **5. Test Bench (`tb.v`)**
The test bench simulates the entire system to verify its functionality.

#### **Key Features:**
- Provides input pixel data for testing.
- Checks correctness of the convolution operation.
- Outputs simulation results.
