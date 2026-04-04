CREATE OR REPLACE PACKAGE etl_util_pkg as
    FUNCTION get_param(p_param_name VARCHAR2) RETURN VARCHAR2;
END etl_util_pkg;

/


CREATE OR REPLACE PACKAGE BODY etl_util_pkg as

    e_bad_param EXCEPTION;
    e_active_no EXCEPTION;

    FUNCTION get_param(p_param_name IN VARCHAR2) RETURN VARCHAR2 IS
        v_param_value t_params.param_value%type;
        v_active t_params.is_active%type;
    BEGIN
        SELECT tp.param_value, tp.is_active
        into v_param_value, v_active
        FROM t_params tp
        WHERE tp.param_name = p_param_name;

        if v_active = 'N' then
            raise e_active_no;
        END IF;

        RETURN v_param_value;

        EXCEPTION 
            WHEN e_active_no then 
                DBMS_OUTPUT.PUT_LINE('e_active_no: ' || p_param_name || ' jest nieaktywny');
                RAISE;
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('e_bad_param: ' || p_param_name || ' ERROR CODE: ' || SQLCODE || ' MESSAGE: ' || SQLERRM);
                RAISE e_bad_param;
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR CODE: ' || SQLCODE || ' MESSAGE: ' || SQLERRM);
                RAISE;

    END get_param;

end etl_util_pkg;

/
