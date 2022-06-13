:- consult([palavras_tamanho_4,palavras_tamanho_5,palavras_tamanho_6,palavras_tamanho_7]).

main :-
    write('Ola, jogador!'),
    nl,
    write('Preparado para uma partida?'),
    nl,
    ler_tam_palavra(TAM_PALAVRA) -> 
        jogar(TAM_PALAVRA);
    nl,
    write('Essa opcao nao existe.'),
    nl,
    nl,
    main.

ler_tam_palavra(TAM_PALAVRA) :-
  write('Qual o tamanho da palavra que gostaria de adivinhar?'),
  nl,
  write('Lembrando que as opcoes sao 4, 5, 6 ou 7 letras (Digite por exemplo: 5.)'),
  nl,
    read(TAM_PALAVRA),
    integer(TAM_PALAVRA),
    intervalo(TAM_PALAVRA).

intervalo(TAM_PALAVRA) :-
    3 < TAM_PALAVRA, 8 > TAM_PALAVRA.

jogar(TAM_PALAVRA) :-
    palavra_dia(TAM_PALAVRA, PALAVRA, TIPO),
    nl,
    write('Obaaa! Ja temos uma palavra para voce!'),
    nl,
    nl,
    format('Dica! Ela é do tipo: ~q .', [TIPO]),
    nl,
    partida(TAM_PALAVRA, PALAVRA, PALAVRA, PALAVRA, PALAVRA, 6).

% Gera palavra do dia
palavra_dia(TAM, PALAVRA, TIPO)  :-
    random_between(1,405,ID),
    word(TIPO, PALAVRA, TAM, ID),
    !.

partida(TAM_PALAVRA, PALAVRA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA, TENTATIVAS) :-
	ler_palavra(TAM_PALAVRA, PALPITE),
	palavra_corresp(PALPITE, PALAVRA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA),
    mostrar_placar(ELM_ERRADO, ELM_POS_ERRADA, ELM_POS_CORRETA),
    validar_partida(ELM_ERRADO, ELM_POS_ERRADA, VITORIA, TENTATIVAS, PALAVRA),
	VITORIA =:= 1 -> ! ;
        RESTO_TENTATIVAS is TENTATIVAS - 1,
    	partida(TAM_PALAVRA, PALAVRA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA, RESTO_TENTATIVAS).

ler_palavra(TAMANHO, PALAVRA) :-
    write('Qual seu palpite?'),
    nl,
    format('Lembrando que a palavra deve ter tamanho ~q .', [TAMANHO]),
    nl,
    nl,
    read(RESPOSTA), 
   	atom_string(RESPOSTA, PALAVRA),
    str_toList(PALAVRA, PALAVRA_LIST),
    len(PALAVRA_LIST, RESPOSTA_LEN),
    RESPOSTA_LEN =:= TAMANHO -> ! ;
    	nl,
        format('Palavra deve ter tamanho ~q .', [TAMANHO]),
    	nl,
    	write('Tente novamente!'),
    	nl,
        nl,
    	ler_palavra(TAMANHO, PALAVRA).


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

% Realiza a verificacao da entrada com palavra do dia
palavra_corresp(PALAVRA_TESTE, PALAVRA_DIA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA) :-
    elemento_errado(PALAVRA_TESTE, PALAVRA_DIA, ELM_ERRADO),
    elemento_pos_correta(PALAVRA_TESTE, PALAVRA_DIA, ELM_POS_CORRETA),
    format_pos_list(ELM_POS_CORRETA, ELM_POS_CORRETA_LIST),
    elemento_pos_errado(PALAVRA_TESTE, ELM_ERRADO, ELM_POS_CORRETA_LIST, ELM_POS_ERRADA),
    !.

validar_partida(ELM_ERRADO, ELM_POS_ERRADA, VITORIA, TENTATIVAS, PALAVRA) :-
    TENTATIVAS < 1 ->
        format('Poxa, você errou a palavra e não restam mais tentativas!'),
        nl,
        nl,
        format('PALAVRA CORRETA: ~q .', [PALAVRA]),
        nl
        nl,
        VITORIA is 0,
        terminar(VITORIA);
    len(ELM_ERRADO, ELM_ERRADO_LEN),
	ELM_ERRADO_LEN > 0 -> 
    	format('Poxa, você errou a palavra! Ainda restam ~q tentativas, tente novamente!', [TENTATIVAS]),
        nl,
        VITORIA is 0,
    	!
    ;
    	len(ELM_POS_ERRADA, ELM_POS_ERRADA_LEN),
    	ELM_POS_ERRADA_LEN > 0 -> 
    		format('Poxa, você errou a palavra! Ainda restam ~q tentativas, tente novamente!', [TENTATIVAS]),
    		nl,
    		VITORIA is 0, !
    	;
    		write('Parabéns! Você acertou a palavra!'),
    		nl,
            nl,
    		VITORIA is 1
            terminar(VITORIA)
    .
			
mostrar_placar(ELM_ERRADO, ELM_POS_ERRADA, ELM_POS_CORRETA) :-
    nl,
    ansi_format([bold,fg(red)],'Elementos errados: ~q ', [ELM_ERRADO]),
    nl,
    ansi_format([bold,fg(yellow)],'Elementos certos na posicao errada: ~q ', [ELM_POS_ERRADA]),
    nl,
    ansi_format([bold,fg(green)],'Elementos certos na posicao certa: ~q ', [ELM_POS_CORRETA]),
    nl.

terminar(RESULTADO) :-
    RESULTADO =:= 1 ->
        write('Voce ganhou o jogo! Gostaria de jogar novamente? (Digite sim. ou nao.)');
    RESULTADO =:= 0 ->   
        write('Voce perdeu o jogo! Mas não desanime, que tal jogar novamente? (Digite sim. ou nao.)');
    nl,
    read(RESPOSTA),
    RESPOSTA = "sim" ->
        nl,
        main;
    RESPOSTA = "nao" ->
        halt(0);
    write('Essa opcao nao existe.'),
    nl,
    nl,
    terminar(RESULTADO).

