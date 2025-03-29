section .bss
    num_input resb 10 

section .data
    prompt db "Enter a number: ", 0
    message_even db "Result is even", 0xA, 0
    message_odd db "Result is odd", 0xA, 0
    exit_msg db "Exiting program...", 0xA, 0
    error_msg db "Invalid input. ", 0xA, 0
    exit_str db "exit", 0

section .text
    global _start

_start:
main_loop:
    mov rax, 4                 
    mov rdi, 1                 
    lea rsi, [prompt]          
    mov rdx, 16                
    syscall

    mov rax, 3                
    mov rdi, 0                
    lea rsi, [num_input]       
    mov rdx, 10                
    syscall

    lea rdi, [num_input]       
    lea rsi, [exit_str]        
    call strcmp            
    test rax, rax           
    jz exit_program            

    mov rsi, num_input     
    xor rax, rax             
    xor rcx, rcx            

convert:
    movzx rbx, byte [rsi+rcx]  
    cmp rbx, 0xA              
    je check_even        
    cmp rbx, '0'             
    jl invalid_input
    cmp rbx, '9'             
    jg invalid_input
    sub rbx, '0'              
    imul rax, rax, 10          
    add rax, rbx              
    inc rcx                   
    jmp convert              

invalid_input:
    mov rax, 4               
    mov rdi, 1                 
    lea rsi, [error_msg]       
    mov rdx, 15               
    syscall
    jmp main_loop           

check_even:
    test rax, 1               
    jz even                 

odd:
    mov rax, 4            
    mov rdi, 1                
    lea rsi, [message_odd]   
    mov rdx, 15                
    syscall
    jmp main_loop             

even:
    mov rax, 4             
    mov rdi, 1                
    lea rsi, [message_even]     
    mov rdx, 16                
    syscall
    jmp main_loop              

exit_program:
    mov rax, 4             
    mov rdi, 1                 
    lea rsi, [exit_msg]     
    mov rdx, 18            
    syscall

    mov rax, 1             
    xor rdi, rdi               
    syscall

strcmp:
    push rsi
    push rdi
strcmp_loop:
    mov al, [rdi]              
    mov bl, [rsi]              
    cmp al, bl              
    jne not_equal             
    test al, al               
    je equal                   
    inc rdi                    
    inc rsi                    
    jmp strcmp_loop            
equal:
    xor rax, rax              
    pop rdi
    pop rsi
    ret
not_equal:
    mov rax, 1                 
    pop rdi
    pop rsi
    ret
