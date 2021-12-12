# Repo-Compilador
Repositório para desenvolvimento do compilador da cadeira de Compiladores - S7

#Documentação
Escopo:
    inicio = Onde comeca o código;
    fim = Fim do código

    Exemplo:
        inicio
            código
        fim
        
Tipos de variáveis:
    float = Tipo inteiro;
    ## - Todas os numerais são tratados como flutuantes.

    Exemplo:
        inicio
            float E_var2 = 12.5
        fim

Declaração de variável:
    E_var = Toda variável começa com o caracter "E_".

    Exemplo:
        inicio
            float E_var1 = 15.25
        fim

Entrada e saída de dados:
    scan(E_var) = Leitura de dados(E_var: variável);
    print(E_var) = saída de dados(E_var: variável);

    Exemplo: 
        inicio
            float E_var
            scan(E_var)
            print(E_var)
        fim

Operações e atribuição:
    +, -, *, / = Operadores aritméticos;
    () = precedência
    ^ = exponenciação;
    # = raiz quadrada;
    '=' = atribuição.

    Exemplo: 
        inicio
            float E_var
            E_var = (5+5)*3/3
            float E_pot = 2^2
            float E_raiz = #16
            print(E_var)
            print(E_pot)
            print(E_raiz)
        fim
