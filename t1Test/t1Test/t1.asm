.686
.model flat, C
 option casemap:none

.data 
public g
g	DWORD	4
.code


public		min                             ;min(a,b,c)

min:		push ebp						; save ebp
			mov ebp, esp					; ebp -> a new stack frame 

            mov eax, [ebp+8]                ; v = a
            cmp eax, [ebp+12]               ; if (b < v)
            jl  continue                    ; {

            mov eax, [ebp+12]               ;   v = b
                                            ;}
continue:
            cmp eax,[ebp+16]                ;if (c < v)
            jl  compareEnd                  ;{
            mov eax,[ebp+16]                ;   v = c
                                            ;}
compareEnd :
	
			mov esp,ebp						; restore esp
			pop ebp							; restore previous ebp
			ret 0							; return from function

public		p                               ;p(i,j,k,l)

p: 			push ebp						; save ebp
			mov ebp,esp						; ebp -> a new stack frame

			mov eax,[ebp+12]				; eax = j ( or p02)
			push eax						; push eax/j into stack as third parameter for min
            mov eax,[ebp+8]					; eax = i ( or p01)
			push eax						; push eax/i into stack as second parameter for min			
			push g							; push g into stack as first parameter for min
			call min						; min(g,i,j)

			push eax						; push min(g,i,j) returned value into stack as first parameter for min
			mov eax,[ebp+16]				; eax = k ( or p03)
			push eax						; push eax/k into stack as second parameter for min	
			mov eax,[ebp+20]				; eax = l ( or p04)
			push eax						; push eax/l into stack as third parameter for min	
			call min						; min(min(g,i,j),k,k)		

			mov esp,ebp						; restore esp		
			pop ebp							; restore previous ebp						
			ret 0							; return from function		


public		gcd							; gcd(a,b)

gcd:		push ebp					; save ebp
			mov ebp, esp				; ebp -> a new stack frame

			mov ecx, [ebp+12]			; ecx = b
			mov eax, [ebp+8]			; eax = a
            test ecx, ecx               ;if (b == 0)
            je gcdend                   ;{
                                        ;   return a
                                        ;}
			
			xor edx,edx					; clear edx 
            cdq							; sign extend eax -> edx:eax 
            idiv ecx                    ; divide eax:ecx, save result in edx
            push edx                    ; push remainder/a%b into stack 
			push ecx					; push b into the stack
            call gcd                    ; gcd(b,a%b)
			add esp, 8					; pop off parameter 
		
gcdend: 
			mov esp,ebp                 ; restore esp
			pop ebp						; restore previous ebp
			ret 0						; return from function
				
end