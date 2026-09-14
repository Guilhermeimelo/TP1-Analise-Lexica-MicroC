// test.mc - Programa de teste para o scanner de Micro C
//
// Este arquivo exercita boa parte dos tokens da linguagem: palavras
// reservadas, identificadores, constantes inteiras, de caractere e de
// string, operadores aritmeticos, relacionais e logicos, simbolos de
// pontuacao, alem de comentarios de linha e de bloco.
//
// LEMBRETE: este teste NAO cobre todos os casos (em especial, poucos
// casos de erro lexico). Parte do trabalho e ampliar este arquivo com
// testes proprios que exercitem seu scanner de forma mais completa,
// incluindo entradas invalidas (veja a Secao 4.1 do enunciado).

/* Calcula o fatorial de um numero inteiro utilizando um laco for. */
int fatorial(int n) {
    int resultado;
    int i;

    resultado = 1;
    for (i = 1; i <= n; i = i + 1) {
        resultado = resultado * i;
    }
    return resultado;
}

int main() {
    int x;
    int y;
    char c;
    char letras[10];

    x = 5;
    y = fatorial(x);

    if (y > 100) {
        print("Resultado grande");
    } else {
        print("Resultado pequeno");
    }

    c = 'A';
    letras[0] = 'H';
    letras[1] = 'i';

    // Testando operadores relacionais e logicos
    if (x >= 0 && y != 0) {
        print("x e nao-negativo e y e diferente de zero");
    }

    if (x == 5 || y == 0) {
        print("condicao ou satisfeita");
    }

    if (!(x < 0)) {
        print("x nao e negativo");
    }

    // Testando constantes inteiras negativas vs. operador de subtracao
    x = -10;
    y = x - 3;
    y = 0 - x;
    y = 3 - -4;

    // Testando os operadores aritmeticos que faltavam (MOD e DIV de verdade,
    // fora do contexto de comentario)
    y = x % 3;
    y = x / 2;

    // Testando string vazia e sequencias de escape dentro de string
    print("");
    print("linha\ncom\ttab e aspas \\\" escapadas");

    // Testando constante de caractere com escape
    c = '\n';
    c = '\t';
    c = '\\';

    return 0;
}
