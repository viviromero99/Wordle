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

remover( _, [], []).
remover( R, [R|T], T).
remover( R, [H|T], [H|T2]) :- H \= R, remover( R, T, T2).

elemento_comum([], _, []).
elemento_comum([H|T], LIST, [H|LIST_COMUM]):-
    member(H, LIST),
    !, 
    remover(H, LIST, LIST_F),
    elemento_comum(T, LIST_F, LIST_COMUM).
elemento_comum([_|T], LIST, LIST_COMUM) :- elemento_comum(T, LIST, LIST_COMUM).

format_pos_list([],[]).
format_pos_list([H|T], [L|FORMAT_LIST]):- H=_-L, format_pos_list(T, FORMAT_LIST).
format_pos_list([_|T], FORMAT_LIST):- format_pos_list(T, FORMAT_LIST).

palavra_dia(TAM, PALAVRA)  :-
	len_palavra(TAM, PALAVRA),
	random_between(0,5,ID),
	id_palavra(ID, PALAVRA),
    format("Palavra do Dia: ~q\n",[PALAVRA]),
	!.

confere_pos(SUBS_LIST, SUBS_TEST_LIST, POS_CORRETA) :-
    findall(I-V,nth0(I,SUBS_LIST,V),SUBS_LIST_POS),
	findall(I-V,nth0(I,SUBS_TEST_LIST,V),SUBS_LIST_TEST_POS),
    elemento_comum(SUBS_LIST_POS, SUBS_LIST_TEST_POS, POS_CORRETA),
    !.

str_toList(STR, LIST) :- atom_chars(STR, LIST).

elemento_errado(PALAVRA_T, PALAVRA, ELM_LIST)  :- 
    str_toList(PALAVRA, LIST),
    str_toList(PALAVRA_T, LIST_T),
    elemento_comum(LIST_T, LIST, ELM_COMUM),
    msort(LIST_T, LIST_T_SORTED),
    msort(ELM_COMUM, ELM_COMUM_SORTED),
    ord_subtract(LIST_T_SORTED, ELM_COMUM_SORTED, ELM_LIST),
    !.

elemento_pos_correta(PALAVRA_T, PALAVRA, ELM_LIST) :-
    str_toList(PALAVRA, LIST),
    str_toList(PALAVRA_T, LIST_T),
    confere_pos(LIST_T, LIST, POS_CORRETA),
    format_pos_list(POS_CORRETA, ELM_LIST),
    !.

elemento_pos_errado(PALAVRA_T, ELM_ERRADO, ELM_POS_CORRETA, ELM_LIST) :-
    str_toList(PALAVRA_T, LIST_T),
    msort(LIST_T, LIST_T_SORTED),
    msort(ELM_POS_CORRETA, ELM_POS_CORRETA_SORTED),
    msort(ELM_ERRADO, ELM_ERRADO_SORTED),
    ord_subtract(LIST_T_SORTED, ELM_POS_CORRETA_SORTED, ELM_POS_ERRADOS),
    ord_subtract(ELM_POS_ERRADOS, ELM_ERRADO_SORTED, ELM_LIST),
    !.

palavra_corresp(PALAVRA_TESTE, PALAVRA_DIA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA) :-
    elemento_errado(PALAVRA_TESTE, PALAVRA_DIA, ELM_ERRADO),
    elemento_pos_correta(PALAVRA_TESTE, PALAVRA_DIA, ELM_POS_CORRETA),
    elemento_pos_errado(PALAVRA_TESTE, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA),
    !.







