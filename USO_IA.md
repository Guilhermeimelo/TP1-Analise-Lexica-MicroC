# USO_IA.md

Ferramenta: Claude (Claude Code / Sonnet 5)
Trecho: orientação geral sobre o trabalho (leitura do enunciado, README e
        esqueleto microc.flex)
Finalidade: pedi para a IA ler os arquivos do pacote (README.md, leiame.txt,
            TP1_Analise_Lexica_MicroC.pdf e microc.flex) e me explicar o que
            precisa ser feito, item a item, e em que ordem.
O que fiz: usei a explicação como um roteiro de estudo (equivalente a uma
           conversa com um monitor da disciplina). A IA não escreveu nenhuma
           regra léxica do trabalho (itens TODO(aluno)); apenas descreveu,
           em termos gerais, a técnica a ser usada em cada um (ex.: usar
           strcmp() para palavras reservadas, usar lookahead para diferenciar
           inteiro negativo de subtração), sem fornecer o código-solução.

---

Ferramenta: Claude (Claude Code / Sonnet 5)
Trecho: leiame.txt (README de entrega)
Finalidade: pedi para remover a seção de instruções do professor (delimitada
            pelos marcadores "---8<---cut here---8<---"), conforme pedido no
            próprio arquivo, e deixar apenas a linha "aluno: <matricula>".
O que fiz: a IA aplicou a edição diretamente (é uma tarefa administrativa de
           formatação, não envolve lógica do scanner). Conferi o resultado
           final do arquivo.

---

Ferramenta: Claude (Claude Code / Sonnet 5)
Trecho: configuração do ambiente de desenvolvimento (fora do código do
        trabalho)
Finalidade: pedi ajuda para instalar e configurar o WSL (Ubuntu) no Windows,
            incluindo flex, gcc e make, e para abrir o projeto no VSCode
            conectado ao WSL.
O que fiz: segui as instruções passo a passo (algumas exigiam privilégios de
           administrador e foram executadas por mim manualmente, como a
           instalação do WSL e do build-essential). Nenhum código do
           trabalho foi gerado nessa etapa.

---

Ferramenta: Claude (Claude Code / Sonnet 5)
Trecho: regra de <<EOF>> em microc.flex (linha ~109, fora dos itens
        TODO(aluno))
Finalidade: ao tentar compilar o esqueleto original (antes de qualquer
            edição minha), o flex acusou o erro "multiple <<EOF>> rules for
            start condition COMMENT". Pedi para a IA me ajudar a interpretar
            esse erro de compilação.
O que fiz: a IA explicou que a regra genérica "<<EOF>>" (linha 109), por
           aparecer no arquivo antes da regra "<COMMENT><<EOF>>" (linha
           123), estava sendo interpretada pelo Flex como also aplicável ao
           estado COMMENT, gerando o conflito. A correção sugerida e
           aplicada foi qualificar a regra genérica como "<INITIAL><<EOF>>",
           o que resolve a ambiguidade sem alterar nenhuma lógica de
           reconhecimento de tokens. Entendi a explicação e validei que a
           mudança não afeta nenhum dos itens que preciso implementar.

---

Ferramenta: Claude (Claude Code / Sonnet 5)
Trecho: regra de palavras reservadas em microc.flex (bloco {LETRA}{ALFANUM}*,
        item TODO(aluno) 1)
Finalidade: pedi orientação sobre como reconhecer as 8 palavras reservadas
            (main, if, else, for, return, int, char, print), que antes eram
            todas devolvidas como ID.
O que fiz: a IA explicou a técnica em termos gerais (comparar yytext com
           strcmp() dentro da própria ação da regra de identificador, antes
           de assumir ID; não chamar guarda_lexema() para palavras
           reservadas, só para ID de fato) e me deu um exemplo ilustrativo
           com nomes fictícios (ex.: "foo"/FOO_TOKEN), não com as palavras
           reais de Micro C. Eu escrevi as 8 comparações strcmp() de fato
           (main->MAIN, if->IF, else->ELSE, for->FOR, return->RETURN,
           int->INT, char->CHAR, print->PRINT) usando os nomes de token
           reais do enum TokenType do projeto. Na primeira tentativa usei
           por engano nomes como MAIN_TOKEN (copiando o sufixo do exemplo
           ilustrativo); a IA apontou o erro comparando com o enum real do
           arquivo e eu corrigi para os nomes corretos (MAIN, IF, etc.).
           Compilei e testei contra tests/test.mc para confirmar que as
           palavras reservadas agora saem com o tipo correto na saída.

