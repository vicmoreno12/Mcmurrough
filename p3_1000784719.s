/******************************************************************************
* @FILE arrays (:
*
* @ID Number 1000784719
*
* @Date November 16, 2015
*
* @AUTHOR Victor Moreno
******************************************************************************/
#10
.global main 
.func main

main:
    BL _scanf
    MOV R9, R0      @ n = blah
    BL _scanf     
    MOV R11, R0     @ i = blah
    MOV R1, R9      @ n
    MOV R2, R11     @ i
    @MOV R3, R0
    BL _generate
    MOV R8, R0
    LDR R0, =printf_str
    MOV R1, R8
    BL printf
    
    
    BL main

#32
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall


#43
_prompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #31             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

#52
_printf:
    PUSH {LR}               @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    MOV R1, R3              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf
    POP {PC}                @ return
#60
_generate:
    PUSH {LR}
    
    MOV R7, R0
    MOV R0, #0
    CMP R0, #100
    writeloop:
    CMP R0, #20
    BEQ writedone
    LDR R1 = a_array
    LSL R2, R0, #2
    ADD R2, R1, R2
    ADD R8, R7, R0
    STR R8, [R2]
    ADD R2, R2, #4
    ADD R8, R8, #1
    MOV R11, #10   @look at this
    SUB R8, R11, R8
    STR R8, [R2]
    ADD R0, R0, #2
    B writeloop
    
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


.data

.balign 4
a_array:              .skip     80
b_array:              .skip     80
printf_str:     .asciz    "a/b[%d] = %d / %d\n"
