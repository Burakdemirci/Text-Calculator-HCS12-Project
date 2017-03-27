# Text-Calculator-HCS12-Project
Text Calculator Project written in absolute assembly

-------------------------------------------------------------------------------------

Write a program that reads the string starting from $1200 and computes the
results accordingly.
For instance if starting from $1200 the memory has the string “28.33 + 17.28
=” then the program will compute the result and write it to address $1500.
Strings always end with ‘=’. Put the string at $1200 using ORG and FCC
directives.
Store the integer and decimal parts in different memory locations and
perform arithmetic operation accordingly.
The arithmetic operation can be either ‘+’ or ‘-‘.
The integer part can’t be larger than 255, whereas the decimal part can’t
have more than two digits, i.e. 0.XY. Warn if overflow occurs by writing $FF
to PORTB. Otherwise PORTB will be written $55.
Numbers will always be positive and in decimal format.

-------------------------------------------------------------------------------------
