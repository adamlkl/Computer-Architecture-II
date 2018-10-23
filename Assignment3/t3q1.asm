add R0, #4, R9						;g = 4

min:								;int min(int a, int b, int c){		
	add R0, r26, r1					;	int v = a
	sub r27, r1, R0,{C}				;	if(b<v) {
	jle next						;
	xor r0, r0, r0					;nop
	add r0, r27, r1					;		v = b;	
									;	}
next:
	sub r28, r1, R0,{C}				;	if(c<v){
	jle endmin						;	
	xor r0, r0, r0					;nop
	add R0, R28, r1					;		v = c;

endmin:								;	}	
	ret r25, 0						;
	xor r0, r0, r0					;

p:									;int p(int i, int j, int k, int l){
	add r0, r9, r10					;	move g into min parameter 1
	add r0, r26, r11				;	move i into min parameter 2
	callr r25, min					;	min(g, i, j);
    add r0, r27, r12                ;    move j into min parameter 3
	
	add r0, r1, r10					;	move min(g, i, j) into min parameter 1
	add r0,	r28, r11				;	move k into min parameter 2
	callr r25, min					;	min((g, i, j),k,l);
    add r0, r29, r12                ;   move l into min parameter 3

	ret r25, 0						;	return result in R1
	xor r0, r0, r0					;nop

gcd:								;int gcd(int a, int b){
	sub r27, r0, r0,{C}				;if(b!=0){
	je gcdend						;
    add r0, r1, r26                 ;    result = a

	add r0, r26, r10				;	move a into modulus parameter 1
	callr r25, mod					;	mod(int a, int b); assuming remainder is returned in r1
    add r0, r27, r11                ;   move b into modulus parameter 2

	add r0, r27, r10				;	move b into modulus parameter 1
	callr r25, gcd					;	gcd(b, mod(int a, int b))
    add r0, r1, r11                 ;   move mod(int a, int b) into modulus parameter 2
									;}
gcdend:								;else{

	ret r25,0						;	return result
	xor r0,r0,r0					;}nop