% Escolhe palavra do dia
palavra_dia(TAM)  :-
	seleciona_palavra(TAM, LINHAS, ID),
    format('Obaaa! Já temos uma palavra para você!'),
    nl.

% seleciona palavra por tamanho aleatóriamente
seleciona_palavra(TAM, LINHAS, X)  :-
	(4 = TAM ->  open('palavras_tamanho_4.txt', read, Str), random(0, 200, X);
    5 = TAM ->  open('palavras_tamanho_5.txt', read, Str), random(0, 200, X);
    6 = TAM ->  open('palavras_tamanho_6.txt', read, Str), random(0, 200, X);
    7 = TAM ->  open('palavras_tamanho_7.txt', read, Str), random(0, 200, X))->
    read_file(Str, LINHAS),
    close(Str),
    nl.

read_file(Stream,[]):-
    at_end_of_stream(Stream).
   
read_file(Stream,[X|L]):-
    \+  at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).