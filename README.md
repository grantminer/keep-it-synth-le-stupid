# Keep It Synth-le Stupid
 
## Overview
 
Our goal is to create a simple audio synthesizer by converting digital waveforms into analog outputs using a DAC to create music. Using two buttons, users will be able to use one to cycle through three waveforms and use the other button to reset to an idle state with no waveform.
 
There are four wave patterns controlled by the buttons on the FPGA: idle, square, triangle, and sawtooth; using the reset button to return to immediately idle. For now, we have not tackled the sine wave generation that is also typically associated with synthesizers.
 
![Waveforms](./images/Waveforms.png)
 
In future iterations, we would like to add the option for waveform frequency and amplitude control through more buttons initially and later through a touchscreen controller. We would also like to add a sine wave generator. Eventually, we would like to be able to play multiple notes at once and either have ROM store a song or take MIDI inputs.

## Audio Synthesizer Background

The most basic building block of a synth is the Voltage Controlled Oscillator (VCO) which controls three attributes to modify the output repeating waveform: frequency, amplitude, and waveshape. Frequency determines the speed that a waveform completes one cycle to create pitch, which is measured in Hertz (Hz). Amplitude changes the volume in  decibels (dB) of the sound. Finally, there are four main waveshapes: sine, square, triangle, and sawtooth. As mentioned above, for the minimal viable product we chose to focus on building a VCO that generates square, triangle, and sawtooth waves that have a set frequency and amplitude. 

In addition to VCOs, synths usually have Low Frequency Oscillators (LFOs). LFOs modulate other parts of the synth using the aforementioned waveshapes without changing the tone. 
 
## System
 
Our system is composed of a finite state machine that cycles through four states: idle, square, triangle, and sawtooth. 
 
![State Diagram](./images/state_diagram.jpeg)
 
The system rotates through the states when button one is pressed and resets to idle through the press of button zero as shown above. In each of the three waveform states, we output the generated waveform signal and light up an LED corresponding with the state. 
 
![Schematic](./images/schematic.jpg)
 
The waveform signals are produced by three waveform generators: square, triangle, and sawtooth. 
 
The square wave generator uses a counter to count to the middle of the period. It then triggers another flip-flip that toggles the output, creating a 50% duty cycle square wave. 
 
![Square Wave Generator](./images/SquareWave.jpeg)
 
The triangle wave generator uses a counter adder to count up to the midpoint, incrementally increasing the output, then the adder is switched to a subtractor and it counts back down to create a triangle shape. 
 
![Triangle Wave Generator](./images/TriangleWave.jpeg)
 
The sawtooth wave generator also uses a counter to increase the output and once it reaches the specified period it resets to zero through use of an AND gate.
 
![Sawtooth Wave Generator](./images/SawWave.jpeg)
 
## Implementation
 
Our final implementation used the following parts:
1. [Xilinx Artix 7 Field-Programmable Gate Array (FPGA)](https://digilent.com/reference/programmable-logic/cmod-a7/reference-manual)
2. [Digital to Analog Converter (DAC)](https://www.mouser.com/ProductDetail/Analog-Devices-Linear-Technology/LTC7545AKN?qs=hVkxg5c3xu8UnG6VAbZOjw%3D%3D)
3. [Operational Amplifier (Op Amp)](https://www.mouser.com/ProductDetail/Texas-Instruments/LMC6484AIN?qs=QbsRYf82W3F%2F6hZFGep2SA%3D%3D)
4. [Speaker](https://www.mouser.com/ProductDetail/CUI-Devices/CLS0261MAE-L152?qs=WyjlAZoYn502brWO74DIfQ%3D%3D) 
 
![Breadboarded Final Implementation](./images/implementation.jpg)

Note: Breadboard implementation of the circuit got messed up before the photo was taken, and it went unnoticed until we were out of access from the breadboard. The red wire of the speaker should be connnected to the output of the op-amp in column fourteen (top right-most pin of the op-amp).

![Amplified Circuit Diagram](./images/AmplifiedCircuit.jpeg)

The image above displays the circuit implementation with the DAC and the Op Amp. We used the LTC7545AKN converter and the LMC6484 amplifier. By wiring the output of the DAC through the Op Amp, we were able to amplify the signal, so it was just barely audible through the speaker. Further exploration would center around adjusting the amplification scheme to make the signal even louder.

The signal pins were driven from the FPGA using SystemVerilog code that represents the circuitry depicted in this file. The 7 most significant bits of the signal generator's output are connected to FPGA pins one through seven, with pin 1 being signal\[5] and pin 7 being signal\[11]. Signal\[0:4] is connected to pin 44 through pin 48.
 
 

