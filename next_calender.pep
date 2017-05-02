; *********************************************************
; Programme: calend.TXT          version PEP813 sous MacOSx
;
; Programme qui lit des nombres à l'écran pour afficher un calendirer
; On doit entrer une suite de 6 chiffres pour le traitement
; Les quatres premiers chiffres sont l'année et les deux suivants le mois
; année doit être 1900 à 2050 inclusivement.
; Le programme va afficher une erreur si les parametres ne sont pas respecté
; Pour mettre fin au programme il faut entrer 9999 sans espace.
;
;       auteur:   janin dancause
;       courriel: dancause.janin@courrier.uqam.ca
;       date:     Hiver 2016
;       cours:    INF2170 
;       TP2-TP3
; *********************************************************



retour:  ldx     0,i
         lda     0,i
         sta     annee,d
         sta     numeroM,d 
         STA     resultat,d  
         STA     resulta1,d
         STA     resulta2,d 
         STA     resulta3,d
         sta     douzeM,d
         sta     limite,d
         sta     indice,d
         sta     indice2,d
         sta     indice21,d
         STA     reste,d 
         STA     isbiss,d
         STA     temp,d
         sta     nbJour,d
         sta     days,d 
         stro    ligne,d 
         charo   '\n',i
         stro    question,d 
         charo   1,i




boucle:  CHARI   chaine,x    ; lecture d'un caractère de chaine
         LDA     0,i         ; efface le registre A
         LDBYTEA chaine,x    ; charge le caractère lu
         ADDX    1,i         ; position suivante
         CPA     10,i        ; dernier caractère ?
         BREQ    ans         ; oui, c'est terminé 
         CPA     '0',i       ; entre 0 et 9 ?
         BRLT    erreur      ; non, ce n'est pas un chiffre 
         CPA     '9',i       
         BRGT    erreur    
         LDA     temp,d  ; compteur + 1 
         ADDA    1,i         
         STA     temp,d
         cpa     6,i
         brgt    nbChifr 
         BR      boucle

;************************************construction de l'année************************ 
ans:     lda     0,i
         ldx     0,i
year:    LDA     annee,d    ;valide que nombre soit a zªro
         BREQ    zero
         CALL    multi1    
         STA     annee,d 
         lda     0,i
        
zero:    LDBYTEA chaine,x   
         SUBA    '0',i       ;ASCII a Décimal
         ADDA    annee,d   
         STA     annee,d
         addx    1,i
         cpx     4,i
         breq    month
         BR      year 





;************************* construction du douzeM******************
month:   cpa     9999,i 
         breq    terminer         
         cpa     2050,i 
         brgt    errANs 
         cpa     1901,i 
         brlt    errANs
         lda     temp,d 
         cpa     6,i
         brlt    manque  
         lda     0,i
douze:   LDA     douzeM,d    ;valide que nombre soit a zéro 
         BREQ    rien 
         call    multi1    
         STA     douzeM,d 
         lda     0,i
        
rien:    LDBYTEA chaine,x   
         SUBA    '0',i       ;ASCII a Décimal
         ADDA    douzeM,d   
         STA     douzeM,d
         addx    1,i
         cpx     6,i
         breq    test12 
         BR      douze 

test12:  cpa     1,i
         brlt    errDouzM 
         cpa     12,i    
         brgt    errDouzM  

         call    calendM
         ldx     indice,d 
         stx     indice2,d            

         lda     nbJour,d
         sta     limite,d       


         call    multipl3


         adda    indice,d 
         sta     limite,d
;++++++++++++++++++++++++++++++++++++++++++++++++++

         call    bisexx

calcul:  lda     annee,d
         suba    1900,i
         sta     resultat,d
         suba    1,i
         ldx     0,i		
soustrai:ADDX    1,i         
         SUBA    4,i  
         BRGE    soustrai    
         SUBX    1,i         
         ADDA    4,i
         sta     reste,d
         stx     resulta1,d

         ldx     0,i
         lda     douzeM,d
         suba    1,i
         sta     temp,d
multi:   adda    temp,d
         addx    1,i
         cpx     57,i
         brlt    multi
         suba    temp,d
         adda    50,i
         ldx     0,i
div100:  addx    1,i
         suba    100,i
         brge    div100
         adda    100,i
         subx    1,i
         stx     resulta2,d

         lda     douzeM,d
         suba    1,i
         call    multi1
         sta     temp,d
         asla                ;x20 
         adda    temp,d      ;x30
         sta     resulta3,d
         lda     0,i
         adda    resultat,d
         adda    resulta1,d
         adda    resulta2,d
         adda    resulta3,d
         adda    1,i
         ldx     douzeM,d
         cpx     2,i
         brle    startday 
         ldx     isbiss,d 
         cpx     1,i
         breq    sub1
         br      sub2
