option casemap:none 

includelib legacy_stdio_definitions.lib
extrn printf:near
.data

.data
public g
g    QWORD    4
fmt  db       'a = %I64d b = %I64d c = %I64d d = %I64d e = %I64d sum = %I64d',0AH,00H
qnss db		  'qns',0AH,00H
.code



public        min							;min(a,b,c)

min:        mov rax, rcx	                ; v = a
            cmp rax, rdx					; if (b < v)
            jl  continue                    ; {
                
            mov rax, rdx	                ;   v = b
                                            ;}
continue:
            cmp rax, r8		                ;if (c < v)
            jl  compareEnd                  ;{
            mov rax, r8		                ;   v = c
                                            ;}

compareEnd :
            ret 0                           ; return from function

public        p                             ;p(i,j,k,l)

p:         	sub rsp, 32						; allocate shadow space
			mov [rsp+64], r9				; store l into stack to be used later,
			mov [rsp+56], r8				; store k into stack to be used later  
			mov r8, rdx						; min parameter 3 in r8 [rdx/j]
			mov rdx, rcx					; min parameter 2 in rdx [rcx/i]
			mov rcx, g						; min parameter 1 in rcx [g]

            call min                        ; min(g,i,j)

			mov rcx, rax					; mov result in min(g,i,j) into rcx as min parameter 1 
			mov r8, [rsp+64]				; pop original l into min parameter 2
			mov rdx, [rsp+56]				; pop original k into min parameter 3	
			           
            call min                        ; min(min(g,i,j),k,k)
			add rsp, 32						; deallocate shadow space 
            ret 0							; return from function

public        gcd							; gcd(a,b)

gcd:     	mov rax, rcx					; mov a into rax to be used in division  
			mov rcx, rdx					; mov rdx into rcx as gcd parameter 1
            test rdx, rdx					;if (b == 0)
            je gcdend						;{
											;   return a
											;}
			
            xor rdx,rdx						; clear rdx
            cqo								; sign extend rax -> rdx:rax
            idiv rcx						; divide rax:rcx, save result in rdx
            call gcd						; gcd(b,a%b)
          
gcdend:
            ret 0							; return from function

public       q								; q(a,b,c,d,e)

q:          sub rsp, 56						; allocate shadow space and space for parameters (4+3)*7= 56
           		
            mov rax, rcx					; rax/sum = a
            add rax, rdx					; sum += b
            add rax, r8						; sum += c
            add rax, r9						; sum += d
            add rax, [rsp+96]				; sum += e
			
			mov [rsp+80],rax				; preserve sum in the shadow space 
            mov [rsp+48],rax				; sum as printf parameter 7 in [rsp+48]
			mov rax, [rsp+96]				; rax = e
			mov [rsp+40],rax				; e as printf parameter 6 in [rsp+40]
			mov [rsp+32],r9					; d as printf parameter 5 in [rsp+40]
            
            mov r9, r8						; c as printf parameter 4 in r9
            mov r8, rdx						; b as printf parameter 3 in r8
            mov rdx, rcx					; a as printf parameter 2 in rdx
            lea rcx, fmt					; fmt as printf parameter 1 in rcx

            call printf						; call printf function
			mov rax, [rsp+80]				; pop out the preserve sum from stack
			add rsp, 56						; deallocate shadow space and additional parameters space
            ret	0							; return

public		qns

qns:		sub rsp, 32						; allocate space 
			lea rcx, qnss					; printf parameter 1 in rcx [&qnss]
			call printf						; printf(qnss)
			mov rax, 0						; function result in rax = 0 
			add rsp, 32						; deallocate space 
			ret	0							; return
end