---

Ferramenta: Claude (Claude Code / Sonnet 5)
Trecho: operadores relacionais e lógicos com prefixo compartilhado em
        microc.flex (item TODO(aluno) 3: !=, !, <=, <, >=, >, &&, ||)
Finalidade: pedi orientação sobre como completar os operadores que faltavam,
            já que o exemplo de "==" e "=" estava pronto no esqueleto.
O que fiz: a IA explicou que bastava seguir o mesmo padrão do exemplo (duas
           regras literais separadas, deixando o Flex escolher o casamento
           mais longo) e observou que "&&"/"||" não têm versão de um
           caractere (um "&" ou "|" isolado deve cair na regra de erro).
           Eu escrevi as 8 regras (!=, !, <=, <, >=, >, &&, ||) mapeando
           para os tokens NEQ, NOT, LEQ, LT, GEQ, GT, AND, OR do enum.
           Compilei e testei contra tests/test.mc, confirmando que todos os
           operadores saem com o tipo certo e que os únicos ERRO LEXICO
           remanescentes são aspas simples/duplas (esperado, pois
           CHARCONST/STRINGCONST ainda não foram implementados).

---

Ferramenta: Claude (Claude Code / Sonnet 5)
Trecho: constantes inteiras negativas vs. operador de subtração em
        microc.flex (item TODO(aluno) 4)
Finalidade: pedi orientação sobre a técnica de lookahead citada no enunciado
            para diferenciar "x - 5" (subtração) de "y = -5;" (número
            negativo), já que a regex sozinha não resolve — a diferença está
            no token que veio ANTES do '-', não depois.
O que fiz: a IA explicou o conceito (guardar num estado global se o último
           token devolvido "pode terminar uma expressão" — ID, INTEGERCONST,
           CHARCONST, STRINGCONST, RPAREN ou RBRACKET — e usar isso para
           decidir, numa nova regra "-{DIGIT}+", se o '-' é sinal ou
           subtração; usar yyless(1) para devolver os dígitos ao buffer
           quando for subtração) e me deu a estrutura de uma função auxiliar
           + macro (RETORNA) para centralizar essa atualização de estado em
           vez de editar manualmente every "return" do arquivo. Eu apliquei
           isso no arquivo inteiro e cometi três erros na implementação, que
           a IA me ajudou a diagnosticar lendo as mensagens de erro do gcc:
           (1) colei a função atualiza_e_retorna() aninhada DENTRO de
           guarda_lexema() por engano, em vez de como função separada;
           (2) quebrei a linha do "#define RETORNA(tipo) ..." em duas
           linhas, o que faz o pré-processador do C tratar a macro como
           vazia; (3) ao trocar "return X;" por "RETORNA(X);" em todo o
           arquivo (via find & replace com regex), esqueci os parênteses em
           quase todas as ocorrências, o que impede a macro de ser expandida
           (macro "function-like" só expande com parênteses). Corrigi os
           três problemas eu mesmo, guiado pelas explicações de cada erro de
           compilação. Testei com casos como "x = -5;", "y = x - 5;",
           "z = (x) - 5;", "v = a[0] - 1;" e o caso mais dificil,
           "u = 3 - -4;" (subtração seguida de negativo), e todos saíram
           corretos. Recompilei tests/test.mc e confirmei que não houve
           regressão nos itens já implementados.

---

Ferramenta: Claude (Claude Code / Sonnet 5)
Trecho: constante de caractere (CHARCONST) em microc.flex (parte 1 do item
        TODO(aluno) 2)
Finalidade: pedi orientação sobre como estender o padrão dado no enunciado
            ('[^'\n]') para também aceitar sequências de escape (ex.: '\n'),
            já que esse padrão básico só casa um único caractere literal
            entre aspas, e uma sequência de escape ocupa duas posições
            (barra + letra).
O que fiz: a IA sugeriu o padrão '([^'\\\n]|\\.)' (caractere comum OU barra
           invertida seguida de qualquer caractere) e a estrutura da ação
           (checar se yytext[1] é uma barra invertida; se for, converter
           yytext[2] pelo caractere real via switch; senão usar yytext[1]
           direto; guardar o resultado num buffer de 2 bytes via malloc).
           Colei essa estrutura, compilei e testei com 'A', '\n', '\t', '\\',
           '5' (todos reconhecidos como CHARCONST corretamente) e com casos
           de erro '' (vazio) e 'ab' (dois caracteres), que corretamente NÃO
           casam com a regra e caem no tratamento de erro genérico (UNDEF).
           Recompilei tests/test.mc e confirmei que os erros de 'A', 'H', 'i'
           (linhas 40-42, que antes davam ERRO LEXICO por falta de suporte a
           char) desapareceram, sem regressão nos demais itens.

