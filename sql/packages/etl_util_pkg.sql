CREATE OR REPLACE PACKAGE etl_util_pkg AS
    FUNCTION get_param (
        p_param_name VARCHAR2
    ) RETURN VARCHAR2;

    FUNCTION get_log_file_id (
        p_file_name IN VARCHAR2,
        p_log_type  IN VARCHAR2
    ) RETURN NUMBER;

END etl_util_pkg;

CREATE OR REPLACE PACKAGE BODY etl_util_pkg AS

    e_bad_param EXCEPTION;
    e_active_no EXCEPTION;

    FUNCTION get_param (
        p_param_name IN VARCHAR2
    ) RETURN VARCHAR2 IS
        v_param_value t_params.param_value%TYPE;
        v_active      t_params.is_active%TYPE;
    BEGIN
        SELECT
            tp.param_value,
            tp.is_active
        INTO
            v_param_value,
            v_active
        FROM
            t_params tp
        WHERE
            tp.param_name = p_param_name;

        IF v_active = 'N' THEN
            RAISE e_active_no;
        END IF;
        RETURN v_param_value;
    EXCEPTION
        WHEN e_active_no THEN
            dbms_output.put_line('e_active_no: '
                                 || p_param_name
                                 || ' jest nieaktywny');
            RAISE;
        WHEN no_data_found THEN
            dbms_output.put_line('e_bad_param: '
                                 || p_param_name
                                 || ' ERROR CODE: '
                                 || sqlcode
                                 || ' MESSAGE: '
                                 || sqlerrm);

            RAISE e_bad_param;
        WHEN OTHERS THEN
            dbms_output.put_line('ERROR CODE: '
                                 || sqlcode
                                 || ' MESSAGE: '
                                 || sqlerrm);
            RAISE;
    END get_param;

    FUNCTION get_log_file_id (
        p_file_name IN VARCHAR2,
        p_log_type  IN VARCHAR2
    ) RETURN NUMBER IS
        v_id t_log_file.log_file_id%TYPE;
    BEGIN
        SELECT
            lf.log_file_id
        INTO v_id
        FROM
            t_log_file lf
        WHERE
                lf.log_type = p_log_type
            AND lf.file_name = p_file_name;

        IF v_id IS NULL THEN
            RETURN NULL;
        ELSE
            RETURN v_id;
        END IF;
    END get_log_file_id;

END etl_util_pkg;