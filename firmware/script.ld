MEMORY
{
  FLASH  (rwx)  : ORIGIN = 0x00000000, LENGTH = 1M 
  RAM    (rwx)  : ORIGIN = 0x20000000, LENGTH = 4K
}

SECTIONS
{
  .isr_vectors :
  {
    /* First entry: initial Stack Pointer value */
    LONG(ORIGIN(RAM) + LENGTH(RAM));
    KEEP(*(.isr_vectors.reset));
    KEEP(*(.isr_vectors));
  } > FLASH = 0x00

  .text :
  {
    _text = .;
    *(.text* .text.*)
  } > FLASH

  .rodata :
  {

  } > FLASH

  /* Make .bss aligned to 32 bits words, with a size multiple of 4 bytes to
   * allow fast initialization by word access instead of byte access. */
  .bss ALIGN(4):
  {
    _bss = .;
    *(.bss* .bss.*)
    _ebss = ALIGN(4);
  } > RAM

  /DISCARD/ :
  { 
    *(.ARM.exidx*);
  } 
}
