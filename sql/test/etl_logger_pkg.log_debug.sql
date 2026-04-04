BEGIN
    etl_logger_pkg.log_debug(
        p_load_id        => 1,
        p_process_name   => 'ETL_SALES',
        p_procedure_name => 'LOAD_DIM_DATE',
        p_message        => 'Zakończono procedurę LOAD_DIM_DATE'
    );
END;
/