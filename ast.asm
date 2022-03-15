%include "printf32.asm"

section .data
		num dd 0
		iterator dd 0 
		exponent dd 0
		suma dd 0 
		aux dd 0
		aux2 dd 0
    delim db " \n", 0
		token db " ", 0

section .bss
    root resd 1

section .text
extern malloc
extern strtok 
extern strdup

global create_tree
global iocla_atoi

iocla_atoi: 
	
	push ebp
	mov ebp, esp
	mov eax, dword[ebp + 8] 

	xor ecx, ecx 
	xor edx, edx 
	
aflare_lungime_string: 
	mov cl, byte[eax]													; parcurg byte cu byte tokenul
	cmp cl, 0x2d															; daca primul caracter este "minus"
	je negativ

continuare: 
	mov cl, byte[eax]	
	inc eax
	cmp cl, 0xa																; daca am enter la finalul numarului
	je enter_character
	mov edx, [num]
	inc edx
	mov [num], edx 														; incrementare contor
	mov dl, cl
	cmp dl, 0
	jne continuare 	
	jmp lungime_sir														; la iesirea din bucla,
																						; am in "num - 1" lungimea sirului	
enter_character:
	jmp continuare 

lungime_sir: 	
	mov ecx, [num]
	sub ecx, 1 	
	mov [num], ecx 														; acum am aflat lungimea tokenului	
	mov eax, dword[ebp + 8] 									; revin cu pointerul la inceput
	xor ecx, ecx 
	mov cl, byte[eax]
	cmp cl, 0x2d															; daca primul byte = caracterul "-"
	je numar_negativ 													

transformare_numar: 
	mov cl, byte[eax]
	inc eax 																	; parcurg stringul 
	mov edx, [iterator]
	inc edx
	mov [iterator], edx 											; incrementare contor
	mov edx, [num]
	sub edx, [iterator] 
	mov [exponent], edx 											; am aflat puterea la care
																						; se ridica 10
	cmp edx, 0
	je cifra 
	cmp edx, 1
	je cifra_zecilor 
	jmp cifra_ordin_mare

cifra_ordin_mare: 
	xor edx, edx
	mov [aux2], cl 														; salvez aici cifra 
	mov ecx, [exponent]
	sub ecx, 1
	mov [aux], eax 														; salvez aici pointerul 
	xor eax, eax	
	mov edx, 10 
label:
	imul edx, 10 															; ridic 10 la puterea "exponent"																
	loop label																; rezultatul se afla in eax 
	mov eax, edx 

	xor ecx, ecx
	mov ecx, [aux2] 
	sub ecx, 48																; transform cifra in numar 
	imul eax, ecx 														; inmultesc cifra cu puterea
																						; lui 10 corespunzatoare 
	mov edx, [suma]
	add edx, eax 
	mov [suma], edx 													; adun rezultatul la suma finala
	mov eax, [aux] 														; refac eax 
	jmp transformare
 
cifra: 
	sub cl, 48 																; transform cifra in numar
	mov edx, [suma]
	add edx, ecx 
	mov [suma], edx														; adun cifra la suma finala 
	jmp transformare

cifra_zecilor:
	sub cl, 48 																; transform cifra in numar 
	mov edx, eax 															; salvez eax 
	xor eax, eax
	mov al, 10 																; inmultesc cifra cu 10 
	mul cl 																		; rezultatul este in eax 
	mov ecx, [suma]
	add ecx, eax
	mov [suma], ecx 													; adun la suma finala 
	mov eax, edx 															; refac eax 
	xor ecx, ecx 
	jmp transformare

transformare: 
	mov edx, [iterator]
	cmp edx, [num] 														; daca am ajuns la finalul sirului 
	jne transformare_numar
	mov eax, dword[ebp + 8]										; revin la inceputul sirului
	xor ecx, ecx 
	mov cl, byte[eax]
	cmp cl, 0x2d 
	je negare_numar
	mov eax, [suma] 
	jmp finalizare 

negare_numar: 
	xor eax, eax
	mov eax, [suma]
	neg eax 
	jmp finalizare 

finalizare:
	mov ecx, 0						
	mov [num], ecx														; fac din nou toate variabilele 
	mov [iterator], ecx 											; egale cu zero 
	mov [exponent], ecx 
	mov [suma], ecx 
	mov [aux], ecx
	mov [aux2], ecx
	xor ecx, ecx
	xor edx, edx
	jmp lastt

numar_negativ: 
	inc eax 
	jmp transformare_numar 

negativ: 
	inc eax 
	mov cl, byte[eax]	
	jmp continuare 

lastt:
	leave
	ret	 

create_tree:

	push ebp
	mov ebp, esp
	push ebx 
	mov eax, dword[ebp + 8] 									; eax contine un string care 
																						; trebuie transformat in arbore
	xor ecx, ecx 
	xor edx, edx 
																						; incep sa parcurg sirul de tokeni 
	push delim																; string de delimitatori
	push eax																	; pointer la inceputul sirului  
	call strtok 															; am in eax primul token  
	add esp, 8																; refac stiva  
	push eax
	call strdup
	add esp, 4																; in eax am tokenul alocat dinamic 
	mov dword[token], eax
	push 12 
	call malloc																; am alocat 12 bytes pentru radacina 
																						; dupa malloc, eax pointeaza spre zona de memorie alocata 
	add esp, 4																; refac stiva 
	mov dword[root], eax											; radacina contine salvata adresa lui eax 
	mov edx, [token] 
	mov dword[eax], edx 											; pun valoarea nodului in [eax]
	push eax				 													; salvez pe stiva adresa la care este radacina arborelui 

