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
    #MOV R2, R9      @ n
    MOV R7, R0
    MOV R0, #0
    BL _generate
    MOV R8, R0
    LDR R0, =printf_str
    MOV R1, R8
    BL printf
    
    
    BL _exit

#27
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall


#38
_prompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #31             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

#47
_printf:
    PUSH {LR}               @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    MOV R1, R3              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf
    POP {PC}                @ return
#54
_generate:
    PUSH {LR}
    

    CMP R0, #20
    writeloop:
    CMP R0, #20
    POPEQ {PC} 
    LDR R1, =a_array
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

#80
_printMyArray:
    readloop:
    CMP R0, #20             @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration

    
    
    
    
    
    
    


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
format_str:     .asciz    "%d"
read_char:      .ascii    "  "
prompt_str:      .ascii   "Enter the @ character: "
equal_str:      .asciz    "CORRECT \n"
nequal_str:     .asciz    "INCORRECT: %c \n"
exit_str:       .ascii    "Terminating program. \n"