sub2:    suba    2,i
         br      startday
sub1:    suba    1,i         
                 
startday:ldx     0,i
         sta     resulta4,d
div7:    addx    1,i
         suba    7,i
         brge    div7
         adda    7,i
         subx    1,i
         sta     commcem,d

;++++++++++++++++++++++++++++++++++++++++++++++++++

         call    multipl3
         sta     commcem,d
         sta     indice21,d
         lda     0,i      
         call    semaine
         call    add6
         call    ajouvide
         ldx     indice2,d
         stx     indice2,d

;**********************************
;**********************************
         ldx     0,i
         stx     indice,d 
                 
debut:   ldx     indice,d 
         ldbytea jour,x
         cpa     '\x00',i

         breq    fin 

         ldx     indice2,d
         stbytea mois,x
         addx    1,i
         stx     indice2,d
         ldx     indice,d
         addx    1,i
         stx     indice,d


         ldx     indice21,d
         addx    1,i
         stx     indice21,d
         cpx     21,i
         BREQ    AJOUTEN 

         BR      suite 

AJOUTEN:ldx      0,i
        stx      indice21,d
        ldx      indice2,d
        ldbytea  '\n',i
        stbytea  mois,x
         
        addx     1,i
        stx      indice2,d
        call     add6
        ldx      limite,d
        addx     1,i
        stx      limite,d    
     
suite:   ldx     indice2,d
         cpx     limite,d
         breq    fin
         br      debut

;************************************************
;************************************************




nbChifr: stro    msgnbC,d 
         br      vider

erreur:  stro    msgerror,d        
         br      vider

vider:   LDA     0,i                           
         CHARI   carac,d    
         LDBYTEA carac,d
         cpa     10,i
         brne    vider
         br      fin2

errANs:  stro    msgAN,d 
         br      fin2

manque:  stro    msg5,d
         br      fin2

errDouzM:stro    msgdouzM,d 
         br      fin2


fin2:    br      retour

fin:         ldx     0,i
         stx     temp,d
retour1: ldx     temp,d 
         ldbytea paie,x
         cpa     '\x00',i
         breq    jp 
         ldx     indice2,d


         stbytea mois,x

         addx    1,i
         stx     indice2,d
         ldx     temp,d
         addx    1,i
         stx     temp,d
         br      retour1


jp:      charo   '\n',i
         
         
         
         call    paie1
         call    datePaie
         ldbytea '\x00',i
         ldx     indice2,d
         stbytea mois,x
         stro    mois,d
         br      retour

terminer:stro    msgend,d        
         stop




msgerror:.ascii  "\nIl y a une erreur dans le nombre entré.\x00"
msgover: .ascii  "\nLa date ou le nombre entré est trop grand.\x00"
msgnbC:  .ascii  "\nLe nombre de chiffre est trop grand pour le calcul.\x00"
msg5:    .ascii  "\nIl manque des chiffre pour calculer la date.\x00"
msgAN:   .ascii  "\nL'année ne peut pas être calculé.\x00"
msgdouzM:.ascii "\nIl y a une erreur avec le nombre.\x00" 
msgend:  .ascii  "\nFin Nornale du programme.\x00"
paie:    .ascii  "\n\n      Jours de paie: \x00"
ligne:   .ascii  "\n________________________________________\x00"
question:.ascii  "Entrez la date désirée: \x00"

janvier: .ascii  "\n           Janvier  \x00"
fevrier: .ascii  "\n           Février  \x00"
mars:    .ascii  "\n           Mars  \x00"
avril:   .ascii  "\n           Avril  \x00"
mai:     .ascii  "\n           Mai  \x00"
juin:    .ascii  "\n           Juin  \x00"
juillet: .ascii  "\n           Juillet  \x00"
aout:    .ascii  "\n           Août  \x00"
septembr:.ascii  "\n           Septembre  \x00"
octobre: .ascii  "\n           Octobre  \x00"
novembre:.ascii  "\n           Novembre  \x00"
decembre:.ascii  "\n           Décembre  \x00"

entete:  .ascii  "\n\n       D  L  M  M  J  V  S\n\n\x00" 
jour:    .ascii  " 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31  \x00"
enter:   .byte   '\n'