bucla: 
	push delim																; la urmatoarele apeluri ale lui strtok, dau ca																						
	push 0																		; parametru sirul nul
	call strtok																; am in eax urmatorul token 
	mov dword[token], eax
	add esp, 8 																; refac stiva
	cmp eax, 0 																; daca s-a ajuns la null terminator 
	je last 
	mov eax, dword[token]
	push eax
	call strdup
	add esp, 4																; in eax am tokenul alocat dinamic
	mov dword[token], eax
	mov ecx, [eax]
	cmp ecx, 43																; daca tokenul este un plus 
	je not_frunza 
	cmp ecx, 45																; daca tokenul este un minus 
	je not_frunza
	cmp ecx, 42																; daca tokenul este un "inmultit" 
	je not_frunza
	cmp ecx, 47																; daca tokenul este un "impartit" 
	je not_frunza 														
	push 4
	call malloc																; am alocat 4 bytes, cat pentru o frunza 
																						; dupa malloc, eax pointeaza spre zona de memorie alocata 
	add esp, 4																; refac stiva 
	pop edx 																	; scot de pe stiva adresa parintelui 
	mov ecx, edx 															; si o retin in edx 
	push ecx																	; pun din nou adresa parintelui pe stiva 
	add edx, 4																; la valoarea de la aceasta adresa trebuie sa pun
	mov dword[edx], eax												; valoarea nodului stang 
	mov ecx, [token]
	mov dword[eax], ecx 											; inserare nod stang efectuata 
	mov dword[eax + 4], 0											; copiii frunzei sunt nuli 
	mov dword[eax + 8], 0 
	sub edx, 4																; am in edx adresa parintelui

inserare_dreapta: 
	push edx 
	push delim																																					
	push 0																		
	call strtok																; am in eax urmatorul token 
	add esp, 8 																; refac stiva
	mov dword[token], eax
	cmp eax, 0 																; daca s-a ajuns la null terminator 
	je last 
	mov eax, dword[token]
	push eax
	call strdup
	add esp, 4																; in eax am tokenul alocat dinamic
	mov dword[token], eax
	mov ecx, [eax]
	cmp ecx, 43																; daca tokenul este un plus 
	je not_frunza_dreapta 
	cmp ecx, 45																; daca tokenul este un minus 
	je not_frunza_dreapta
	cmp ecx, 42																; daca tokenul este un "inmultit" 
	je not_frunza_dreapta
	cmp ecx, 47																; daca tokenul este un "impartit" 
	je not_frunza_dreapta 														
	push 4
	call malloc																; am alocat 4 bytes, cat pentru o frunza 
  																					; dupa malloc, eax pointeaza spre zona de memorie alocata 
	add esp, 4																; refac stiva 
	pop edx 	
	add edx, 8																; la valoarea de la aceasta adresa trebuie sa pun
	mov dword[edx], eax 											; valoarea nodului drept 
	mov ecx, [token]
	mov dword[eax], ecx 											; inserare nod drept efectuata 
	mov dword[eax + 4], 0
	mov dword[eax + 8], 0 
	pop edx																		; acum ca nodul este terminal si am inserat ambele frunze, il scot definitiv din lista 
	cmp edx, [root]														; daca nodul cu ambii fii este radacina
	je last 																	; am alocat intregul arbore 

urcare: 
	pop edx																		; urc la parintele nodului 
	add edx, 8
	mov ecx, dword[edx]												; am in ecx adresa nodului drept
	sub edx, 8
	push edx 
	cmp ecx, 0
	je inserare_dreapta
	pop edx 
	cmp edx, [root]														; din acest loop ies cand am gasit un nod fara fiu drept sau am ajuns la radacina 
	je last 
	jmp urcare
	
not_frunza_dreapta:
	push 12
	call malloc																; am alocat 12 bytes, cat pentru un nod cu copii  
  																					; dupa malloc, eax pointeaza spre zona de memorie alocata 
	add esp, 4																; refac stiva 
	pop edx
	add edx, 8																; la valoarea de la aceasta adresa trebuie sa pun
	mov dword[edx], eax 											; valoarea nodului drept 
	mov ecx, [token]
	mov dword[eax], ecx 											; inserare nod drept efectuata 
	push eax 																	; salvez adresa nodului pe stiva 
	jmp bucla 

not_frunza: 
	push 12
	call malloc																; am alocat 12 bytes, cat pentru un nod 
																						; dupa malloc, eax pointeaza spre zona de memorie alocata 
	add esp, 4																; refac stiva 
	pop edx 																	; scot de pe stiva adresa parintelui 
	mov ecx, edx 															; si o retin in edx 
	push ecx																	; pun din nou adresa parintelui pe stiva 	
	add edx, 4																; la valoarea de la aceasta adresa trebuie sa pun
	mov dword[edx], eax												; valoarea nodului stang 
	mov ecx, [token]
	mov dword[eax], ecx 											; inserare nod stang efectuata 
	push eax
	jmp bucla

last: 
	xor eax, eax 
	mov eax, dword[root]
	pop ebx
	leave
	ret 

