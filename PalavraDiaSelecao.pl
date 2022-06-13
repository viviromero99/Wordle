% Adiciona o contexto do dicionário na execucao.
:- consult(dicionario).

% Converte uma lista para String.
str_toList(STR, LIST) :- atom_chars(STR, LIST).

% Tamanho de uma lista.
len([_], 1):- !.
len([_|L], T):- len(L, X), T is X + 1.

% Remover item de lista.
remover( _, [], []).
remover( R, [R|T], T).
remover( R, [H|T], [H|T2]) :- H \= R, remover( R, T, T2).

% Identificar item comum em duas listas.
elemento_comum([], _, []).
elemento_comum([H|T], LIST, [H|LIST_COMUM]):-
    member(H, LIST),
    !, 
    remover(H, LIST, LIST_F),
    elemento_comum(T, LIST_F, LIST_COMUM).
elemento_comum([_|T], LIST, LIST_COMUM) :- elemento_comum(T, LIST, LIST_COMUM).

% Formatar lista de posicoes apenas com as letras.
format_pos_list([],[]).
format_pos_list([H|T], [L|FORMAT_LIST]):- H=_-L, format_pos_list(T, FORMAT_LIST).
format_pos_list([_|T], FORMAT_LIST):- format_pos_list(T, FORMAT_LIST).

% Confere elementos com posicao correta.
confere_pos(SUBS_LIST, SUBS_TEST_LIST, POS_CORRETA) :-
    findall(I-V,nth0(I,SUBS_LIST,V),SUBS_LIST_POS),
	findall(I-V,nth0(I,SUBS_TEST_LIST,V),SUBS_LIST_TEST_POS),
    elemento_comum(SUBS_LIST_POS, SUBS_LIST_TEST_POS, POS_CORRETA),
    !.

% Subtrai uma lista de outra.
subtrai_listas(LIST_T, LIST, LIST_S) :-
    msort(LIST_T, LIST_T_ORDENADA),
    msort(LIST, LIST_ORDENADA),
    ord_subtract(LIST_T_ORDENADA, LIST_ORDENADA, LIST_S).

% Identifica elemento ERRADO.
elemento_errado(PALAVRA_T, PALAVRA, ELM_LIST)  :- 
    str_toList(PALAVRA, LIST),
    str_toList(PALAVRA_T, LIST_T),
    elemento_comum(LIST_T, LIST, ELM_COMUM),
    subtrai_listas(LIST_T, ELM_COMUM, ELM_LIST),
    !.

% Identifica elemento CERTO na posicao CERTA.
elemento_pos_correta(PALAVRA_T, PALAVRA, ELM_POS_CORRETA) :-
    str_toList(PALAVRA, LIST),
    str_toList(PALAVRA_T, LIST_T),
    confere_pos(LIST_T, LIST, ELM_POS_CORRETA),
    !.

% Identifica elemento CERTO na posicao ERRADA.
elemento_pos_errado(PALAVRA_T, ELM_ERRADO, ELM_POS_CORRETA, ELM_LIST) :-
    str_toList(PALAVRA_T, LIST_T),
    subtrai_listas(LIST_T, ELM_POS_CORRETA, ELM_POS_ERRADOS),
    subtrai_listas(ELM_POS_ERRADOS, ELM_ERRADO, ELM_LIST),
    !.

% Gera palavra do dia.
palavra_dia(TAM, PALAVRA, TIPO)  :-
	random_between(1,405,ID),
    word(TIPO, PALAVRA, TAM, ID),
	!.

% Realiza a verificacao da entrada.
palavra_corresp(PALAVRA_TESTE, PALAVRA_DIA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA) :-
    elemento_errado(PALAVRA_TESTE, PALAVRA_DIA, ELM_ERRADO),
    elemento_pos_correta(PALAVRA_TESTE, PALAVRA_DIA, ELM_POS_CORRETA),
    format_pos_list(ELM_POS_CORRETA, ELM_POS_CORRETA_LIST),
    elemento_pos_errado(PALAVRA_TESTE, ELM_ERRADO, ELM_POS_CORRETA_LIST, ELM_POS_ERRADA),
    !.

% Verifica intervalo do tamanho digitado.
intervalo(TAM_PALAVRA) :-
    4 =< TAM_PALAVRA,
    7 >= TAM_PALAVRA.

% Faz a leitura do tamanho da palavra.
ler_tam_palavra(TAM_PALAVRA) :-
  format('Qual o tamanho da palavra que gostaria de adivinhar?'),
  nl,
  format('Lembrando as opcoes sao 4,5,6 e 7'),
  nl,
  read_string(user_input, ".", "\r\t\n ", _SEP, TAM_STRING),
  number_string(TAM_PALAVRA, TAM_STRING),
  integer(TAM_PALAVRA),
  intervalo(TAM_PALAVRA) -> 
    ! ;
    format('Essa opcão não existe.'),
  	nl,
    ler_tam_palavra(TAM_PALAVRA).

