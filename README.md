# Repository for Team 8 IAC RISC-V CPU Coursework

Team Members: Johan Jino, Shermaine Ang, Clemen Kok & Alvi Sohailul Islam 

## Documentation for Project Phase III: Pipelined CPU with Data Cache
Clemen and Shermaine working on Data Cache HDL.
Alvi and Johan testing Data Cache.

Drawing of how we envision the data cache to work with the Pipelined CPU:
![Alt text](data_cache_drawing.jpg)

Shermaine:
1. Added `data_cache.svh` and `cachebranch.svh`.
2. Edited `risc.sv` to include 2 new blocks as well as the multiplexer block.

`data_cache.svh` currently gets values of V, tag and data outputs. @clemenkok to work on how data will be stored and retrieved? 