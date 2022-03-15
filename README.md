BARBU MARIA-ALEXANDRA, 325CD

TEMA 3- IOCLA- ARBORE SINTACTIC ABSTRACT 

Functia "iocla_atoi":

	Functia primeste ca parametru un numar sub forma de string. Parcurg byte cu
byte sirul de caractere incrementand progresiv un contor pentru a afla lungimea
stringului. Daca numarul este negativ, ignor la numaratoare caracterul "-". 
Ulterior, revin cu pointerul la inceputul sirului si incep sa il parcurg din
nou caracter cu caracter pana cand acopar intreaga lui lungime. Pentru fiecare
caracter, aflu exponentul la care trebuie ridicat 10 pentru transformarea
intr-un numar in baza 10. Pentru calculul ridicarii la o putere mai mare decat
2, folosesc instructiunea "loop" si "imul" pentru a putea face inmultiri
repetate pe 4 bytes. Scazand 48 din codul ASCII al caracterului, acesta se
transforma in numar. Inmultesc cifra obtinuta cu puterea lui 10 rezultata
anterior din loop, si adun intr-o suma rezultatul acestei operatii pentru
fiecare caracter din stringul initial. In final, aceasta suma contine numarul
cautat in baza 10. Pentru numere negative, am ignorat initial minusul si in
final am folosit instructiunea "neg". 

Functia create_tree:

	Functia primeste un string care contine parcurgerea in preordine a arborelui.
Pentru a obtine fiecare element din viitorul arbore sintactic, am apelat
functia externa "strtok". Pentru a aloca memorie pentru fiecare token obtinut,
am apelat functia externa "strdup". Pentru a aloca memorie pentru fiecare nod,
am folosit functia externa "malloc". Foarte importanta este observatia ca
fiecare numar este neaparat frunza in arborele sintactic abstract. Mai intai am
alocat primul token si l-am inserat ca radacina in arbore. Mai apoi, intr-un
loop:
	- am extras urmatorul token si l-am alocat dinamic
	- daca este frunza:
		- aloc memorie pentru urmatorul nod
		- inserez la stanga 
		- ma intorc la nodul parinte scotand de pe stiva o adresa 
	in alta bucla: 
		- aloc memorie pentru urmatorul nod, extrag urmatorul token si il aloc
		- inserez la dreapta
		- daca este frunza: 
			- ma intorc la nodul parinte scotand de pe stiva
			- pana cand ajung la un nod fara copil drept sau la radacina 
			- daca ajung la radacina si aceasta are copil drept, programul se incheie 
			- daca ajung la un nod fara copil drept, se repeta pasii 
	din aceasta bucla 
		- dac nu este frunza, inserez la dreapta si se repeta pasii
din primul loop 
	- daca nu este frunza:
		- aloc memorie pentru urmatorul nod 
		- inserez la stanga 
		- se repeta pasii 
din primul loop 
	Bug-uri pot aparea multe, mai ales la lucrul cu pointeri si la alocarea
corecta a memoriei.  

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------




   
