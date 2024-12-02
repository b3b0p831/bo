; run calc.exe and normal exit
; author @cocomelonc
; nasm -f elf32 -o example1.o example1.asm
; ld -m elf_i386 -o example1 example1.o
; 32-bit linux (work in windows as shellcode)

section .data

section .bss

section .text
  global _start   ; must be declared for linker

_start:
  xor  ecx, ecx         ; zero out ecx
  push ecx              ; string terminator 0x00 for "calc.exe" string
  push 0x657865       ; exe. : 6578652e
  push 0x2e646d63       ; cmd : 2e646d63

  mov  eax, esp         ; save pointer "cmd.exe" in ebx

  ; UINT WinExec([in] LPCSTR lpCmdLine, [in] UINT   uCmdShow);
  inc  ecx              ; uCmdShow = 1
  push ecx              ; uCmdShow *ptr to stack in 2nd position - LIFO
  push eax              ; lpcmdLine *ptr to stack in 1st position
  mov  ebx, 0x7C862B5D  ; call WinExec() function addr in kernel32.dll
  call ebx

  ; void ExitProcess([in] UINT uExitCode);
  xor  eax, eax         ; zero out eax
  push eax              ; push NULL
  mov  eax, 0x7C81D20A  ; call ExitProcess function addr in kernel32.dll
  jmp  eax              ; execute the ExitProcess function