resultat:.block 2           ; #2d
resulta1:.block 2           ; #2d
resulta2:.block 2           ; #2d
resulta3:.block 2           ; #2d
resulta4:.block 2           ; #2d
jourpaie:.block 2           ; #2d
temp:    .block 2           ; #2d
tempom:  .block 2           ; #2d
reste:   .block 2           ; #2d
carac:   .block 1           ; #1d
douzeM:  .block 2           ; #2d
days:    .block 2           ; #2d       
limite:  .block 2            ;    #2d
nbJour:  .block 2            ;    #2d 
commcem: .block 2            ;    #2d 
indice:  .block 2            ;    #2d
indice2: .block 2            ;    #2d
indice21:.block 2            ;    #2d
isbiss:  .block 2            ;    #2do
annee:   .block 2            ;    #2d
chaine:  .BLOCK  7          ; #1h7a 
numeroM: .word 1 
mois:    .block 22           ;    #1h22d 
         .block 250          ;    #250d


;*************************************

ajouvide:lda     limite,d
         adda    commcem,d
         sta     limite,d
         ldx     0,i
         stx     temp,d
boucle1: cpx     commcem,d
         breq    finajou
         ldx     indice2,d
         ldbytea ' ',i
         stbytea mois,x
         addx    1,i
         stx     indice2,d
         ldx     temp,d
         addx    1,i
         stx     temp,d
         br      boucle1
finajou: ret0
;*************************************

semaine: call    add6
         ldx     0,i 
boucle2: stx     temp,d 
         ldbytea entete,x
         ldx     indice2,d
         cpa     '\x00',i
         breq    fin1
         stbytea mois,x
         addx    1,i
         stx     indice2,d
         ldx     temp,d
         addx    1,i
         br      boucle2
fin1:    ldx     temp,d
         addx    limite,d
         stx     limite,d    
         ret0 
;*************************************

multipl3:sta     temp,d
         asla    
         adda    temp,d
         ret0

;**********************************************************************


calendM:         NOP0                     ;switch(Ind) {
                 LDX         douzeM,d    ; 
                 SUBX        1,i          ; ramener à [0..4]
                 ASLX                     ; * 2 => indice réel dans
                 BR          TABnn,x      ; table (adresse = 2 octets)
TABnn:           .ADDRSS CASnn_1 ;
                 .ADDRSS CASnn_2 ;
                 .ADDRSS CASnn_3 ;
                 .ADDRSS CASnn_4 ;
                 .ADDRSS CASnn_5 ;
                 .ADDRSS CASnn_6 ;
                 .ADDRSS CASnn_7 ;
                 .ADDRSS CASnn_8 ;
                 .ADDRSS CASnn_9 ;
                 .ADDRSS CASnn_10 ;
                 .ADDRSS CASnn_11 ;
                 .ADDRSS CASnn_12 ;                                
CASnn_1:         NOP0                 ; case 1: janvier
                 lda         31,i
                 sta     nbJour,d 

                 LDX         0,i          ; X = 0;
                 LDA         0,i          ; A = 0;
Encore1:         LDBYTEA     janvier,x    ; while(true)
                 stbytea     mois,x 
                 cpa         '\x00',i 
                 BREQ        Arret1       ; if(texte[X] == 0) break; 
                 ADDX        1,i          ; X++;}
                 BR          Encore1      ; }
Arret1:          STX         indice,d
                 BR          ENDCASnn
                                      ; break;
CASnn_2:         NOP0                 ; case 2: férvier
                 call        bisexx 
                 lda         isbiss,d
                 cpa         0,i
                 breq        non
                 lda         29,i
                 br          oui
non:             lda         28,i
oui:             sta         nbJour,d 
                 

                 LDX     0,i ; X = 0;
                 LDA     0,i ; A = 0;
Encore2:         LDBYTEA fevrier,x ; while(true)
                 stbytea mois,x 
                 cpa     '\x00',i 
                 BREQ    Arret2 ; if(texte[X] == 0) break; 
                 ADDX    1,i ; X++;}
                 BR      Encore2 ; }
Arret2:          STX     indice,d


                 BR ENDCASnn ; break;
CASnn_3:         NOP0 ; case 3:mars
                 lda         31,i
                 sta     nbJour,d
                 
                 LDX     0,i ; X = 0;
                 LDA     0,i ; A = 0;
Encore3:         LDBYTEA mars,x ; while(true)
                 stbytea mois,x 
                 cpa     '\x00',i 
                 BREQ    Arret3 ; if(texte[X] == 0) break; 
                 ADDX    1,i ; X++;}
                 BR      Encore3 ; }
Arret3:          STX     indice,d
            
                 BR ENDCASnn ; break;
