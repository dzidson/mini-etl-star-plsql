2# Dokumentacja mapowania ETL – Mini hurtownia STAR

## 1. Cel dokumentu
Dokument opisuje mapowanie danych z tabeli staging `stg_sales_raw`
do modelu gwiazdy (STAR) obejmującego:
- `DIM_CUSTOMER`
- `DIM_PRODUCT`
- `DIM_DATE`
- `FACT_SALES`

Dokument stanowi podstawę implementacji procesu ETL w PL/SQL.

## 2. Źródło danych (STAGING)

Tabela: `stg_sales_raw`  
Dane sprzedażowe pochodzą z różnych systemów źródłowych
(np. POS, API, pliki płaskie w formatach CSV, XML, JSON)
i są ładowane do warstwy staging w postaci paczek
identyfikowanych przez `load_id`.

Proces ingestu zakłada, że jedna paczka (`load_id`) zawiera dane z jednego źródła.


## 3. Reguły globalne ETL

GR-01 – Przetwarzanie paczkami
ETL przetwarza dane dla jednego `load_id`.

GR-02 – Normalizacja danych 
Pola tekstowe są czyszczone (`TRIM`), puste wartości traktowane jako NULL.

GR-03 – Obsługa błędów  
Rekordy niespełniające walidacji są odrzucane i zapisywane do logów błędów.
Błędy pojedynczych rekordów nie przerywają całej paczki.


## 4. Walidacje wejściowe (STAGING)

- `sale_date` NOT NULL  
- `product_code` NOT NULL  
- `quantity > 0`  
- `unit_price > 0`  

## 5. Mapowanie STAGING -> DIM_CUSTOMER

Tabela docelowa: `DIM_CUSTOMER`
Klucze
- Surrogate key: `customer_key` (GENERATED AS IDENTITY)
- Klucz biznesowy: `customer_id`

### Tabela mapowania

| STAGING COLUMN | DIM_CUSTOMER COLUMN | Transformacja / Reguła |
|---------------|---------------------|------------------------|
| source_system | customer_id | bez zmian |
| customer_name | customer_name | TRIM |
| (stała) | segment | np. 'UNKNOWN' |

### Reguły
- deduplikacja po `customer_id`
- jeśli klient istnieje -> brak insertu
- jeśli nie istnieje -> insert nowego rekordu

## 6. Mapowanie STAGING -> DIM_PRODUCT

Tabela docelowa: `DIM_PRODUCT`
Klucze
- Surrogate key: `product_key` (GENERATED AS IDENTITY)
- Klucz biznesowy: `product_id`

### Tabela mapowania

| STAGING COLUMN | DIM_PRODUCT COLUMN | Transformacja / Reguła |
|---------------|--------------------|------------------------|
| product_code | product_id | TRIM |
| product_name | product_name | TRIM |
| (opcjonalnie) | category | wartość domyślna / reguła |

### Reguły
- deduplikacja po `product_id`
- brak produktu → insert do DIM_PRODUCT

## 7. Mapowanie STAGING -> DIM_DATE

Tabela docelowa: `DIM_DATE`

Klucz
- `date_key` w formacie YYYYMMDD

### Tabela mapowania

| STAGING COLUMN | DIM_DATE COLUMN | Transformacja / Reguła |
|---------------|-----------------|------------------------|
| sale_date | calendar_date | bez zmian |
| sale_date | date_key | TO_NUMBER(TO_CHAR(sale_date, 'YYYYMMDD')) |
| sale_date | year | EXTRACT(YEAR FROM sale_date) |
| sale_date | month | EXTRACT(MONTH FROM sale_date) |
| sale_date | month_name | TO_CHAR(sale_date, 'MONTH') |
| sale_date | day | EXTRACT(DAY FROM sale_date) |
| sale_date | day_of_week | TO_CHAR(sale_date, 'DAY') |
| sale_date | is_weekend | CASE WHEN TO_CHAR(sale_date,'DY','NLS_DATE_LANGUAGE=ENGLISH') IN ('SAT','SUN') THEN 'Y' ELSE 'N' END |

### Reguły
- każda unikalna data sprzedaży musi istnieć w DIM_DATE
- brak daty → rekord błędny

## 8. Mapowanie STAGING -> FACT_SALES

Tabela docelowa: `FACT_SALES`

### Klucze obce
- `customer_key` -> DIM_CUSTOMER
- `product_key` -> DIM_PRODUCT
- `date_key` -> DIM_DATE

### Tabela mapowania

| STAGING COLUMN | FACT_SALES COLUMN | Transformacja / Reguła |
|---------------|-------------------|------------------------|
| quantity | quantity | bez zmian |
| quantity, unit_price | amount | quantity * unit_price |
| (lookup) | customer_key | lookup DIM_CUSTOMER |
| (lookup) | product_key | lookup DIM_PRODUCT |
| (lookup) | date_key | lookup DIM_DATE |

### Reguły
- FACT ładowany po wymiarach
- brak lookupu do któregokolwiek wymiaru → rekord odrzucony

## 9. Kolejność ładowania

1. DIM_CUSTOMER  
2. DIM_PRODUCT  
3. DIM_DATE  
4. FACT_SALES  

## 10. Podsumowanie
Proces ETL przekształca dane surowe ze stagingu
do modelu STAR, zapewniając deduplikację wymiarów,
walidację danych oraz spójność referencyjną tabeli faktów.
