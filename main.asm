.686
.model flat, stdcall
option casemap:none

include MASM32-SDK\include\windows.inc
include MASM32-SDK\include\kernel32.inc
include MASM32-SDK\include\user32.inc
include MASM32-SDK\include\masm32.inc

includelib MASM32-SDK\lib\kernel32.lib
includelib MASM32-SDK\lib\user32.lib
includelib MASM32-SDK\lib\masm32.lib

.data
align 16
aligned_array dd 1000 dup(0)
misaligned_array db 1
    dd 1000 dup(0)
aligned_msg db "Aligned read: %d ms",13,10,0
misaligned_msg db "Misaligned read: %d ms",13,10,0
buffer db 256 dup(0)

.code
NO_OPTIMIZE MACRO value
    push ebx
    mov ebx, value
    add ebx, 1
    pop ebx
ENDM

start:
    call GetTickCount
    mov esi, eax
    
    mov ecx, 1000000
test_read_aligned:
    push ecx
    mov ecx, 100
    mov ebx, offset aligned_array
    mov edx, 0
read_loop_aligned:
    mov eax, [ebx]
    add edx, eax
    add ebx, 4
    dec ecx
    jnz read_loop_aligned
    NO_OPTIMIZE edx
    pop ecx
    dec ecx
    jnz test_read_aligned
    
    call GetTickCount
    sub eax, esi
    
    push eax
    push offset aligned_msg
    push offset buffer
    call wsprintfA
    add esp, 12
    
    push offset buffer
    call StdOut

    call GetTickCount
    mov esi, eax
    
    mov ecx, 1000000
test_read_misaligned:
    push ecx
    mov ecx, 100
    mov ebx, offset misaligned_array + 1
    mov edx, 0
read_loop_misaligned:
    mov eax, [ebx]
    add edx, eax
    add ebx, 4
    dec ecx
    jnz read_loop_misaligned
    NO_OPTIMIZE edx
    pop ecx
    dec ecx
    jnz test_read_misaligned
    
    call GetTickCount
    sub eax, esi
    
    push eax
    push offset misaligned_msg
    push offset buffer
    call wsprintfA
    add esp, 12
    
    push offset buffer
    call StdOut

    push 0
    call ExitProcess

end start