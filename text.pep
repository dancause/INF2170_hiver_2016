         LDX     0,i ; X = 0;
         LDA     0,i ; A = 0;
 Encore: LDBYTEA texte,x ; while(true)
         stbytea texte2,x 
         cpa     '\x00',i 
         BREQ    Arret ; if(texte[X] == 0) break;
         ADDX    1,i ; X++;}
         BR      Encore ; }
       Arret:   stro    texte2,d
  STOP
 nombre: .block 2            ; #2
 texte: .ASCII "    janvier\x00"
 texte2:.block 20            ; #2

.END