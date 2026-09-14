// tests/test_errors.mc - Casos de erro lexico para o scanner de Micro C
//
// Cobre os erros descritos na Secao 4.1 do enunciado que podem ocorrer no
// meio do arquivo, sem encerrar o processamento (o scanner deve reportar o
// erro e continuar reconhecendo tokens normalmente depois dele).
//
// Os erros que só podem ocorrer no FIM do arquivo (EOF em string, EOF em
// comentario) estao em arquivos separados, ja que por definicao nao pode
// haver mais conteudo depois deles:
//   - string_eof_test.mc
//   - eof_comment_test.mc
// O erro de caractere nulo dentro de string tambem esta separado
// (string_null_test.mc), porque precisa de um byte 0x00 de verdade no
// arquivo, que nao da pra digitar num editor de texto comum.

int x;

// Caracteres invalidos: nao pertencem a nenhum token de Micro C
x = 1 @ 2;
x = 3 # 4;
x = 5 $ 6;
x = 7 ^ 8;
x = 9 ` 0;
x = 1 ~ 2;
x = 1 : 2;
x = 1 ? 2;

// String nao terminada (quebra de linha antes do fechamento)
x = "string sem fechar
x = 2;

// Constante de caractere malformada
x = '';
x = 'ab';
x = 'y;

// Fechamento de comentario sem abertura correspondente
*/
x = 3;

// Depois de todos os erros acima, o scanner deve continuar reconhecendo
// tokens normalmente (recuperacao de erro) -- se estas linhas nao
// aparecerem corretamente na saida, algum erro anterior "vazou" e afetou
// o resto do arquivo.
int y;
y = x + 1;
