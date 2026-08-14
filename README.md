# Adaptive LMS Equalizer

A MATLAB-based simulation of an adaptive FIR equalizer using LMS-based adaptation for channel equalization.

The simulation randomly generates an LTI channel for each run and uses a known training sequence to initialise the equalizer. After the training period, the input is replaced by a randomly generated multi-tone signal while the equalizer continues adapting to the same channel.

The simulation tracks the equalization error, convergence, learned filter coefficients, frequency response, and the combined channel-equalizer response.

## Visualizations

### 1. Mean Square Error

The Mean Square Error is plotted against the iteration number to observe the convergence of the adaptive equalizer.

A logarithmic representation is also included to make the convergence behaviour easier to observe.

### 2. Equalization Error

The error between the delayed input signal and the equalizer output is plotted across the samples.

### 3. Equalizer Coefficients

The evolution of all adaptive FIR filter coefficients is recorded and visualised throughout the simulation.

### 4. Channel and Equalizer Response

The frequency responses of the randomly generated LTI channel and the learned equalizer are plotted together to observe the compensation achieved by the adaptive filter.

### 5. Channel-Equalizer Convolution

The convolution of the channel and learned equalizer is plotted to observe the resulting combined response and residual ISI.

## Features

* Adaptive FIR channel equalization
* LMS-based coefficient adaptation
* Randomly generated LTI channel
* Training sequence
* Post-training signal adaptation
* Random multi-tone test signal
* Normalised coefficient update
* Error-based adaptation threshold
* Configurable equalizer delay
* MSE convergence visualisation
* Equalization error visualisation
* Equalizer coefficient evolution
* Channel and equalizer frequency-response comparison
* Channel-equalizer convolution
* Residual ISI calculation
* Numerical performance summary
behaviour, and channel compensation.