% Valida que a palavra recebida respeita o tamanho definido e está no dicionário.
validar_palavra(PALAVRA, TAMANHO) :-
    str_toList(PALAVRA, PALAVRA_LIST),
    len(PALAVRA_LIST, RESPOSTA_LEN),
    word(_TIPO, PALAVRA, TAMANHO, ID),
    ID > 0 ,
    RESPOSTA_LEN =:= TAMANHO .

% Faz a leitura da palavra de tentativa do usuário.
ler_palavra(TAMANHO, PALAVRA) :-
    nl,
    format("Qual seu palpite?"),
    nl,
    read_string(user_input, ".", "\r\t\n ", _SEP, RESPOSTA),
    string_lower(RESPOSTA, PALAVRA),
    validar_palavra(PALAVRA, TAMANHO) ->
        ! ;
        nl,
        format('Palavra contém tamanho diferente de ~q ou não consta no nosso dicionario.', [TAMANHO]),
        nl,
        format('Tente novamente!'),
        nl,
        ler_palavra(TAMANHO, PALAVRA) .

% Valida se a partida foi de vitória
validar_partida(ELM_ERRADO, ELM_POS_ERRADA, VITORIA) :-
    len(ELM_ERRADO, ELM_ERRADO_LEN),
	ELM_ERRADO_LEN > 0 ->
        VITORIA is 0,
    	! ;
    	len(ELM_POS_ERRADA, ELM_POS_ERRADA_LEN),
    	ELM_POS_ERRADA_LEN > 0 -> 
    		VITORIA is 0,
            ! ;
    		format('Parabéns! Você acertou a palavra!'),
    		nl,
    		VITORIA is 1 .

% Imprime o placar na tela.		
mostrar_placar(ELM_ERRADO, ELM_POS_ERRADA, ELM_POS_CORRETA) :-
    ansi_format([bold,fg(red)],'Elementos errados: ~q ', [ELM_ERRADO]),
    nl,
    ansi_format([bold,fg(yellow)],'Elementos certos na posicao errada: ~q ', [ELM_POS_ERRADA]),
    nl,
    ansi_format([bold,fg(green)],'Elementos certos na posicao certa: ~q ', [ELM_POS_CORRETA]),
    nl.
    

% Gerencia as etapas de cada partida: leitura palavra, validacao tentativa, mostra acertos e erros.
partida(TAM_PALAVRA, PALAVRA, TENTATIVAS) :-
	ler_palavra(TAM_PALAVRA, PALAVRA_T),
    palavra_corresp(PALAVRA_T, PALAVRA, ELM_ERRADO, ELM_POS_CORRETA, ELM_POS_ERRADA),
    mostrar_placar(ELM_ERRADO, ELM_POS_ERRADA, ELM_POS_CORRETA),
    validar_partida(ELM_ERRADO, ELM_POS_ERRADA, VITORIA),
    VITORIA =:= 1 ->
        ! ;
        TENTATIVAS =:= 1 ->
            format('Poxa, você errou a palavra e não restam mais tentativas!'),
            nl,
            !;
            RESTO_TENTATIVAS is TENTATIVAS - 1,
            format('Poxa, você errou a palavra! Ainda restam ~q tentativas, tente novamente!', [RESTO_TENTATIVAS]),
            nl,
            partida(TAM_PALAVRA, PALAVRA, RESTO_TENTATIVAS).

% Define a base do jogo, a palavra a ser gerada, chamada de partida inicial e encerramento.
jogar() :-
    ler_tam_palavra(TAM_PALAVRA),
    palavra_dia(TAM_PALAVRA, PALAVRA, TIPO),
    format('Obaaa! Já temos uma palavra para você!'),
    nl,
    format('Dica! Ela é do tipo: ~q.', [TIPO]),
    nl,
    partida(TAM_PALAVRA, PALAVRA, 6),
    format(' PALAVRA CORRETA: ~q.', [PALAVRA]),
    nl,
    nl,
    write('Você gostaria de jogar novamente? (sim ou nao)'),
    read_string(user_input, ".", "\r\t\n ", _SEP, RESPOSTA),
    string_lower(RESPOSTA, RESPOSTA),
    RESPOSTA = "sim" ->
        jogar() ;
        ! .

main :-
    format('Olá, jogador!'),
    nl,
    format('Preparado para jogar?'),
    nl,
    jogar(),
    halt(0) .

:- initialization(main) .