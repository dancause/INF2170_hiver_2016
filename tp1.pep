;************************************rÈinitialise les variables**************************  
debut:   LDA     0,i
         ldx     0,i 
         sta     nbNote,d
         sta     total,d
         sta     nombre,d
         sta     nbcarac,d 
         sta     carac,d 
         sta     detector,d
         sta     detecABC,d
         sta     moyenne,d   
         stro    separa,d 
;************************************lecture du caractere********************************         
lire:    CHARI   carac,d    
         LDBYTEA carac,d    

         CPA     ' ',i
         BREQ    addition
         CPA     10,i        
         BREQ    enter       

;************************************multiplication***************************************  

         LDX     nombre,d    ;valide que nombre soit a zÈro
         BREQ    zero     
         ASLX                ; * 2   
         ASLX                ; * 4     
         ADDX    nombre,d    ; * 5    
         ASLX                ; * 10
         STX     nombre,d
         
         LDx     nbNote,d  
         SUBx    1,i         
         STx     nbNote,d    

;************************************validation du caractËre******************************* 

zero:    CPA     '0',i       
         BRLT    lettre    
         CPA     '9',i       
         BRGT    lettre    
         SUBA    '0',i       ;ASCII a DÈcimal
         ADDA    nombre,d   
         STA     nombre,d

         LDA     nbNote,d  
         ADDA    1,i         
         STA     nbNote,d 
    
         LDA     nbcarac,d  ;un caractËre numÈrique lu de plus
         ADDA    1,i         
         STA     nbcarac,d 
         lda     nombre,d
         cpa     100,i
         brgt    over     
         BR      lire        

;**********************************un enter est entrÈ***********************  

enter:   ldx     detector,d 
         cpx     1,i
         breq    msg100

         ldx     detecABC,d 
         cpx     1,i
         breq    msg100
         
         ldx     nbcarac,d
         cpx     20,d
         brlt    msg100
   
         lda     nbNote,d 
         cpa     0,i
         breq    note0

         lda     total,d
         adda    nombre,d
         sta     total,d
         br      division

;*************************calcul de la moyenne***************
         LDX     nbNote,d
         cpx     0,i
         breq    note0
division:ASLA               ; * 2   
         ASLA               ; * 4     
         ADDA    total,d    ; * 5    
         ASLA               ; * 10
         STA     total,d
         LDX     0,i         ; quotient
soustrai:ADDX    1,i         
         SUBA    nbNote,d  
         BRGE    soustrai    
         SUBX    1,i         
         ADDA    nbNote,d  
         STX     moyenne,d  
         STA     reste,d 
         LDX     0,i         ; quotient
         lda     moyenne,d
soustra: ADDX    1,i         
         SUBA    dix,d  
         BRGE    soustra    
         SUBX    1,i         
         ADDA    dix,d  
         STX     moyenne,d  
         STA     reste,d
         
;***************************affichage des notes************         
AFFICH:  LDA     nbNote,d 
         CPA     1,i
         BREQ    onenote 
         STRO    NOTE1,d
         DECO    nbNote,d
         STRO    NOTE2,d
         BR       moyen
           
onenote: stro    NOTE,d

moyen:   DECO    moyenne,d

         LDX     reste,d
         cpx     0,i
         breq    r100
         charo   ',',i
         deco    reste,d
r100:    stro    NOTE3,d 
         br      nouveau
note0:   STRO    NOTE4,d 
         br      nouveau        

       
over:    cpa     999,i
         breq    fin1
         cpa     100,i
         brgt    audes100

audes100:ldx     1,i
         stx     detector,d
         br      lire

msg100:  stro    over100,d
         br      nouveau

        
lettre:  ldx     1,i
         stx     detecABC,d
         br      lire


addition:lda     nombre,d
         ldx     total,d
         addx    nombre,d
         stx     total,d
         ldx     0,i
         stx     nombre,d
         LDA     nbcarac,d  ;un caractËre numÈrique lu de plus 
         ADDA    1,i         
         STA     nbcarac,d 
         LDBYTEA carac,d 
         cpa     ' ',i
         breq    saut
         LDA     nbNote,d  
         ADDA    1,i         
         STA     nbNote,d 
saut:    br      lire



nouveau: br      debut


fin1:    STRO    normale,d   ;fin normale du programme
         STOP


depasser:.ascii  "\nnombre invalide\n\x00"
vide:    .ascii  "\nAucune note n'a ÈtÈ entrÈe\n\x00"                        
msgerreu:.ASCII  "\nUn caractËre non numÈrique a ÈtÈ entrÈ.\n\x00"
         .BYTE   0           
over100: .ASCII  "\nEntrée invalide\x00"
         .BYTE   0                             
normale: .ASCII  "\n\nFin normale du programme.\n"
         .BYTE   0
separa:  .ascii  "\n-----------------------------------------\n\x00"

NOTE:    .ASCII "La moyenne de 1 note est de \x00"
NOTE1:   .ASCII "La moyenne des \X00"
NOTE2:   .ASCII " notes est de \X00"
NOTE3:   .ASCII "/100\X00"
NOTE4:   .ASCII "La moyenne de 0 note est de 0/100\X00"


dix:     .word 10
moyenne: .block 2           ; #2d 
reste:   .block 2           ; #2d
temp:    .block 2           ; #2d  
nbNote:  .block 2           ; #2d
detecABC:.block 2           ; #2d
detector:.block 2           ; #2d
total:   .block 2           ; #2d        
nombre:  .block 2           ; #2d
nbcarac: .block 2           ; #2d
carac:   .block 1           ; #1h
         .END   