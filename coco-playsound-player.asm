 ORG $3000
start
 ldx #buffer
 ldb length
 jsr $4000
 rts

 ORG $3020
length rmb 1
buffer rmb 128
 end start
