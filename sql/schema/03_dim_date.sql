CREATE TABLE dim_date (
    date_key        NUMBER PRIMARY KEY,   -- np. 20260106
    calendar_date   DATE,                 -- prawdziwa data
    year            NUMBER,
    month           NUMBER,
    month_name      VARCHAR2(20),
    day             NUMBER,
    day_of_week     VARCHAR2(20),
    is_weekend      CHAR(1)               -- 'Y' lub 'N'
);
