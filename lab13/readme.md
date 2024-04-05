# Ex. 8.3: External Interrupts - MIDI Player
Instructions:
In this activity, you must implement a library that will be used by a MIDI audio player. The peripherals used in this activity are the MIDI Synthesizer and General Purpose Timer (GPT), and their description can be found in the ALE Peripheral MMIO Manual.
Your library will have three main functionalities:

1. Implement a _start function, that initializes the program's stack (see Notes and Tips for more information on how to do that), sets interrupts, and calls the main function (using the jal instruction), available in the provided application.
    * Note that the jal instruction will be used, as it won't be necessary to change execution mode. In future exercises, this may be necessary (and mret will be used instead of jal).
2. Program and handle external interrupts of a timer device (GPT).
    * The GPT interrupt handler must simply increment a global time counter  (_system_time), that needs to be initialized as zero and must store the system time in milliseconds. (System time is the time that has elapsed since the system has been booted).
    * We suggest programming GPT to generate interrupts every 100 ms, which is the value that must be incremented in _system_time.
3. Provide a function “play_note” to access the MIDI Synthesizer peripheral through MMIO.
    * The function prototype is:
	          void play_note(int ch, int inst, int note, int vel, int dur);
    * The parameters are:
        * ch: channel;
        * inst: instrument ID;
        * note: musical note;
        * vel: note velocity;
        * dur: note duration.
### Notes and Tips:
* To allocate the stacks, you can declare two arrays in your program. When initializing the stack pointer (SP), remember that RISC-V stacks are full-descending.
* You must implement all the functions in a single file lib.s, in RISC-V assembly language.
* We provide our application in the file midi-player.c, that uses your library and mustn't be changed. This file must be uploaded with the .s library file.
* All functions must follow the ABI.
* All functions must be thread-safe. Right now, you don't need to understand this concept. Just ensure that your code doesn't use global variables (the only exceptions are the variables _system_time, the program and ISR stacks). Use only local variables, allocated on the stack or on registers. 
* Simulator configuration: 
* To receive external interrupts, set the “Bus Controller Frequency Scaling” on the "Hardware" tab to 1/27.
* Also on the "Hardware" tab, add the GPT, and after that, the Sound Synthesizer (MIDI), in this order. 
* Before beginning to test the MIDI Synthesizer, check the volume of your browser and computer.
* You must access the peripherals through MMIO, just like Exercises 8.1 and 8.2.
* Each device's base_addr can be seen on the table “Memory Map” in the "Hardware" tab.
* You can test your code using this simulator setup, but there isn't an assistant for this exercise.
