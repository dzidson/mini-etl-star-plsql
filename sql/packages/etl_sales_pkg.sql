CREATE OR REPLACE PACKAGE etl_sales_pkg AS
    -- Główna procedura uruchamiająca ETL dla jednej paczki
    PROCEDURE run_etl (p_load_id IN NUMBER);
    -- Ładowanie wymiarów
    PROCEDURE load_dim_date (p_load_id IN NUMBER);
    PROCEDURE load_dim_customer (p_load_id IN NUMBER);
    PROCEDURE load_dim_product (p_load_id IN NUMBER);
    -- Ładowanie tabeli faktów
    PROCEDURE load_fact_sales (p_load_id IN NUMBER);
END etl_sales_pkg;
/
