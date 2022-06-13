:- consult(dicionario).

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

% Gera palavra do dia
palavra_dia(TAM, PALAVRA, TIPO)  :-
	random_between(1,405,ID),
    word(TIPO, PALAVRA, TAM, ID),
	!.

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
  integer(TAM_PALAVRA),
  intervalo(TAM_PALAVRA) -> !;
    format('Essa opcão não existe.'),
  	nl,
    ler_tam_palavra(TAM_PALAVRA).

ler_palavra(TAMANHO, PALAVRA) :-
    format('Qual seu palpite?'),
    nl,
    format('Lembrando que a palavra deve ter tamanho ~q .', [TAMANHO]),
    nl,
    read(RESPOSTA), 
   	atom_string(RESPOSTA, PALAVRA),
    str_toList(PALAVRA, PALAVRA_LIST),
    len(PALAVRA_LIST, RESPOSTA_LEN),
    RESPOSTA_LEN =:= TAMANHO ->
        ! ;
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

jogar(PALAVRA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA) :-
    format('Olá, jogador!'),
    nl,
    format('Preparado para uma partida?'),
    nl,
    ler_tam_palavra(TAM_PALAVRA),
    palavra_dia(TAM_PALAVRA, PALAVRA, TIPO),
    format('Obaaa! Já temos uma palavra para você!'),
    nl,
    format('Dica! Ela é do tipo: ~q .', [TIPO]),
    nl,
    partida(TAM_PALAVRA, PALAVRA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA),
    format(' PALAVRA CORRETA: ~q .', [PALAVRA]),
    nl,
    nl,
    nl,
    nl.

main :-
    jogar(PALAVRA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA),
    write('Você gostaria de jogar novamente? (sim ou nao)'),
    read(RESPOSTA),
    RESPOSTA =:= 'sim' ->
        jogar(PALAVRA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA),
        !.