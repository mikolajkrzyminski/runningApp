Instrukcja obsługi klas z przyrostu SPI-4
=========================================

Autor: Mikołaj Krzymiński

Data: 13.04.2021

Wersja: 1.0
<!-- -->
=========================================
### Struktura projektu

#### Drzewo struktury projektu

 lib\
 |---managers\
 |&nbsp; &nbsp;|------------db\_manager.dart\
 |&nbsp; &nbsp;|------------run\_manager.dart\
 |---models\
 |&nbsp; &nbsp;|---------geolocation\_model.dart\
 |&nbsp; &nbsp;|---------run\_model.dart\
 |---pages\
 |&nbsp; &nbsp;|-------training\_page.dart\
 |---main.dart

#### Tworzenie kodu źródłowego

Kod źródłowy tworzymy w katalogu lib, zgodnie ze strukturą
Fluttera i konwencją Dart:
[*https://dart.dev/guides/language/effective-dart/style*](https://dart.dev/guides/language/effective-dart/style).

### Odpowiedzialności stworzonych klas

#### Katalog Managers:

##### 1. db\_manager.dart

- Jest klasą utworzoną przy pomocy wzorca singleton. Aby
    korzystać ze wszystkich możliwość tej klasy wystarczy
    utworzyć obiekt typu DbManager. Konstruktor klasy woła
    skrypt łączący się z lokalną, sqlite-ową bazą danych.
    Dodatkowo, na potrzeby testów konstruktor przy pomocy
    prywatnej metody _delete usuwa (jeśli istnieje)
    poprzednio utworzoną bazę danych.

- Przykład utworzenia obietku DbManager w pliku
    training_page.dart w metodzie initState.

- Klasa udostępnia na zewnątrz metody addGeolocation i
    addRun, za ich pomocą dodajemy do bazy kolejne wpisy.

- Metody _inserGeolocation i _insertRun wołane w
    metodach addGeolocation i addRun, umieszczają wpisy w
    bazie danych.
    
- Metoda _getGeolocations, na razie służy do testów i
    pozwala odczytać wszystkie zapisane geolocatory.

##### 2. run\_manager.dart

- Zawiera dwie klasy

###### 2.1.  RunManager
 
- Zbudowany na podstawie wzorca singleton.

- Jest odpowiedzialny za rejestrację wszystkiego co związane z obecnym biegiem użytkownika

- Pole bool-owe _isRunning zawiera informacje o tym
    czy użytkownik w danej chwili jest w trakcie biegu.

- Publiczna metoda changeState, wołana w przypadku
    zdarzenia rozpoczęcia i końca rejestrowania
    geolokalizacji (przycisk START/STOP
    z training_page). Na podstawie stanu z prywatnego
    atrybutu _isRunning, wywołuje metodę _startRun,
    albo _endRun.

- _startRun dodaje nowy bieg do bazy danych i
    uruchamia metodę _startStream

- _endRun zamyka stream i wypisuje wszystkie
    geolocatory z wszystkich biegów z bazy danych na
    konsolę (cele testowe).

-  Metoda _startStream zawiera w sobie informacje na
    temat ustawień pobierania informacji z GPS i otwiera
    strumień pobierający dane z GPS-a użytkownika. Każdy
    nowy geolocator trafia od razu do bazy danych z
    odpowiednim runId. Obserwator jest informowany o
    każdym nowym geolocatorze pobranym ze streama.

###### 2.2. RunObserver 
- odpowiedzialny za obserwowanie zmian (nowych geolocatorów) w obiekcie RunManager.

- Stworzony po to aby oddzielić logikę biznesową,
        rejestrację treningu od widoku i rysowania mapy.

- Implementowany jest przez trainingPage.

#### Katalog Models:

##### 1. geolocation\_model.dart

-  Posiada statyczne atrybuty z nazwami kolumn w
   bazie danych. Chodzi o to, żeby nazwy kolumn z tabeli
   były zebrane w jednym miejscu, jako stałe.

-  Posiada nazwę tabeli, do której ma być wpisany.

-  Posiada skrypt tworzący tabelę, do której
   jest wpisywany.

-  Jego atrybuty, są równoważne ze wszystkimi atrybutami,
   które pozyskujemy z obiektu Position (geolocatora)
   pozyskanego każdorazowo z GPS-a za pomocą streama i
   dodatkowy atrybut _id, czyli id biegu.

-  Model zawiera metody fromMap, który z bazodanowej krotki
   tworzy obiekt GeolocationModel.

-  Metoda toMap zwraca Mapę, którą można zapisać w
   bazie danych.

-  Metoda toString tworzy tekst, który jest
   reprezentacją obiektu.

##### 2. run\_model.dart

-  Podobnie jak w geolocation_model, poza metodą toString

#### Katalog Pages:

-  Tu będziemy trzymać wszystkie widoki stron, np. settings\_page, my\_account\_page, strength\_page itp..

##### 1. training\_page.dart

-  Implementuje RunObserver, by wiedzieć o zmianach w
   obiekcie RunManager.

-  Jest Flutterowym StatefulWidgetem.

-  Tworzy obiekt RunManager, któremu przekazuje w
   parametrze siebie jako obserwatora.

-  Jej klasa stanu za pomocą zintegrowanego API FlutterMap
   potrafi narysować mapę i trasę z podawanych przez obiekt
   RunManager pozycji użytkownika.

-  Ma przycisk START/STOP, którym rozpoczyna i kończy bieg.
