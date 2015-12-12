.global main
.func main

main:
    MOV R10, #2             @ To multiply R8 with 2 to get a negative value            
    BL _prompt
    BL _scanf
    MOV R7, R0              @add scanf function to recieve R7 input from user
    MOV R0, #0            @initialze index variable
#10
_generate:
    CMP R0, #20            @check to see if we are done iterating
    BEQ writedone            @exit loop if done
    LDR R1, =a_array            @get address of a
    LSL R2, R0, #2            @multiply index*4 to get array offset
    ADD R2, R1, R2            @R2 now has the element address
    ADD R8, R7, R0            @n+i stored into R8
    STR R8, [R2]            @store value into array a
    ADD R2, R2, #4            @add 4 to the addresent to increment by 1
    ADD R8, R8, #1            @add 1 to (n+1)
    MUL R9, R8, R10            @multiply R8 value by R10 = 2, and store in R9
    SUB R8, R8, R9            @subtract R9 from R8 to get negative value
    STR R8, [R2]            @store negative value in array
    ADD R0, R0, #2            @increment array by 2
    B   _generate            @ branch to next loop iteration
#16
writedone:
    MOV R0, #0            @ initialze index variable
    MOV R5, #300
    MOV R10, #0
#21
_sort_ascending:
    CMP R0, #20            @ condition to stop
    MOVEQ R0, #0            @ reset R0 back to zero after finding the first lowest integer
    LDR R1, =a_array            @ load a_array
    LSL R2, R0, #2            @ set the address
    ADD R2, R1, R2            @ add a_array address to R2
    LDR R1, [R2]            @ load contents of a_array into R1
    LDR R3, =b_array            @ load b_array
    LSL R4, R10, #2            @ set the address
    ADD R4, R3, R4            @ add b_array address to R4
    CMP R5, R1            @ compare R5 to R1
    MOVGT R5, R1            @ if R5 is greater than R1, move the contents of R1 into R5
    ADDGT R0, R0, #1            @ increment counter
    BGT _sort_ascending            @ re-enter the sort function
    CMP R5, R1            @ compare R5 to R1
    ADDLT R0, R0, #1            @ increment the counter if R5 is less than R1
    BLT _sort_ascending            @ re-enter the sort function
    CMP R10, #20            @ compare R10 with 20
    BEQ writedone_1            @ if R10 is equal to 20 exit the sort function
    ADD R10, R10, #1            @ increment R10 by one
    STR R5, [R4]            @ store the contents of R5 into b_array
    B _sort_ascending            @ re-enter sort function
#44
writedone_1:
    MOV R0, #0

readloop:
    CMP R0, #20            @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =a_array            @ get address of a
    LSL R2, R0, #2            @ multiply index*4 to get array offset
    ADD R2, R1, R2            @ R2 now has the element address
    LDR R4, =b_array            @ get address of b
    LSL R5, R0, #2            @ multiply index*4 to get array offset
    ADD R5, R4, R5            @ R5 now has the element address
    LDR R4, [R5]            @ read the b_array at address
    LDR R1, [R2]            @ read the a_array at address
    PUSH {R0}            @ backup register before printf
    PUSH {R1}            @ backup register before printf
    PUSH {R2}            @ backup register before printf
    MOV R2, R1            @ move array value to R2 for printf
    MOV R1, R0            @ move array index to R1 for printf
    BL  _printf            @ branch to print procedure with return
    POP {R2}            @ restore register
    POP {R1}            @ restore register
    POP {R0}            @ restore register
    ADD R0, R0, #1            @ increment index
    B   readloop            @ branch to next loop iteration
#70
readdone:
    B _exit            @ exit if done

_exit:
    MOV R7, #4            @ write syscall, 4
    MOV R0, #1            @ output stream to monitor, 1
    MOV R2, #21            @ print string length
    LDR R1, =exit_str            @ string at label exit_str:
    SWI 0            @ execute syscall
    MOV R7, #1            @ terminate syscall, 1
    SWI 0            @ execute syscall

_printf:
    PUSH {LR}          @ store the return address
    LDR R0, =printf_str            @ R0 contains formatted string address
    MOV R3, R4
    BL printf            @ call printf
    POP {PC}            @ restore the stack pointer and return

_prompt:
    MOV R7, #4            @ write syscall, 4
    MOV R0, #1            @ output stream to monitor, 1
    MOV R2, #31            @ print string length
    LDR R1, =prompt_str            @ string at label prompt_str:
    SWI 0            @ execute syscall
    MOV PC, LR            @ return

_scanf:
    MOV R4, LR            @ store LR since scanf call overwrites
    SUB SP, SP, #4            @ make room on stack
    LDR R0, =format_str            @ R0 contains address of format string
    MOV R1, SP            @ move SP to R1 to store entry on stack
    BL scanf            @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4            @ restore the stack pointer
    MOV PC, R4            @ return

.data

.balign 4
a_array:        .skip       80
b_array:        .skip       80
printf_str:     .asciz      "a|b[%d] = %d : %d\n"
format_str:     .asciz      "%d"
prompt_str:     .asciz      "Type a value and press enter: "
exit_str:       .ascii      "Terminating program.\n"
debug_str:      .asciz      "R%-2d   0x%08X  %011d \n"