---

Ferramenta: Claude (Claude Code / Sonnet 5)
Trecho: regra <COMMENT><<EOF>> em microc.flex (parte do exemplo JÁ PRONTO no
        esqueleto, fora dos itens TODO(aluno), mas relevante antes de eu
        escrever a regra análoga para STRINGCONST)
Finalidade: antes de implementar o tratamento de EOF dentro de string
            (que segue o mesmo padrão do comentário), pedi para a IA testar
            se o exemplo de comentário já pronto lidava corretamente com um
            arquivo terminando dentro de um comentário aberto.
O que fiz: a IA criou um arquivo de teste com um comentário de bloco nunca
           fechado e descobriu que o scanner entrava em LOOP INFINITO,
           repetindo o mesmo erro "EOF em comentario" indefinidamente (main()
           fica chamando yylex() enquanto o retorno for diferente de
           END_OF_FILE, e a regra <COMMENT><<EOF>> nunca devolvia
           END_OF_FILE). A causa: sem mudar de estado, uma nova chamada a
           yylex() re-executa a mesma regra de EOF. A correção (aplicada
           pela IA, com minha validação) foi adicionar "BEGIN(INITIAL);"
           antes do "RETORNA(UNDEF)" nessa regra — assim, na chamada
           seguinte, o scanner já está de volta em INITIAL, onde existe uma
           regra de EOF que devolve END_OF_FILE de verdade. Testei de novo
           com o mesmo arquivo e confirmei que agora reporta o erro uma
           única vez e encerra corretamente. Essa mesma técnica (BEGIN(INITIAL)
           antes de reportar erro de EOF) precisa ser usada na regra análoga
           de STRINGCONST que vou escrever a seguir.

---

Ferramenta: Claude (Claude Code / Sonnet 5)
Trecho: constante de string (STRINGCONST) em microc.flex (parte 2 do item
        TODO(aluno) 2: novo estado <STRING>, buffer de acumulação, conversão
        de escapes, e os 3 erros da Secao 4.1 - "EOF em string",
        "String nao terminada", "String contem caractere nulo")
Finalidade: pedi orientação de como estruturar o reconhecimento de string,
            já que precisa de um novo estado do Flex (%x STRING, no mesmo
            estilo do COMMENT ja existente) para acumular o conteudo
            caractere a caractere e detectar os erros no meio do caminho.
