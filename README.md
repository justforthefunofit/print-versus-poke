# PRINT vs POKE on the Commodore 64

This repository explores an alternative way of writing to memory on the Commodore 64.  
Instead of the traditional `POKE` command, which is often slow when used in BASIC, this method takes advantage of the `PRINT` command combined with specially crafted strings.  

By relocating the screen memory, we can “print” raw byte values directly into memory. This makes it possible to fill entire memory blocks much faster than with the usual `DATA` statements and `FOR...NEXT` loops.  

---

## Why use PRINT?

- **Speed:** Printing characters into memory is much faster than poking values one by one.  
- **Simplicity:** No need to loop through long lists of `DATA` values.  
- **Flexibility:** Works well for defining sprites, small machine-language routines, or other memory manipulations.  

---

## Example

- **Left side:** Sprite memory rewritten using `PRINT`.  
- **Right side:** Same animation done with `POKE`.  
- **Result:** The difference in speed is clear—`PRINT` wins.  

---

## Limitations

- Screen memory is limited in size.  
- Some PETSCII values are reserved (cursor, color changes, etc.).  
- Requires relocating screen memory via the VIC-II chip.  

## Solving the PETSCII limitation
A small loop printing 256 different characters on the screen. Each character represents a byte value that can be put at a memory location. 
10 for i = 0 to 255
20 poke 1024 + i, i
30 next

Challenge how to do the same using print? Let’s try
10 for I = o to 255
20 print chr$(i);
30 next

This will not give you the same result, problem here is that the PETSCII characters are used as ‘control’ characters like moving the cursor, changing color, or clearing the screen.  So how can we overcome this? The trick here is to use the reverse command. 

- Inverse off value: chr$(146)
- Inverse on value: chr$(18)

So, let’s see what will happen with the values if we use inverse

<img width="579" height="399" alt="image" src="https://github.com/user-attachments/assets/a7e7f26c-0630-45b4-9858-e6a2e272a617" />

# Explanation:
- line 10 - clear the screen using chr$(147)
- line 20 - use chr$(18) to set inverse on and print the "@ABCD " values in inverse
- line 30 - use chr$(146) to set inverse of and print the "@ABCD " normaly
- line 40 - use peek and loop to read the memory values of the screen first 12 positions and print these

# Using Chr$ to get the correct memory byte values
For this we can use the following translation table that I created. 
<table>
  <thead>
    <tr style="background-color:#007acc; color:white">
      <th>Inverse Mode</th>
      <th>Print Value Range</th>
      <th>Memory Byte Value</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color:#f9f9f9">
      <td>OFF (146)</td><td align="center">64–95</td><td align="center">0–31</td>
    </tr>
    <tr>
      <td>OFF (146)</td><td align="center">32–63</td><td align="center">32–63</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>OFF (146)</td><td align="center">96–127</td><td align="center">64–95</td>
    </tr>
    <tr>
      <td>OFF (146)</td><td align="center">160–191</td><td align="center">96–127</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>ON (18)</td><td align="center">64–95</td><td align="center">128–159</td>
    </tr>
    <tr>
      <td>ON (18)</td><td align="center">32–63</td><td align="center">160–191</td>
    </tr>
    <tr style="background-color:#f9f9f9">
      <td>ON (18)</td><td align="center">96–127</td><td align="center">192–223</td>
    </tr>
    <tr>
      <td>ON (18)</td><td align="center">160–191</td><td align="center">224–255</td>
    </tr>
  </tbody>
</table>

# Example usage of the correct chr$ values
Let see how we can show that in a Basic program. Create the following program to show both putting the values on the screen using print and secondly using the poke command a few lines below so we can compare.

```basic
100 printchr$(147);
105 n$=chr$(146):  rem inverse off
110 i$=chr$(18) : rem inv
120 for i=64 to 95:a$=a$+chr$(i):next
130 for i=32 to 63:a$=a$+chr$(i):next
140 for i=96 to127:a$=a$+chr$(i):next
150 for i=160to191:a$=a$+chr$(i):next
200 print n$+a$:print i$+a$
300 for i=0 to 127:poke 1384+i,i:next
310 for i=128to255:poke 1416+i,i:next
320 goto 320
```


## Status

This is an **experiment and learning project**.  
It’s not meant as a replacement for `POKE` in all situations, but rather as a demonstration of how far you can stretch the humble `PRINT` command.
