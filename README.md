# super-heterodyne-receiver
Program that simulates a super-heterodyne receiver.
# Introduction
In this program we have simulate a super heterodyne receiver where we sent more than one signal at the same time on different carrier and demodulate them at receiver using super heterodyne because we sent them on a high frequency

<p align="center">
  <img src="https://user-images.githubusercontent.com/68920161/155366974-064fecb0-f96c-4ce7-8a96-e6e45d36a16a.png" alt="AM modulator and super-heterodyne receiver">
</p>

We read the signal that we want to send, the signal was stereo so we add the two columns to make 
the receiver monophonic. We make Upsampling to avoid aliasing since Fs<Fn We made FDM by 
multiplying with cos to be able to send many signals with no interference then add the two signal

An example of the two signals in the channel is as follow

<p align="center">  
  <img src="https://user-images.githubusercontent.com/68920161/155367386-1df69e98-93ae-4126-bac3-369cfb1ca360.png" alt="Example of transmitted signal">
</p>

An example of a signal at RF is as follow as we used Band pass filter to take only one.

<p align="center">  
  <img src="https://user-images.githubusercontent.com/68920161/155368700-62cf9b7b-7271-4f4c-9cc0-b7df9cf963cb.png" alt="Example of a signal at RF">
</p>

After we have multiplied with Wc+WIF and move it WIF

<p align="center">  
  <img src="https://user-images.githubusercontent.com/68920161/155369188-ec2bf758-5459-461e-b650-be2c697614de.png" alt="Example of a signal at IF">
</p>

After sending the signal to WIF, this part is aimed to make sharper bandpass filter that we couldn't 
implement in RF to pass the only desired signal to baseband and remove any signal that came with it 
from RF and the signal at 2wn+wif. the sharper bandpass filter designed by increasing the order of the 
filter

After using BPF at IF to remove any other signal or noise that came from modulation

<p align="center">  
  <img src="https://user-images.githubusercontent.com/68920161/155369882-ce17cd92-2d14-4233-9227-ee7a7d84a84e.png" alt="Example of a signal at IF">
</p>

Then we mutliplied by WIF to move it to baseband to use LPF to get only the desired signal (remove the signal that is in 2WIF).

<p align="center"> 
  <img src="https://user-images.githubusercontent.com/68920161/155370353-aa471d72-c3f1-4c78-86e9-b31c63af559f.png" alt="Example of a signal at baseband">
</p>

<hr>

We also simlate it without RF stage to observe the difference
<p align="center"> 
  <img src="https://user-images.githubusercontent.com/68920161/155373841-ecd63b23-c54a-414e-aa7c-ee41a589794d.png" alt="Example of a signal at WIF">
</p>

<p align="center"> 
  <img src="https://user-images.githubusercontent.com/68920161/155374027-c006e443-0e6c-48ea-aa0b-2a20149fac7f.png" alt="Example of a signal at IF">
</p>

<p align="center"> 
  <img src="https://user-images.githubusercontent.com/68920161/155374658-63d1e39a-c507-4136-97c1-e8b54fa889ee.png" alt="Example of a signal at baseband">
</p>

<p align="center"> 
  <img src="https://user-images.githubusercontent.com/68920161/155374341-1fb07a80-23dc-4cb1-bca7-69e8164451a3.png" alt="Example of a signal at baseband">
</p>

At RF the sound was pure but the amplitude was decreases slightly, while for that without RF the 
sound was not pure and other signals are super imposed on it and the amplitude may be also 
decreased 


