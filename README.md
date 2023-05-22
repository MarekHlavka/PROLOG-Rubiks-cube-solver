# FLP Logický projekt 2022/2023 - Rubikova kostka v jazyce PROLOG
## Marek Hlávka - xhlavk09

## Návod k použití
### Přeložení
Program lze přeložit pomocí přiloženého Makefile příkazem make
### Spuštění
Program lze spustin následujícím způsobem:\
./flp22-log [-d] [-h]\
            "-d" - s tímto přepínačem program tiskne informace o svém běhu v průběhu řešení\
            "-h" - tiskne standartní pomocný text\
            \
            Tyto argumenty jsou navíc oproti zadání, ale nejsou potřebné ke spuštění samotného programu.
            \
            \
        Program akceptuje zamíchané kostky ze standartního vstupu v následujícím formátu:\
            555\
            555\
            555\
            111 222 333 444\
            111 222 333 444\
            111 222 333 444\
            666\
            666\
            666\
        , kde 5 vrchní strana, 1,2,3 a 4 jsou přední, pravá, zadní a levá strana v tomto pořadí. 6 je spodní strana 

## Popis použité metody řešení
### Algoritmus
Program používá dvousměrný iterativní DFS algoritmus. To znamená že na začátku vygeneruje hledaný cílová stav. Toto je možné z důvodu absence tahů kostky, které by hýbaly středy stran. Na vstupu algoritmu tedy je vstupní zamíchaná kostka a cílová kostka. Algoritmmus poté střídavě rozgenerovává tahy z těchto dvou kostkek postupně to iterovaně zvětšené délky. Což znamená že pokud není nalezeno řešení délky 2, tak se hledná dílka 3, poté 4 atd. Pokud algoritmus najde takovou kostku že je nalezena cesta z obou výchozích stavů, tak tyto cesty spojí a je nalezeno řešení.\
\
Obousměrný algorimtus byl použit ze snahy eliminovat prohledání stavů, které by v daném rozsahu nemohly najít řešení.
### Kódování kostky
Kódování kostky je jednoduchý 6x3x3 3D list, v pořadí [5,1,2,3,4,6] (podle sekce Spuštění). Je to z důvodu že je potřeba si zachovat informaci o každém políčku. Není to nejefektivnější způsob, ale nenapadlo mě mnoho lepších (např kažkou stranu jako jedno konrétní číslo).
### Převzaté parsování vstupů
Soubor "input2.pl" byl převzat ze stránek předmětu FLP.\
autor: Martin Hyrs\
ihyrs@fit.vutbr.cz

## Spuštění s vlastními vstupy
Vlastní vstupy jsou ve složce "Tests/" s názvem "in_XX.txt", k většině je také uveden správný výstup v souboru "out_XX.txt". Doby výpočtu jsou uvedeny pozděěji v tabulce. "XX" značí počet tahů potřebných k vyřešení dané kostky.

## Rozšíření
Jak již bylo uvedeno, program má dva volitelné argumenty "-d" a "-h", jejich účel již byl popsán v sekci Spuštění.
\
\
Dále je taky v souboru "solve.pl" zakomentován algoritmus bez obousměrného procházení mmožných tahů. Jeho správnost je úplně stejná, avšak je pomalejší.
\
\
V souboru "cube_moves.pl" je zakomentovávno posledních 6 možnách tahů. Tyto tahy simulují otočení kostky o 180 stupňů, avšak jsem se rozhodl je zakomentovat z důvodu obrovského dopadu na výkon programu. Díky dalším 6 tahům se stupeň větvení stavového prostoru změní z asi 12^N na 18^N, kde N je délka hledaného řešení a tento fakt mmá drastický dopad na časy programu, byť může za určitých okolností nalézt kratší řešení. Přibližné časy výpočtu jsou v následující tabulce:


| Počet potřebných tahů 	| Alg. bez 180 stupnových  tahů (ms) 	| Alg. s 180 stupnovými  tahy (ms) 	|
|-----------------------	|------------------------------------	|----------------------------------	|
| in_01.txt             	|0                                   	|0                              	|
| in_02.txt             	|6                                  	|7                                  |
| in_03.txt             	|24                                 	|62                               	|
| in_04.txt             	|578                                 	|2 849                             	|
| in_05.txt             	|5 038                                 	|34 889                            	|
| in_06.txt             	|39 114                                 |382 044                           	|
| in_07.txt             	|636 194                               	|neměřeno                          	|
