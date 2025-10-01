; ------------------------------------------------------------------
; PROJETO 1 - 8051 - Contagem 0..9 / 9..0 (EdSim51, 12 MHz)
; SW0 = P2.0 (nível 0) -> CRESCENTE (F0=1)
; SW1 = P2.1 (nível 0) -> DECRESCENTE (F0=0)
; Display 7-seg P1, COMUM ÂNODO (ativo-baixo)
; Timers modo 1; cada overflow já é o atraso:
;   T0 = 25 ms (TH0:TL0 = 9E58h)
;   T1 = 50 ms (TH1:TL1 = 3CB0h)
; Bit 00h (0x20.0) = flag "delay terminou"
; Nenhuma definição além da tabela.
; ------------------------------------------------------------------

            ORG     0000h
            LJMP    START

; --- Vetores de interrupção ---
            ORG     000Bh               ; Timer0
            LJMP    T0_ISR
            ORG     001Bh               ; Timer1
            LJMP    T1_ISR

; --- Tabela 7-seg (ativo-baixo, comum ânodo) ---
TAB7:       DB  0C0h,0F9h,0A4h,0B0h,099h,092h,082h,0F8h,080h,090h

; -------------------- Código principal ----------------------------
START:
            ; I/O
            SETB    P2.0                ; pull-up SW0
            SETB    P2.1                ; pull-up SW1
            MOV     P1,#0FFh            ; apaga display

            ; Timers modo 1
            MOV     TMOD,#11h           ; T1 modo1, T0 modo1

            ; Preloads fixos: T0=25 ms (9E58h), T1=50 ms (3CB0h)
            MOV     TH0,#09Eh
            MOV     TL0,#058h
            MOV     TH1,#03Ch
            MOV     TL1,#0B0h

            ; Habilita interrupções (EA=1, ET1=1, ET0=1)
            MOV     IE,#08Ah

            CLR     F0                  ; até escolher sentido
            CLR     00h                 ; flag "delay terminou" = 0

; --- Espera primeira tecla ---
ESPERA:
            JNB     P2.0, INIT_UP
            JNB     P2.1, INIT_DN
            SJMP    ESPERA

INIT_UP:
            SETB    F0                  ; 1 = crescente
            MOV     R0,#0
            SJMP    LOOP

INIT_DN:
            CLR     F0                  ; 0 = decrescente
            MOV     R0,#9
            SJMP    LOOP

; -------------------- Laço principal enxuto -----------------------
; 1) atualiza F0 se alguma tecla estiver em 0
; 2) inc/dec com wrap
; 3) mostra e espera atraso (T0=25ms, T1=50ms) via flag 00h setada na ISR
LOOP:
            ; --- atualiza sentido se tecla pressionada ---
            JNB     P2.0, F0_UP        ; SW0 força up
            JNB     P2.1, F0_DN        ; SW1 força down
            SJMP    STEP
F0_UP:      SETB    F0
            SJMP    STEP
F0_DN:      CLR     F0

STEP:
            JB      F0, DO_INC         ; F0=1? crescente

; -------- decrescente ----------
DO_DEC:
            CJNE    R0,#0, DEC_OK
            MOV     R0,#9              ; wrap 0->9
            SJMP    SHOW_DN
DEC_OK:     DEC     R0
            SJMP    SHOW_DN

; -------- crescente ------------
DO_INC:
            INC     R0
            CJNE    R0,#10, SHOW_UP
            MOV     R0,#0              ; wrap 9->0

; -------- mostrar + delay -------
SHOW_UP:
            MOV     A,R0
            ACALL   MOSTRA

            ; atraso 25 ms com T0
            CLR     00h                ; limpa flag
            CLR     TF0                ; limpa TF0
            MOV     TH0,#09Eh          ; garante preload
            MOV     TL0,#058h
            SETB    TR0                ; inicia Timer0
WAIT_T0:    JNB     00h, WAIT_T0       ; espera ISR setar flag
            CLR     00h                ; consome flag
            SJMP    LOOP

SHOW_DN:
            MOV     A,R0
            ACALL   MOSTRA

            ; atraso 50 ms com T1
            CLR     00h
            CLR     TF1
            MOV     TH1,#03Ch
            MOV     TL1,#0B0h
            SETB    TR1                ; inicia Timer1
WAIT_T1:    JNB     00h, WAIT_T1
            CLR     00h
            SJMP    LOOP

; -------------------- Exibição no display -------------------------
MOSTRA:
            MOV     DPTR,#TAB7
            MOVC    A,@A+DPTR
            MOV     P1,A
            RET

; -------------------- ISRs (sem loop, 1 overflow = atraso) --------
; Cada ISR: limpa TFx, desliga TRx e seta bit 00h (flag fim do delay).
T0_ISR:
            CLR     TF0                 ; limpa flag de overflow
            CLR     TR0                 ; para o timer (25 ms concluídos)
            SETB    00h                 ; sinaliza término
            RETI

T1_ISR:
            CLR     TF1
            CLR     TR1                 ; 50 ms concluídos
            SETB    00h
            RETI

            END
