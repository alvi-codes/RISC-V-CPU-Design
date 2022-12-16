# Test Results & Proof of Success - Pipelined
This page displays the test programmes used to verify our design and the resultant outputs seen on the waveform viewer that proves the correctness of our CPU design implementation working as per the needs of this coursework.

In addition, we have also added videos that show the outputs for the F1 Program driving the neopixel bar on VBuddy and the trace values for the Reference Program plotted on the VBuddy's TFT display.

# F1 Program

The program developed and used by the team; with `nop` instructions added as required:
```
main:
	jal a1, iloop
    nop
    nop
    addi a2, zero, 0x0
    beq a2, zero, 0
    nop 
    nop
    
iloop:
	lb a0, 0(zero)
    lb a0, 1(zero)
    lb a0, 2(zero)
    lb a0, 3(zero)
    lb a0, 4(zero)
    lb a0, 5(zero)
    lb a0, 6(zero)
    lb a0, 7(zero)
    nop
    nop
    nop
    lb a0, 8(zero)
    jalr a3, a1, 0
    nop 
    nop
    
 mloop:
 	beq a2, zero, mloop
    nop
    nop
    
```
Resultant waveform view from the `risc_v.vcd` file:
![Alt text](images/Screenshot_20221215_085344.png)
![Alt text](images/Screenshot_20221215_085419.png)
![Alt text](images/Screenshot_20221215_085428.png)

Outputs from `a0` driving the neopixel bar on VBuddy:


https://user-images.githubusercontent.com/94545356/207894205-ea9e3988-8e03-4997-ae90-bb5cdb93f60d.mp4



# Reference Program

Resultant waveform view from the `risc_v.vcd` file:

### Sine ###
![Alt text](images/pipeline_ref_sine.png)
### Triangle ###
![Alt text](images/pipeline_ref_triangle.png)
### Gaussian ###
![Alt text](images/pipeline_ref_gaussian.png)
### Noisy ###
![Alt text](images/pipeline_ref_noisy.png)


### Explanation of waveforms ###
Having entered `_loop3`, `a0` will start taking the values at `mem[base_pdf+a1)`. The next line of instruction increments `a1` by 1, causing `a0` to take the value at the next address. This loop will keep repeating itself until the end of the pdf array. 


# Video Results on Vbuddy


### Gaussian ###
https://user-images.githubusercontent.com/92362159/208200591-e1e2f280-d535-47f6-a633-57afdd15538a.mp4

### Noisy ###

https://user-images.githubusercontent.com/92362159/208200690-38c2e128-2295-4b6e-abab-34ee7391b2a8.mp4

### Triangle ###

https://user-images.githubusercontent.com/92362159/208201031-877015b8-ac89-4b39-925e-a59cd555e7ef.mp4

### Sine ###

https://user-images.githubusercontent.com/92362159/208201069-a903c0e2-bd0a-4c7b-afd6-9ea72199a9f6.mp4

# Conclusion from tests #
The waveform views for all were displayed as expected. When testing on the Vbuddy, the Sine and Triangle did not seem like sine and triangle waves. However, since the Gaussian and Noisy was displayed perfectly, and the waveforms are displayed as it should, we believe the CPU is working correctly.
