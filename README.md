# Mini ETL - model STAR (Oracle + PL/SQL)

Projekt edukacyjny: budowa mini-hurtowni danych w modelu STAR
oraz proces ETL (staging -> dimensions -> fact).

## Struktura
- `sql/schema` - definicje tabel (DIM + FACT)
- `sql/data` - dane testowe
- `sql/packages` - logika ETL (PL/SQL)
- `sql/scripts` - skrypty pomocnicze
- `docs` - dokumentacja projektu

## Uruchomienie
1. Utwórz użytkownika w Oracle (np. `etl_user`)
2. Uruchom po kolei skrypty z `sql/schema`
3. odpal ETL z pakietu PL/SQL

## Cele projektu
- zrozumienie modelu STAR
- zrozumienie działania hurtowni
- staging -> DIM -> FACT
- budowa ETL w PL/SQL (procedury/pakiety)
- logowanie ETL i kontrola jakości danych
