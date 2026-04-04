BEGIN
    etl_logger_pkg.log_error(
        p_load_id        => 1,
        p_process_name   => 'ETL_SALES',
        p_procedure_name => 'LOAD_DIM_DATE',
        p_message        => 'TEST_ERROR'
    );
END;
/