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
<p align="center">
<img max-width="50%" height="auto" alt="image"  src="https://github.com/user-attachments/assets/a7e7f26c-0630-45b4-9858-e6a2e272a617" />
</p>
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
# result on execution

<p align="center">
<img max-width="50%" height="auto"  alt="image" src="https://github.com/user-attachments/assets/ab3f211e-7c88-4b0a-b04c-f4b58ad67fee" />
</p>

This now opens opportunities to use the print command instead of using the poke command. Using print, we can combine values in a string and then print them. This has a few advantages.
-	One we can create the string which save computing memory and execution time (no need to read of use data statements)
-	Printing a string is much faster than poking each value individually into a memory location
It has also some disadvantages of course, like readability and defining the string with the appropriate values could be a challenge. Luckily, we can do that nowadays using some additional tooling. I myself use "CBM prg  - studio" in combination with VICE.

# Lets use it to create a sprite
Knowing know which values to use to get the right memory byte values in the string that we want to print we can use this to create an sprite. 

```Basic
100 s$="{64}{64}{64}{64}{64}{64}{76}{64}{18}{96}{146}{76}{64}{18}{96}{146}{67}{67}{64}{67}{67}{64}{79}{18}{191}{96}{146}{79}{18}{191}{96}{146}{57}{18}{188}{176}{146}{57}{18}{188}{176}{146}"
110 s$=s$+"{18}{191}{191}{188}{191}{191}{188}{111}{191}{188}{108}{146}{64}{18}{108}{108}{146}{64}{18}{108}{146}{67}{18}{111}{146}{64}{67}{18}{111}{146}{64}{64}{64}{64}{64}{64}{64}{64}{64}{64}{64}{64}{64}"
120 ::
130 poke 53269,  1 :rem sprite 1 visible
140 poke 53287,  3 :rem color = 3
150 poke  2040, 16 :rem pointer to 16x64 = 1024
160 poke 53248, 44 :rem x pos sprite
170 poke 53249,120 :rem y pos sprite
180 poke 53277,  1 :rem sprite width
190 poke 53271,  1 :rem sprite height
```

After we run this program initially nothing seems to happen. But lets print the string that is created in this program
```Basic
?chr$(147)+s$
```
<p align="center">
<img max-width="50%" height="auto" alt="image" src="https://github.com/user-attachments/assets/e828ead2-3d74-44f4-b57f-48aa8c0f511a" />
</p>

It then will instantly show the following sprite 
<p align="center">
<img max-width="50%" height="auto" alt="image" src="https://github.com/user-attachments/assets/87b34f33-c749-4c6e-a93e-d629762060f0" />
</p>

# Solving the memory starting adress
We can make this a bit more useful if we also make use of the Vic’s capability to move the screen memory. So we move the memory, print the sprites into that area and then move the screen memory pointers back to the original location. 
We need to set two values. One telling the VIC chip the screen edit location and second telling where the screen memory starts/
This information can be found in the “programmers reference guide” on page 102 and 103.
<img width="548" height="813" alt="image" src="https://github.com/user-attachments/assets/37dfe2c0-bd9d-4312-a287-b317e1e041f1" />

In basic this then can be done using the following statements:
```Basic
600 poke 648,48 : rem set edit location
610 poke 53272,(peek(53272)and15)or192: rem set new screen memory location
```
And the following will switch back to the standard screen location
```Basic
700 poke 648,4: rem restore edit to original
710 poke 53272,(peek(53272)and15)or16:rem restore to original
```
# Create a full working example
Ok now we have learned how to use the chr$ values to get the correct byte values, how to create a string and how to place that in a memory location other than the standard screen memory to program a sprite. The following program will do this all. 

```Basic
100 s$="{64}{64}{64}{64}{64}{64}{76}{64}{18}{96}{146}{76}{64}{18}{96}{146}{67}{67}{64}{67}{67}{64}{79}{18}{191}{96}{146}{79}{18}{191}{96}{146}{57}{18}{188}{176}{146}{57}{18}{188}{176}{146}"
110 s$=s$+"{18}{191}{191}{188}{191}{191}{188}{111}{191}{188}{108}{146}{64}{18}{108}{108}{146}{64}{18}{108}{146}{67}{18}{111}{146}{64}{67}{18}{111}{146}{64}{64}{64}{64}{64}{64}{64}{64}{64}{64}{64}{64}{64}"
120 ::
130 poke 53269,  1 :rem sprite 1 visible
140 poke 53287,  3 :rem color = 3
150 poke  2040,192 :rem pointer to 192x64 = 12288
160 poke 53248, 44 :rem x pos sprite
170 poke 53249,120 :rem y pos sprite
180 poke 53277,  1 :rem sprite width
190 poke 53271,  1 :rem sprite height
210 ::
600 poke 648,48 : rem set edit location
610 poke 53272,(peek(53272)and15)or192: rem new screen location
620 ?chr$(147);s$: rem program the sprite memory
700 poke 648,4: rem  edit to original
710 poke 53272,(peek(53272)and15)or16:rem restore screen location
```
# Result
<p align="center">
<img max-width="50%" height="auto" alt="image" src="https://github.com/user-attachments/assets/19170b0e-45e1-48b3-98e3-181461d2bc00" />
</p>

# Creating the print string
Figuring out which characters to use in a print string can be quite a chore. So I tweaked that Excel sheet I showed in an earlier video to generate the strings for you. You can then drop them straight into a BASIC editor, like CBM Prg Studio, and you’re ready to go.
<p align="center">
<img max-width="50%" height="auto" alt="image" src="https://github.com/user-attachments/assets/247adba3-7747-468d-9f80-bb76b69206c6" />
</p>

> **Note** You can find this Excel also here on github. It used a visual basic macro so you might have to adjust the security settings to enable that. The visual basic macro can also be fount as a text document there

## Status

This is an **experiment and learning project**.  
It’s not meant as a replacement for `POKE` in all situations, but rather as a demonstration of how far you can stretch the humble `PRINT` command.
