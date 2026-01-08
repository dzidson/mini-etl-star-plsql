# Mini ETL – model STAR (Oracle + PL/SQL)

Projekt edukacyjny przedstawiający budowę mini-hurtowni danych
w modelu STAR oraz prosty proces ETL realizowany w Oracle PL/SQL.

Dane przechodzą przez warstwę stagingu, następnie zasilają tabele
wymiarów (DIM) oraz tabelę faktów (FACT).


## Zakres projektu

- model danych STAR:
  - DIM_CUSTOMER
  - DIM_PRODUCT
  - DIM_DATE
  - FACT_SALES
- warstwa STAGING dla danych surowych
- proces ETL (staging → dimensions → fact)
- logowanie przebiegu ETL oraz błędów
- przykładowe dane testowe


## Struktura repozytorium

- `sql/schema` – definicje tabel (STAGING, DIM, FACT)
- `sql/data` – dane testowe (INSERT do stagingu)
- `sql/packages` – logika ETL (pakiety PL/SQL)
- `sql/scripts` – skrypty uruchomieniowe / demo
- `docs` – dokumentacja projektu i opis modelu


## Warstwa STAGING

Warstwa stagingu przechowuje dane surowe dokładnie w takiej postaci,
w jakiej trafiają z systemu źródłowego.

Celem stagingu jest:
- oddzielenie danych źródłowych od modelu analitycznego,
- umożliwienie walidacji i kontroli jakości danych,
- zapewnienie możliwości audytu i debugowania procesu ETL.


## Proces ETL

1. Załadowanie danych surowych do tabel stagingowych
2. Przetworzenie i deduplikacja danych wymiarów (DIM)
3. Zasilenie tabeli faktów (FACT_SALES)
4. Rejestracja statystyk i błędów procesu ETL


## Uruchomienie projektu

1. Utwórz użytkownika w Oracle (np. `etl_user`)
2. Uruchom skrypty z katalogu `sql/schema`
3. Załaduj dane testowe z `sql/data`
4. Skompiluj pakiety ETL z `sql/packages`
5. Uruchom skrypt demo z `sql/scripts`

## Cele projektu

- zrozumienie modelu danych STAR
- poznanie architektury hurtowni danych
- praktyczna realizacja procesu ETL
- praca z PL/SQL (procedury, pakiety)
- kontrola jakości danych i logowanie ETL
