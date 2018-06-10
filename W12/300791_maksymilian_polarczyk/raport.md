# Raport do zadań z pracowni #2

### Autor: Maksymilian Polarczyk
### Numer indeksu: 300791

Konfiguracja
---

Informacje o systemie:

 * Dystrybucja: Linux Mint 18.3 Sylvia
 * Jądro systemu: 4.10.0-38-generic
 * Kompilator: gcc (Ubuntu 5.4.0-6ubuntu1~16.04.5) 5.4.0 20160609
 * Procesor: Intel(R) Core(TM) i5-4690K CPU @ 3.50GHz (effective 4.30GHz)
 * Liczba rdzeni: 4

Pamięć podręczna:

 * L1d: 32 KiB, 8-drożny (per rdzeń), rozmiar linii 64B
 * L2: 256 KiB, 8-drożny (per rdzeń), rozmiar linii 64B
 * L3: 6144KiB, 12-drożny (współdzielony), rozmiar linii 64B

Pamięć TLB:

 * L1d: 4KiB strony, 4-drożny, 64 wpisy
 * L2: 4KiB strony, 4-drożny, 64 wpisów

Informacje o pamięciach podręcznych uzyskano na podstawie wydruku programu
`x86info`, `lshw`, `cpuid`

Zadanie 1
---
Program zostal odpalony w kazdej wersji dla rozmiarow macierzy: 48 ,128, 256, 512, 768, 1024
Srednie czasy wykonania zamieszczone sa w pliku `datasheet.dat`.
Roznice w czasie mnozenia macierzy w roznych wersjach wynikaja ze sposobu dostepu do pamieci podrecznej cache:
 w wersji ijk ladujemy wiersz macierzy A do cache, ale przy dostepach do B mamy duza szanse na cache-miss przy dostepie kolumnowym, co daje duze opoznienie przy dostepach do komorek.
 wersja jki wykorzystuje fakt, ze macierz dwu wymiarowa to jedno ciagle miejsce w pamieci, i mozna sprowadzac cale wiersze do cache. Wykorzystujemy wiec macierz A i B optymalnie przechodzac wierszami,
 bo korzystaja z tego samego wiersza az do zmiany wiersza. Oczywiscie Jesli dlugosc tablicy jest wieksza niz dlugosc lini cache, generujemy miss i niepotrzebne ladowanie tego co juz bylo z B 
 w przejsciu do kolejnego wiersza A (po to jest wersja kafelkowa, ktora wykorzystuje bloki o bokach dlugosci linii, zeby maksymalnie wykorzystac linie przed jej wyrzuceniem)
Rozmiary kafelkow sa powiazane z rozmiarami cache i najoptymalniej dzialaja jesli 3 kafelki mieszcza sie w cache (3BLOCK^2 < C)

zadanie 2
---

zadanie 3
---
BLOCK=4  => 4x szybciej
BLOCK=8  => 5x szybciej
BLOCK=16 => 4x szybciej
BLOCK=32 => 2.5x szybciej
BLOCK=64 => 2.5x szybciej

Najszybciej dziala, gdy rozmiar kafelka jest blisko 2B^2=C, poniwaz chcemy miec 2 kafelki (source, destination) 
Czasy odpalenia programu z roznymi rozmiarami macierzy nie pomaga zidentyfikowac rozmiarow cache, w kazdym wypadku
rozniece i stosunki sa podobne.

zadanie 4
---
Przed optymalizacja: 11 instrukcji warunkowych
Po optymalizacji: 6 instrukcji warunkowych, 45 instrukcji wewnatrz petli
Mimo zniejszenia ilosci instrukcji warunkowych, program nie zyskal drastycznie na szybkosci - wyniki poprawily sie okolo 20%(+-5%)
Jedyny wplyw rozmiaru tablicy na dlugosc dzialania programu, to mozliwosc zakonczenia sie szybciej gdy wyjdziemy poza dozwolone granice. W wypadku poruszania sie co jeden w losowa strone nie ma to wielkiego znaczenia.

zadanie 5
---
Drzewo przeszukiwan binarnych charakteryzuje sie dobro lokalnoscia przestrzenna wyzszych poziomow - po zaladowaniu wierzcholka, mamy w juz linie w cache odpowiadajaca nastepnym pozioma drzewa, przez co dostep nich jest natychmiastowy. W porownaniu z logarytmicznym czasem dzialania programu i pojemnosci cache okolo log(n) poziomow cache otrzymujemy piorunujaco szybki dostep do danych. 
