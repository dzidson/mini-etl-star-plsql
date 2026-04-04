BEGIN
    INSERT INTO t_params (
        param_name,
        param_value,
        param_desc,
        is_active,
        created_at
    ) VALUES ( 'LOG_DIRECTORY',
               'D_ETL_LOG',
               'Oracle DIRECTORY dla logów',
               'Y',
               sysdate );

    INSERT INTO t_params (
        param_name,
        param_value,
        param_desc,
        is_active,
        created_at
    ) VALUES ( 'LOG_FILE_MASK',
               '{LOG_TYPE}_{PROCESS_NAME}_{PROCEDURE_NAME}_{TS}.log',
               'Maska pliku logów',
               'Y',
               sysdate );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        NULL;
END;
/