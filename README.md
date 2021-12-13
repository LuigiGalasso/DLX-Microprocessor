# DLX-Microprocessor-Design-Development 
# Project Description 
The Objectives of this project are the VDHL description of a basic pipelined DLX processor
exploiting a set of simple components and a finishing phase consisting in synthesis and physical
implementation that were constrained in order to optimize the performance in terms of timing.
Specification
The specification used for the basic DLX configuration used is:
* Pipeline: The architecture is organized with a five staged pipeline data path and an hardwired
control unit.
* Instruction Set: A set of 27 basic instructions to be implemented.
* Data Path: A VDHL description at RT level of a data path capable of execute all of the
instructions in the instruction set defined.
* Control Unit: A VDHL description at RT level of a control unit capable of organize and
manage the correct behavior.
* Synthesis: A synthesis of both the control unit and the data path with the generation of the
respective performance reports and a final optimization for frequency.
* Physical Design: The place and route of the synthesized design.

The project was carried out describing the processor using the VHDL description language. After the
description and simulation, a refinement from RTL (Register Transfer Level) down to synthesis and
physical design was performed.
