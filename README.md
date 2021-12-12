# Keep It Synth-le Stupid

Our goal is to create a synthesizer by converting digital waveforms into analog outputs using a DAC to create music. Using four buttons, users will be able to cycle through waveforms and frequencies (and reset both options). There are ____ frequencies that users will be able to cycle through using the detached button. 

[frequencies](./images/waveforms)

There are four wave patterns controlled by the buttons on the FPGA: idle, square, triangle, and sawtooth; using the reset button to return to immediately idle. For now, we have not tackled the sine wave generation that is also typically associated with synthesizers. 

[waveforms](./images/waveforms)

Eventually, we would like to be able to play multiple notes at once and either have ROM store a song or take MIDI inputs. We may also tackle a sine wave generator.