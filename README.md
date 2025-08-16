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

---

## Status

This is an **experiment and learning project**.  
It’s not meant as a replacement for `POKE` in all situations, but rather as a demonstration of how far you can stretch the humble `PRINT` command.
