CREATE TABLE stg_sales_raw (
    src_sale_id    VARCHAR2(50),
    sale_date      DATE,
    customer_name  VARCHAR2(200),
    customer_email VARCHAR2(200),
    product_code   VARCHAR2(50),
    product_name   VARCHAR2(200),
    quantity       NUMBER(12,2),
    unit_price     NUMBER(12,2),
    store_name     VARCHAR2(200),
    -- kolumny techniczne 
    load_id        NUMBER, --ktora paczka jest ładowana
    load_dts       TIMESTAMP DEFAULT SYSTIMESTAMP, -- kiedy paczka została załadowana
    source_system  VARCHAR2(50) -- z jakiego sytemu 
);
