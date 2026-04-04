--do wykonania z uzytkownika sys
CREATE OR REPLACE DIRECTORY D_ETL_LOG AS 'C:\etl\log';
GRANT READ, WRITE ON DIRECTORY D_ETL_LOG TO etl_user;


