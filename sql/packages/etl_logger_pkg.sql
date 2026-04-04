CREATE OR REPLACE PACKAGE etl_logger_pkg AS
    PROCEDURE log_debug (
        p_load_id        IN NUMBER,
        p_process_name   IN VARCHAR2,
        p_procedure_name IN VARCHAR2,
        p_message        IN VARCHAR2
    );

    PROCEDURE log_error (
        p_load_id        IN NUMBER,
        p_process_name   IN VARCHAR2,
        p_procedure_name IN VARCHAR2,
        p_message        IN VARCHAR2
    );
END etl_logger_pkg;
/
CREATE OR REPLACE PACKAGE BODY etl_logger_pkg AS

    PROCEDURE write_log (
        p_load_id        IN NUMBER,
        p_process_name   IN VARCHAR2,
        p_procedure_name IN VARCHAR2,
        p_message        IN VARCHAR2,
        p_log_type       IN VARCHAR2
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;

        v_directory_name t_params.param_value%TYPE;
        v_file_mask      t_params.param_value%TYPE;
        v_file_name      VARCHAR2(500);
        v_log_line       VARCHAR2(4000);
        v_dt             VARCHAR2(20);
        v_log_time       VARCHAR2(20);
        v_file_handle    UTL_FILE.FILE_TYPE;
        v_log_file_id    t_log_file.log_file_id%TYPE;
    BEGIN
        v_directory_name := etl_util_pkg.get_param('LOG_DIRECTORY');
        v_file_mask      := etl_util_pkg.get_param('LOG_FILE_MASK');

        v_dt       := TO_CHAR(SYSDATE, 'YYYYMMDD');
        v_log_time := TO_CHAR(SYSDATE, 'HH24:MI:SS');

        v_file_name := v_file_mask;
        v_file_name := REPLACE(v_file_name, '{LOG_TYPE}', p_log_type);
        v_file_name := REPLACE(v_file_name, '{PROCESS_NAME}', p_process_name);
        v_file_name := REPLACE(v_file_name, '{PROCEDURE_NAME}', p_procedure_name);
        v_file_name := REPLACE(v_file_name, '{TS}', v_dt);

        v_log_line := '['
                      || v_log_time
                      || '] '
                      || p_message;

        INSERT INTO t_log_file (
            load_id,
            process_name,
            procedure_name,
            log_type,
            directory_name,
            file_name,
            status,
            message_count,
            created_at
        ) VALUES (
            p_load_id,
            p_process_name,
            p_procedure_name,
            p_log_type,
            v_directory_name,
            v_file_name,
            'CREATED',
            0,
            SYSDATE
        ) RETURNING log_file_id INTO v_log_file_id;

        v_file_handle := UTL_FILE.FOPEN(v_directory_name, v_file_name, 'A');
        UTL_FILE.PUT_LINE(v_file_handle, v_log_line);
        UTL_FILE.FCLOSE(v_file_handle);

        UPDATE t_log_file
           SET status        = 'WRITTEN',
               message_count = 1,
               closed_at     = SYSDATE
         WHERE log_file_id   = v_log_file_id;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(
                'ERROR CODE: ' || SQLCODE || ' MESSAGE: ' || SQLERRM
            );

            BEGIN
                UTL_FILE.FCLOSE(v_file_handle);
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;

            BEGIN
                UPDATE t_log_file
                   SET status    = 'FAILED',
                       closed_at = SYSDATE
                 WHERE log_file_id = v_log_file_id;

                COMMIT;
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;
    END write_log;


    PROCEDURE log_debug (
        p_load_id        IN NUMBER,
        p_process_name   IN VARCHAR2,
        p_procedure_name IN VARCHAR2,
        p_message        IN VARCHAR2
    ) IS
    BEGIN
        write_log(
            p_load_id        => p_load_id,
            p_process_name   => p_process_name,
            p_procedure_name => p_procedure_name,
            p_message        => p_message,
            p_log_type       => 'DEBUG'
        );
    END log_debug;


    PROCEDURE log_error (
        p_load_id        IN NUMBER,
        p_process_name   IN VARCHAR2,
        p_procedure_name IN VARCHAR2,
        p_message        IN VARCHAR2
    ) IS
    BEGIN
        write_log(
            p_load_id        => p_load_id,
            p_process_name   => p_process_name,
            p_procedure_name => p_procedure_name,
            p_message        => p_message,
            p_log_type       => 'ERROR'
        );
    END log_error;

END etl_logger_pkg;
/