# Pipelined RISC-V Design
Upgraded the verified Single-Cycle RISC-V into a Pipelined version.

![Alt text](pipelined_cpu_blocks.jpg)

Distributed the work for this pipelined CPU as per the highlighted blocks above:


|Block|Member Responsible|
|---|---|
|Fetch|Shermaine Ang|
|Data|Johan Jino|
|Execute|Clemen Kok|
|Memory & Write|Sohailul Islam Alvi|

Committed all our works into the `pipeline` branch.

Each member made the necessary changes to the `risc_v.sv` top-level module file, to put togther their blocks into the design.

To implement the `JALR` instruction, the following modifications had to be done to the above RTL schematic:
![Screenshot 2022-12-16 150936](https://user-images.githubusercontent.com/94545356/208063585-896f01b4-4d27-43bc-a9cd-776ec25a93d9.png)

