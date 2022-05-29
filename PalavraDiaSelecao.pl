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


palavra_dia(TAM, PALAVRA)  :-
	len_palavra(TAM, PALAVRA),
	random_between(0,5,ID),
	id_palavra(ID, PALAVRA),
    format("Palavra do Dia: ~q\n",[PALAVRA]),
	!.