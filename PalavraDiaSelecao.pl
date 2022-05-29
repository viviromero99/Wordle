% Palavras por Tamanho

% Tamanho 4
len_palavra(4, seta).
len_palavra(4, roda).
len_palavra(4, vela).
len_palavra(4, alvo).
len_palavra(4, gato).

% Tamanho 5
len_palavra(5, terra).
len_palavra(5, trapo).
len_palavra(5, visor).
len_palavra(5, capuz).
len_palavra(5, vento).

% Tamanho 6
len_palavra(6, hostil).
len_palavra(6, pressa).
len_palavra(6, nativo).
len_palavra(6, forjar).
len_palavra(6, aurora).

% Tamanho 7
len_palavra(7, cultura).
len_palavra(7, ousadia).
len_palavra(7, mancebo).
len_palavra(7, advento).
len_palavra(7, conexao).

% Identificadores das Palavras
id_palavra(0, seta).
id_palavra(1, roda).
id_palavra(2, vela).
id_palavra(3, alvo).
id_palavra(4, gato).
id_palavra(0, terra).
id_palavra(1, trapo).
id_palavra(2, visor).
id_palavra(3, capuz).
id_palavra(4, vento).
id_palavra(0, hostil).
id_palavra(1, pressa).
id_palavra(2, nativo).
id_palavra(3, forjar).
id_palavra(4, aurora).
id_palavra(0, cultura).
id_palavra(1, ousadia).
id_palavra(2, mancebo).
id_palavra(3, advento).
id_palavra(4, conexao).

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
palavra_dia(TAM, PALAVRA)  :-
	len_palavra(TAM, PALAVRA),
	random_between(0,5,ID),
	id_palavra(ID, PALAVRA),
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
  TAM_PALAVRA < 8 -> nl, ! ;
    format('Essa opcão não existe.'),
  	nl,
    ler_tam_palavra(TAM_PALAVRA),
  TAM_PALAVRA > 3 ->  nl, ! ; 
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

jogar(PALAVRA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA) :-
    format('Olá, jogador!'),
    nl,
    format('Preparado para uma partida?'),
    nl,
    ler_tam_palavra(TAM_PALAVRA),
    palavra_dia(TAM_PALAVRA, PALAVRA),
    format('Obaaa! Já temos uma palavra para você!'),
    nl,
    partida(TAM_PALAVRA, PALAVRA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA),
    nl,
    format(' PALAVRA CORRETA: ~q .', [PALAVRA]),
    nl,
    nl,
    nl,
    nl.

