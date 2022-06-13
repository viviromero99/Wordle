# Wordle
Jogo inspirado no Wordle, de acertar palavras em Prolog, mas sem a restrição de ser uma palavra por dia.

Foi criada uma lista dicionário de palavras, sem acentuação, com 405 palavras para cada tamanho, distribuídas nas categorias:

 - verbo
 - local
 - objeto
 - profissao
 - cor
 - corpo
 - geral
 - comida
 - animal
 - numero



# Instruções para jogar

 Para jogar nosso jogo, basta executar no terminal o comando " swipl -s PalavraDiaSelecao.pl " na raiz do projeto e começar a adivinhar palavras!



# Como jogar

 Descubra a palavra certa em 6 tentativas em uma partida. Após cada tentativa válida, o placar exibido no terminal mostra o quão perto você está de descobrir a palavra certa. 
 Ao acertar a letra e sua posição na palavra, é exibido no placar "pos - letra", onde pos é a posição na palavra de 0 até tamanho da palavra - 1.
 As palavras podem possuir letras repetidas.
 Uma palavra nova é escolhida a cada partida.
