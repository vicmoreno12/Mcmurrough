/******************************************************************************
* @FILE Recurssion (:
*
* @ID Number 1000784719
*
* @Date November 16, 2015
*
* @AUTHOR Victor Moreno
******************************************************************************/

.global main
.func main

main:
    BL _scanf
    MOV R8, R0
    BL _scanf
    MOV R9, R0
    MOV R1, R8
    MOV R2, R9s
    MOV R3, R0
    BL _print
    BL main

#20
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall


#31
_prompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #31             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

#40
_printf:
    PUSH {LR}              @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    MOV R1, R3              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf
    POP {PC}              @ return

_count:
    PUSH {LR}
    CMP R1, #0               @ if (n==0)
    BLEQ R0, #1              @     return 1
    CMP R1, #0               @ else if(n<0)
    MOVLE R0, #0             @     return 0
    CMP R2, #0               @ else if (m==0)
    BLEQ R0, #0              @     return 0
    
    
    
    
    
    
    
    
    
    
    
    
    POP {PC}


_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}


_add:
    ADD R0, R2, R3
    MOV PC, LR

_sub:
    SUB R0, R2, R3
    MOV PC, LR

_mul:
    MUL R0, R2, R3
    MOV PC, LR

_max:
    CMP R2, R3
    MOVGT R0,R2
    MOVLT R0,R3
    MOV PC, LR



.data
printf_str:     .asciz    "Result: %d\n"
format_str:     .asciz    "%d"
read_char:      .ascii    "  "
prompt_str:      .ascii    "Enter the @ character: "
equal_str:      .asciz    "CORRECT \n"
nequal_str:     .asciz    "INCORRECT: %c \n"
exit_str:       .ascii    "Terminating program. \n"