CASnn_4:         NOP0 ; case 4:avril
                 lda         30,i
                 sta     nbJour,d 


                 LDX     0,i ; X = 0;
                 LDA     0,i ; A = 0;
Encore4:         LDBYTEA avril,x ; while(true)
                 stbytea mois,x 
                 cpa     '\x00',i 
                 BREQ    Arret4 ; if(texte[X] == 0) break; 
                 ADDX    1,i ; X++;}
                 BR      Encore4 ; }
Arret4:          STX     indice,d


                 BR ENDCASnn ; break;
CASnn_5:         NOP0 ; case 5: mai


                 LDX     0,i ; X = 0;
                 LDA     0,i ; A = 0;
Encore5:         LDBYTEA mai,x ; while(true)
                 stbytea mois,x 
                 cpa     '\x00',i 
                 BREQ    Arret5 ; if(texte[X] == 0) break; 
                 ADDX    1,i ; X++;}
                 BR      Encore5 ; }
Arret5:          STX     indice,d

                 lda         31,i
                 sta     nbJour,d 
                 BR ENDCASnn ; break;

CASnn_6:         NOP0 ; case 6: juin
                 lda         30,i
                 sta     nbJour,d 
                 LDX     0,i ; X = 0;
                 LDA     0,i ; A = 0;
Encore6:         LDBYTEA juin,x ; while(true)
                 stbytea mois,x 
                 cpa     '\x00',i 
                 BREQ    Arret6 ; if(texte[X] == 0) break; 
                 ADDX    1,i ; X++;}
                 BR      Encore6 ; }
Arret6:          STX     indice,d
                 BR ENDCASnn ; break;

CASnn_7:         NOP0 ; case 7: juillet
                 lda         31,i
                 sta     nbJour,d 
                 LDX     0,i ; X = 0;
                 LDA     0,i ; A = 0;
Encore7:         LDBYTEA juillet,x ; while(true)
                 stbytea mois,x 
                 cpa     '\x00',i 
                 BREQ    Arret7 ; if(texte[X] == 0) break; 
                 ADDX    1,i ; X++;}
                 BR      Encore7 ; }
Arret7:          STX     indice,d
                 lda         31,i
                 sta     nbJour,d 
                 BR ENDCASnn ; break;

CASnn_8:         NOP0 ; case 8:aout
                 LDX     0,i ; X = 0;
                 LDA     0,i ; A = 0;
Encore8:         LDBYTEA aout,x ; while(true)
                 stbytea mois,x 
                 cpa     '\x00',i 
                 BREQ    Arret8 ; if(texte[X] == 0) break; 
                 ADDX    1,i ; X++;}
                 BR      Encore8 ; }
Arret8:          STX     indice,d
                 lda         31,i
                 sta     nbJour,d 
                 BR ENDCASnn ; break;

CASnn_9:         NOP0 ; case 9: septembre
                 LDX     0,i ; X = 0;
                 LDA     0,i ; A = 0;
Encore9:         LDBYTEA septembr,x ; while(true) 
                 stbytea mois,x 
                 cpa     '\x00',i 
                 BREQ    Arret9 ; if(texte[X] == 0) break; 
                 ADDX    1,i ; X++;}
                 BR      Encore9 ; }
Arret9:          STX     indice,d
                 lda         30,i
                 sta     nbJour,d 
                 BR ENDCASnn ; break;

CASnn_10:        NOP0 ; case 10: octobre
                 lda         31,i
                 sta     nbJour,d                
                 LDX     0,i ; X = 0;
                 LDA     0,i ; A = 0;
Encore10:        LDBYTEA octobre,x ; while(true)
                 stbytea mois,x 
                 cpa     '\x00',i 
                 BREQ    Arret10 ; if(texte[X] == 0) break; 
                 ADDX    1,i ; X++;}
                 BR      Encore10 ; }
Arret10:         STX     indice,d
                 BR ENDCASnn ; break;

CASnn_11:         NOP0 ; case 11: novembre
                 lda         30,i
                 sta     nbJour,d 
                 LDX     0,i ; X = 0;
                 LDA     0,i ; A = 0;
Encore11:        LDBYTEA novembre,x ; while(true)
                 stbytea mois,x 
                 cpa     '\x00',i 
                 BREQ    Arret11 ; if(texte[X] == 0) break; 
                 ADDX    1,i ; X++;}
                 BR      Encore11 ; }
Arret11:         STX     indice,d
                 BR ENDCASnn ; break;

CASnn_12:        NOP0 ; case 12: décembre
                 lda         31,i
                 sta     nbJour,d 
                 LDX     0,i ; X = 0;
                 LDA     0,i ; A = 0;
