# Repository for Team 8 IAC RISC-V CPU Coursework

Team Members: Johan Jino, Shermaine Ang, Clemen Kok & Alvi Sohailul Islam 

## Documentation for Project Phase III: Pipelined CPU with Data Cache

Shermaine and Clemen worked on the implementation for Data Cache. While the approach and some HDL was written, the code is untested. This was because the team had to reshift its focus to implementing byte addressing and getting the test program to work properly. If the team had more time, we could have tested and worked on completing the Data Cache implementation. You can find the team's proposed approach below, as well as some HDL that was written to implement it.

## Approach to implementing a DIRECT MAPPED CACHE for RISC-V CPU
---

We access SET in the data cache from ALUResultM. If V is 1 and Tag matches the original bitstream, then there is a HIT (`cachebranch.sv`). This will cause the RD output to be from Data in the Data Cache (`datacache.sv`).

If there is a MISS, then we trigger the following logic.

We will need to extend further into the memory hierarchy and look up the Tag in the Data Memory (main memory, `datamem.sv`). Tag is identified in data memory, and the associated Data is output as RD. At the same time, we also register it in cache so that we can access it in future cycles. This means that we need to send it into the Data Cache as Write Data (with Write Enable), with the appropriate tag and set. The Valid Bit has to be made 1 as well. This enables future SET and TAGs to find the data, allowing for recently accessed data to be pulled from the cache.

Drawing of how we envision the data cache to work with the Pipelined CPU:
![Alt text](data_cache_drawing.jpg)

