% Converte uma lista para String
str_toList(STR, LIST) :- atom_chars(STR, LIST).

% Tamanho de uma lista
len([_], 1):- !.
len([_|L], T):- len(L, X), T is X + 1.

% Remover item de lista
remover( _, [], []).
remover( R, [R|T], T).
remover( R, [H|T], [H|T2]) :- H \= R, remover( R, T, T2).

% Identificar item comum em duas listas
elemento_comum([], _, []).
elemento_comum([H|T], LIST, [H|LIST_COMUM]):-
    member(H, LIST),
    !, 
    remover(H, LIST, LIST_F),
    elemento_comum(T, LIST_F, LIST_COMUM).
elemento_comum([_|T], LIST, LIST_COMUM) :- elemento_comum(T, LIST, LIST_COMUM).

% Formatar lista de posicoes apenas com as letras
format_pos_list([],[]).
format_pos_list([H|T], [L|FORMAT_LIST]):- H=_-L, format_pos_list(T, FORMAT_LIST).
format_pos_list([_|T], FORMAT_LIST):- format_pos_list(T, FORMAT_LIST).

% Confere elementos com posicao correta
confere_pos(SUBS_LIST, SUBS_TEST_LIST, POS_CORRETA) :-
    findall(I-V,nth0(I,SUBS_LIST,V),SUBS_LIST_POS),
	findall(I-V,nth0(I,SUBS_TEST_LIST,V),SUBS_LIST_TEST_POS),
    elemento_comum(SUBS_LIST_POS, SUBS_LIST_TEST_POS, POS_CORRETA),
    !.

% Subtrai uma lista de outra
subtrai_listas(LIST_T, LIST, LIST_S) :-
    msort(LIST_T, LIST_T_ORDENADA),
    msort(LIST, LIST_ORDENADA),
    ord_subtract(LIST_T_ORDENADA, LIST_ORDENADA, LIST_S).

% Identifica elemento ERRADO
elemento_errado(PALAVRA_T, PALAVRA, ELM_LIST)  :- 
    str_toList(PALAVRA, LIST),
    str_toList(PALAVRA_T, LIST_T),
    elemento_comum(LIST_T, LIST, ELM_COMUM),
    subtrai_listas(LIST_T, ELM_COMUM, ELM_LIST),
    !.

% Identifica elemento CERTO na posicao CERTA
elemento_pos_correta(PALAVRA_T, PALAVRA, ELM_POS_CORRETA) :-
    str_toList(PALAVRA, LIST),
    str_toList(PALAVRA_T, LIST_T),
    confere_pos(LIST_T, LIST, ELM_POS_CORRETA),
    !.

% Identifica elemento CERTO na posicao ERRADA
elemento_pos_errado(PALAVRA_T, ELM_ERRADO, ELM_POS_CORRETA, ELM_LIST) :-
    str_toList(PALAVRA_T, LIST_T),
    subtrai_listas(LIST_T, ELM_POS_CORRETA, ELM_POS_ERRADOS),
    subtrai_listas(ELM_POS_ERRADOS, ELM_ERRADO, ELM_LIST),
    !.

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

% valida palpite inputado pelo usuário
valida_palpite(TAM, LINHAS, PALPITE)  :-
	(4 = TAM ->  open('palavras_tamanho_4.txt', read, Str);
    5 = TAM ->  open('palavras_tamanho_5.txt', read, Str);
    6 = TAM ->  open('palavras_tamanho_6.txt', read, Str);
    7 = TAM ->  open('palavras_tamanho_7.txt', read, Str))->
    read_file_valida(Str, LINHAS, PALPITE),
    close(Str),
    nl.

read_file_valida(Stream,[], PALPITE):-
    at_end_of_stream(Stream).
   
read_file_valida(Stream,[X|L], PALPITE):-
    \+  at_end_of_stream(Stream),
    read(Stream,X),
    X is PALPITE ->  , ! ;
    read_file(Stream,L).
    

