.syntax unified
.arm
.text
start:
    SUB R0, R15, R15
    ADD R1, R0, #5
    ADD R2, R1, #3
    STR R2, [R0, #100]
    LDR R3, [R0, #100]
    SUB R4, R3, R1
    STR R4, [R0, #104]
end_loop:
    B end_loop