Encore12:        LDBYTEA decembre,x ; while(true)
                 stbytea mois,x 
                 cpa     '\x00',i 
                 BREQ    Arret12 ; if(texte[X] == 0) break; 
                 ADDX    1,i ; X++;}
                 BR      Encore12 ; }
Arret12:         STX     indice,d

ENDCASnn:        NOP0 ;}
              
                 ldx         0,i
                 LDBYTEA     chaine,x 
                 ldx         indice,d 
                 stbytea     mois,x            
                 addx        1,i
                 stx         indice,d

                 ldx         1,i
                 LDBYTEA     chaine,x
                 ldx         indice,d 
                 stbytea     mois,x            
                 addx        1,i
                 stx         indice,d

                 ldx         2,i
                 LDBYTEA     chaine,x
                 ldx         indice,d 
                 stbytea     mois,x            
                 addx        1,i
                 stx         indice,d

                 ldx         3,i
                 LDBYTEA     chaine,x
                 ldx         indice,d 
                 stbytea     mois,x            
                 addx        1,i
                 stx         indice,d
                 addx        1,i
                 LDBYTEA     '\n',i
                 stbytea     mois,x
                 addx        1,i
                 ldbytea     '\n',i
                 stbytea     mois,x
                 ret0

bisexx:          lda         annee,d 
                 ldx         0,i
         
                 ldx         4,i
                 call        div 
                 cpa         0,i
                 breq        is4
                 br          next1
is4:             lda         1,i
                 sta         isbiss,d                
next1:           ret0


;**********************************************************

div:             STX     diviseur,d  
                 LDX     0,i         ; X = 0
div_loop:        CPA     diviseur,d  
                 BRLT    div_fin     ; while(A>=diviseur) {
                 SUBA    diviseur,d  ;   A -= diviseur;
                 ADDX    1,i         ;   X++;
                 BR      div_loop    ; } // fin while
div_fin:         RET0                
diviseur:        .BLOCK  2           ; Variable globale #2d


multi1:  sta     temp,d    
         ASLA              ; * 2   
         ASLA              ; * 4     
         ADDA    temp,d    ; * 5    
         ASLA              ; * 10
         RET0

add6:    ldx     indice2,d
         ldbytea ' ',i
         stbytea mois,x
         addx    1,i
  
         ldbytea ' ',i
         stbytea mois,x
         addx    1,i

         ldbytea ' ',i
         stbytea mois,x
         addx    1,i
  
         ldbytea ' ',i
         stbytea mois,x
         addx    1,i

         ldbytea ' ',i
         stbytea mois,x
         addx    1,i
 
         ldbytea ' ',i
         stbytea mois,x
         addx    1,i
         stx     indice2,d
         ldx     limite,d
         addx    6,i
         stx     limite,d 
         ret0
         
 paie1:  lda     commcem,d
         ldx     3,i
         call    div
         lda     5,i    
         stx     commcem,d 
         suba    commcem,d
         sta     temp,d
         cpa     0,i
         brgt    premierJ
                
         BR      secondJ
premierJ:lda     resulta4,d
         adda    temp,d
         SUBa    1,i 
         ldx     14,i
         call    div
         cpa     4,i
         breq    paie_fin
secondJ: lda     resulta4,d
         adda    7,i
         adda    temp,d
         suba    1,i
         
         ldx     temp,d
         addx     7,i
         stx     temp,d

         ldx     14,i
         call    div
         cpa     4,i
         breq    paie_fin 
         lda     temp,d
         adda    7,i
         sta     temp,d
 
paie_fin:ret0


datePaie:lda     temp,d
boucle3: ldx     10,i
         call    div
         call    paieDATE
         lda     temp,d
         adda    14,i
         sta     temp,d
         cpa     nbJour,d 
         brgt    fin5
         ldx     indice2,d
         ldbytea ',',i
         stbytea mois,x
         addx    1,i
         stx     indice2,d
         lda     temp,d
         br      boucle3
fin5:    ret0  


paieDATE:sta     reste,d
         stx     tempom,d 
         cpx     0,i
         brgt    suivant 
         ldx     indice2,d
         
         lda     reste,d
         adda    '0',i
         stbytea mois,x
         addx    1,i
         stx     indice2,d
         br      finpaie

suivant: ldx     indice2,d

         lda tempom,d
         adda    '0',i
         stbytea mois,x
         addx    1,i
         lda      reste,d
         adda    '0',i
         stbytea mois,x
         addx    1,i
         stx     indice2,d
         br      finpaie

           
finpaie: ret0
.end   