% Realiza a verificacao da entrada
palavra_corresp(PALAVRA_TESTE, PALAVRA_DIA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA) :-
    elemento_errado(PALAVRA_TESTE, PALAVRA_DIA, ELM_ERRADO),
    elemento_pos_correta(PALAVRA_TESTE, PALAVRA_DIA, ELM_POS_CORRETA),
    format_pos_list(ELM_POS_CORRETA, ELM_POS_CORRETA_LIST),
    elemento_pos_errado(PALAVRA_TESTE, ELM_ERRADO, ELM_POS_CORRETA_LIST, ELM_POS_ERRADA),
    !.

ler_tam_palavra(TAM_PALAVRA) :-
  format('Qual o tamanho da palavra que gostaria de adivinhar?'),
  nl,
  format('Lembrando as opcoes sao 4,5,6 e 7'),
  nl,
  read(TAM_PALAVRA),
  TAM_PALAVRA < 8 -> nl, ! ;
    format('Essa opcão não existe.'),
  	nl,
    ler_tam_palavra(TAM_PALAVRA),
  TAM_PALAVRA > 3 ->  nl, ! ; 
    format('Essa opcão não existe.'),
  	nl,
   	ler_tam_palavra(TAM_PALAVRA),
   palavra_dia(TAM_PALAVRA).

ler_palavra(TAMANHO, PALAVRA) :-
    format('Qual seu palpite?'),
    nl,
    format('Lembrando que a palavra deve ter tamanho ~q .', [TAMANHO]),
    nl,
    read(RESPOSTA), 
   	atom_string(RESPOSTA, PALAVRA),
    str_toList(PALAVRA, PALAVRA_LIST),
    len(PALAVRA_LIST, RESPOSTA_LEN),
    RESPOSTA_LEN =:= TAMANHO -> ! ;
    	format('Palavra deve ter tamanho ~q .', [TAMANHO]),
    	nl,
    	format('Tente novamente!'),
    	nl,
    	ler_palavra(TAMANHO, PALAVRA).

validar_partida(ELM_ERRADO, ELM_POS_ERRADA, VITORIA) :-
    len(ELM_ERRADO, ELM_ERRADO_LEN),
	ELM_ERRADO_LEN > 0 -> 
    	format('Poxa, você errou a palavra! Tente novamente!'),
        nl,
        VITORIA is 0,
    	!
    ;
    	len(ELM_POS_ERRADA, ELM_POS_ERRADA_LEN),
    	ELM_POS_ERRADA_LEN > 0 -> 
    		format('Poxa, você errou a palavra! Tente novamente!'),
    		nl,
    		VITORIA is 0, !
    	;
    		format('Parabéns! Você acertou a palavra!'),
    		nl,
    		VITORIA is 1
    .
			
mostrar_placar(ELM_ERRADO, ELM_POS_ERRADA, ELM_POS_CORRETA) :-
    format('Elementos errados: ~q .', [ELM_ERRADO]),
    nl,
    format('Elementos certos na posicao errada: ~q .', [ELM_POS_ERRADA]),
    nl,
    format('Elementos certos na posicao certa: ~q .', [ELM_POS_CORRETA]),
    nl.

partida(TAM_PALAVRA, PALAVRA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA) :-
	ler_palavra(TAM_PALAVRA, PALAVRA_T),
	palavra_corresp(PALAVRA_T, PALAVRA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA),
    mostrar_placar(ELM_ERRADO, ELM_POS_ERRADA, ELM_POS_CORRETA),
    validar_partida(ELM_ERRADO, ELM_POS_ERRADA, VITORIA),
	VITORIA =:= 1 -> ! ;
    	partida(TAM_PALAVRA, PALAVRA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA).

main :-
    format('Olá, jogador!'),
    nl,
    format('Preparado para uma partida?'),
    nl,
  	ler_tam_palavra(TAM_PALAVRA),
    palavra_dia(TAM_PALAVRA, PALAVRA),
    partida(TAM_PALAVRA, PALAVRA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA),
    nl,
    format(' PALAVRA CORRETA: ~q .', [PALAVRA]),
    nl,
    nl,
    nl,
    nl.
