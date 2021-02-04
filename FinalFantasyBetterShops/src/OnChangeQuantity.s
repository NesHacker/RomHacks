; OnChangeQuantity.s
; Routines handling quantity changes on user input from the shop buy menu.

;
; Entry Hook (0E:A774)
;
; The original JMP instruction is only executed when a button on the controller
; has been pressed that doesn't correspond to an action in a shop menu (i.e
; the player pressed a button besides up, down, a, or b).
; Instead of jumping out to continue with the routine we jump into a small
; method that calls out to the `changeQuantity` hack method, which handles the
; rest of the logic and checks (e.g. if we are on the correct menu, can you
; affort the quantity, updating the graphics, etc.).
;
; Original Code:
; 0E:A774: 4C 9D AD  JMP $AD9D
;
jmp $84E3           ; 4C E3 84

;
; onQuantityChange
; Address: 0E:84E3
; Length: 8
;
; Calls out to the change quantity hack method to handle changes if applicable.
;
lda #2              ; A9 02       // `changeQuantity` is hack index 2
jsr callHack0E      ; 20 F5 82
jmp $AD9D           ; 4C 9D AD