O que fiz: a IA explicou a estrutura completa (variável string_buffer +
           string_pos para acumular o conteúdo; regra de abertura da aspas
           que entra no estado STRING; regras dentro do estado para: aspas
           de fechamento, quebra de linha crua (erro), EOF (erro), byte nulo
           cru vs. escape "\0" (dois conceitos diferentes que a IA me
           explicou: \0 no padrão Flex casa o BYTE de valor zero de verdade,
           enquanto \\0 casa os dois caracteres de texto barra+zero digitados
           no arquivo-fonte), as 5 sequências de escape, e a regra genérica
           de "qualquer outro caractere"). Apliquei essa estrutura e cometi
           um erro de digitação (esqueci de escrever o padrão \" antes da
           chave de abertura da primeira regra, deixando uma acao sem
           padrao), que a IA identificou lendo o erro do flex ("unrecognized
           rule") e corrigiu diretamente (é um erro de sintaxe, não de lógica
           do trabalho). Testei com strings simples, com todas as 5
           sequências de escape (\n, \t, \\, \", \0) e confirmei via um
           printf de depuração TEMPORÁRIO (removido depois do teste) que o
           conteúdo convertido em microc_yylval.symbol estava correto -- o
           main() de debug do esqueleto só imprime yytext, que para strings
           mostra apenas o ultimo fragmento casado (as aspas de fechamento),
           não o conteúdo completo, entao essa verificação extra foi
           necessária. Testei também os 3 casos de erro (EOF em string,
           quebra de linha nao escapada, byte nulo) e confirmei que nenhum
           deles trava em loop infinito (usando BEGIN(INITIAL) como no
           comentário) e que as mensagens batem exatamente com o texto
           exigido no enunciado.
           Também identifiquei, junto com a IA, uma decisão de design sem
           resposta única no enunciado: se o erro "String nao terminada"
           deve reportar a linha onde a string COMEÇOU ou a linha seguinte
           (já incrementada, por consistência com o resto do arquivo, que
           sempre incrementa linha_atual imediatamente ao consumir um \n).
           Optei por manter a segunda opção (consistência), documentando o
           motivo aqui para poder justificar na entrevista. Numa tentativa
           de mudar isso, cometi um erro (mover "linha_atual++;" para depois
           de "RETORNA(...)", que contém um return, tornando aquela linha
           código morto); a IA explicou por que isso não funciona em C e
           ajudou a reverter para a versão correta.
           Recompilei tests/test.mc no final e confirmei ZERO erros léxicos
           remanescentes (antes havia 16 erros de aspas simples/duplas) e
           nenhuma regressão nos itens 1, 3 e 4 já implementados.

---

Ferramenta: Claude (Claude Code / Sonnet 5)
Trecho: ampliação dos arquivos de teste (item TODO(aluno) 5: tests/test.mc
        e novo arquivo tests/test_errors.mc)
Finalidade: pedi ajuda para ampliar a cobertura de testes do scanner --
            este é um uso explicitamente permitido pelo enunciado (Seção
            7.1: "Auxiliar na elaboração de casos de teste adicionais").
O que fiz: a IA acrescentou ao tests/test.mc casos que ainda não estavam
           cobertos (operador MOD, operador DIV como divisão de verdade,
           mais casos de inteiro negativo vs. subtração incluindo "3 - -4",
           string vazia, string com múltiplos escapes juntos, char com
           escape \n/\t/\\), e criou um novo arquivo tests/test_errors.mc
           dedicado a casos de erro léxico (6 caracteres inválidos
           diferentes, string não terminada, 3 variações de char malformado,
           comentário fechado sem abertura), seguido de código válido depois
           de todos os erros para provar que a recuperação de erro funciona.
           Também documentou, nos comentários do próprio arquivo de teste,
           por que os erros "EOF em string", "EOF em comentario" e "caractere
           nulo em string" ficaram em arquivos separados (string_eof_test.mc,
           eof_comment_test.mc, string_null_test.mc, já criados durante os
           testes do item 2) -- eles só podem ocorrer no fim do arquivo ou
           precisam de um byte 0x00 real, que não dá para digitar num editor
           de texto comum. Revisei o conteúdo gerado e confirmei que reflete
           exatamente os requisitos da Seção 4.1 do enunciado. Compilei e
           rodei ambos os arquivos: test.mc não apresentou nenhum erro
           inesperado, e test_errors.mc reportou exatamente os erros
           esperados, nas linhas certas, com as mensagens certas, e o código
           válido após os erros foi reconhecido normalmente.

---

Ferramenta: Claude (Claude Code / Sonnet 5)
Trecho: verificação de completude da especificação léxica (item TODO(aluno)
        6 -- toda entrada possível deve corresponder a alguma regra)
Finalidade: pedi para verificar, de forma sistemática, se a especificação em
            microc.flex estava completa (nenhuma entrada deveria causar
            comportamento indefinido do Flex), conforme exigido no
            enunciado.
O que fiz: a IA analisou os 3 estados do scanner (INITIAL, COMMENT, STRING)
           e confirmou que cada um tem uma regra "coringa" (".") cobrindo
           qualquer caractere não tratado por regras mais específicas, além
           das regras dedicadas para quebra de linha e EOF em cada estado --
           concluindo que a especificação já estava completa por construção,
           desde que eu seguisse o mesmo padrão dos exemplos prontos (o que
           de fato segui em todos os itens anteriores). Para validar isso na
           prática (não só analisar o código), a IA testou caracteres ainda
           não exercitados (":", "?", "\" solto fora de string/char) e, mais
           rigorosamente, gerou um arquivo com TODOS os 254 valores de byte
           possíveis (exceto o byte 0) concatenados e confirmou que o
           executável processa o arquivo inteiro sem travar, sem loop
           infinito e sem crash. Os dois arquivos usados só para esse teste
           de força bruta (não fazem sentido como caso de teste legível)
           foram apagados depois; os casos ":" e "?" foram incorporados como
           linhas extras no tests/test_errors.mc, já que são exemplos válidos
           de caracteres inválidos e ajudam a cobertura do item 5.
