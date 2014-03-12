--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.0
-- Dumped by pg_dump version 9.3.1
-- Started on 2014-03-12 15:09:11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 3224 (class 1262 OID 12870)
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'pt_BR.UTF-8' LC_CTYPE = 'pt_BR.UTF-8';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 3225 (class 1262 OID 12870)
-- Dependencies: 3224
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- TOC entry 361 (class 3079 OID 20678)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3228 (class 0 OID 0)
-- Dependencies: 361
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 360 (class 3079 OID 23789)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 3229 (class 0 OID 0)
-- Dependencies: 360
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET search_path = public, pg_catalog;

--
-- TOC entry 383 (class 1255 OID 23798)
-- Name: hex_to_int(character varying); Type: FUNCTION; Schema: public; Owner: consulta
--

CREATE FUNCTION hex_to_int(hexval character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
   result  int;
BEGIN

 EXECUTE 'SELECT x''' || hexval || '''::integer' INTO result; 

 RETURN result;
 
END; $$;


ALTER FUNCTION public.hex_to_int(hexval character varying) OWNER TO consulta;

--
-- TOC entry 384 (class 1255 OID 23799)
-- Name: sp_assistec_insert(integer, smallint, character varying, character varying, character, character, character, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_assistec_insert(arg_cod_cr integer, arg_cod_deposito smallint, arg_str_relatorio character varying, arg_obs character varying, arg_cod_prod character, arg_cod_prod2 character, arg_serial character, arg_op_num integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	r1 tb_assis_tec.cod_assistec%TYPE;
	--registro RECORD;
BEGIN
-- select sp_assistec_insert(0,int2(0),'','','011187','','')

/*	SELECT INTO registro 
	 tb_produto.cod_prod
	   FROM 
	     public.tb_produto
	       WHERE 
	          tb_produto.str_ean = arg_cod_prod; */

	--IF FOUND THEN
		INSERT INTO tb_assis_tec(cod_assistec,
			cod_cr,
			cod_deposito,
			datah,
			str_relatorio,
			obs, 
			cod_prod,
			cod_prod2,
			serial, op_num)
		VALUES (DEFAULT,
			arg_cod_cr,
			arg_cod_deposito,
			DEFAULT,
			arg_str_relatorio,
			arg_obs, 
			arg_cod_prod,
			arg_cod_prod2,
			arg_serial, arg_op_num)
		RETURNING cod_assistec INTO r1; -- retorna o numero gerado PrimaryKey
	--ELSE 
	--	r1 := 0;
	--END IF;
	RETURN r1;
END;
$$;


ALTER FUNCTION public.sp_assistec_insert(arg_cod_cr integer, arg_cod_deposito smallint, arg_str_relatorio character varying, arg_obs character varying, arg_cod_prod character, arg_cod_prod2 character, arg_serial character, arg_op_num integer) OWNER TO postgres;

--
-- TOC entry 433 (class 1255 OID 5475854)
-- Name: sp_assistec_sa(integer, character, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_assistec_sa(arg_cod_cr integer, arg_serial character, arg_str_sa character varying, arg_obs character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	r1 tb_assis_tec.cod_assistec%TYPE;
	registro RECORD;
BEGIN
-- select sp_assistec_sa(2093, 'B2B642', 'Teste' , 'Teste' )

-- consulta produto pelo serial e op:
	SELECT INTO registro  
	  tb_produto.cod_prod, tb_op.op
	    FROM tb_op_nunser, tb_op , tb_produto
	      where 
	        decode(arg_serial, 'hex')  >=  decode(nroserieini, 'hex') and 
	          decode(arg_serial, 'hex')  <=  decode(nroseriefim, 'hex') and 
	            tb_op_nunser.nroop = tb_op.op and
		      tb_op.item like tb_produto.str3 || '%'
		      and str3 <> '';

	IF FOUND THEN
		INSERT INTO tb_assis_tec(cod_assistec,
			cod_cr,
			cod_deposito,
			datah,
			cod_prod,
			serial,
			op_num,
			obs)
		VALUES (DEFAULT,
			arg_cod_cr,
			0,
			DEFAULT,
			registro.cod_prod,
			arg_serial, 
			registro.op,
			arg_obs)
		RETURNING cod_assistec INTO r1; -- retorna o numero gerado PrimaryKey


		INSERT INTO tb_assistec_rep(
		cod_assistec, cod_tp_defeito, cod_sintoma, cod_comp, pos_comp, 
		str_sa, tipo_montagem, datareg)
		VALUES (r1, 40, 24, 'MISC', 0, 
		arg_str_sa, 'S', DEFAULT);


	ELSE 
		RAISE EXCEPTION 'Produto do Serial Nao encontrado';
	END IF;

	RETURN r1;

END;
$$;


ALTER FUNCTION public.sp_assistec_sa(arg_cod_cr integer, arg_serial character, arg_str_sa character varying, arg_obs character varying) OWNER TO postgres;

--
-- TOC entry 385 (class 1255 OID 23800)
-- Name: sp_consulta(character, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_consulta(arg_cod_prod character, arg_dt1 character varying, arg_dt2 character varying) RETURNS TABLE(f1 character, f2 text, f3 bigint, f4 bigint, f5 numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN

	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT cod_prod, to_char(datah, 'DD/MM/YY') as dia, count(distinct(serial,cod_status)) as status FROM tb_registro --nok
	WHERE
		cod_prod LIKE '%' || arg_cod_prod || '%' AND
		datah BETWEEN TO_timestamp(arg_dt1 || ' 00:00:00','DD/MM/YYYY HH24:MI:SS') 
			  AND TO_timestamp(arg_dt2 || ' 23:59:59','DD/MM/YYYY HH24:MI:SS') 
		AND cod_status >= 1	 
	GROUP BY cod_prod, to_char(datah, 'DD/MM/YY')
	ORDER BY cod_prod, to_char(datah, 'DD/MM/YY');

	CREATE TEMP TABLE tb2 ON COMMIT DROP AS
	SELECT cod_prod, to_char(datah, 'DD/MM/YY')as dia, count(distinct(serial,cod_status)) as status FROM tb_registro 
	WHERE
		cod_prod LIKE '%' || arg_cod_prod || '%' AND
		datah BETWEEN TO_timestamp(arg_dt1 || ' 00:00:00','DD/MM/YYYY HH24:MI:SS') 
			  AND TO_timestamp(arg_dt2 || ' 23:59:59','DD/MM/YYYY HH24:MI:SS') 
		AND cod_status = 0
	GROUP BY cod_prod, to_char(datah, 'DD/MM/YY')
	ORDER BY cod_prod, to_char(datah, 'DD/MM/YY');

--SELECT * FROM tb1 where not exists (select 1 from tb2 where tb2.dia = tb1.dia)  -- Pega os que não tem na outra tabela 			
		RETURN QUERY 
		SELECT tb1.cod_prod,tb1.dia,tb1.status as nok,tb2.status as ok, ((tb2.status * 100.0) / (tb1.status + tb2.status)) as yield 
			FROM tb1 LEFT OUTER JOIN tb2 using(cod_prod,dia)
		UNION (SELECT cod_prod,dia,0,status, 100.0 FROM tb2 where not exists (select 1 from tb1 where tb1.dia = tb2.dia))
		ORDER BY cod_prod,dia
		;


/*
	RETURN QUERY 
	SELECT 
	tb1.cod_prod,tb1.dia,tb1.nok,tb2.ok, ((tb2.ok * 100.0) / (tb1.nok + tb2.ok)) as percentu
	FROM tb1,tb2 WHERE
	tb1.cod_prod = tb2.cod_prod 
	AND	tb1.dia = tb2.dia 
	;

	RETURN QUERY 
(SELECT tb1.cod_prod,tb1.dia,tb1.nok,tb2.ok, ((tb2.ok * 100.0) / (tb1.nok + tb2.ok)) as percentu FROM tb1 left  JOIN tb2 using(cod_prod,dia))
	;
	*/
END;
$$;


ALTER FUNCTION public.sp_consulta(arg_cod_prod character, arg_dt1 character varying, arg_dt2 character varying) OWNER TO postgres;

--
-- TOC entry 389 (class 1255 OID 23801)
-- Name: sp_consulta2(character, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_consulta2(arg_cod_prod character, arg_dt1 character varying) RETURNS TABLE(f1 character, f2 text, f3 bigint, f4 bigint, f5 numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
--  SELECT sp_consulta2('100','11/2011');
--  SELECT sp_consulta('356','01/10/2011','30/10/2011');

	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT cod_prod, to_char(datah, 'DD/MM/YY') as dia, count(distinct(serial,cod_status)) as status  FROM tb_registro --nok
	WHERE
		cod_prod LIKE '%' || arg_cod_prod || '%' 
		AND date_trunc('month',  datah) =  TO_timestamp(arg_dt1,'MM/YYYY')
		AND cod_status >= 1
	GROUP BY cod_prod, dia
	ORDER BY cod_prod, dia;

	CREATE TEMP TABLE tb2 ON COMMIT DROP AS
	SELECT cod_prod, to_char(datah, 'DD/MM/YY')as dia, count(distinct(serial,cod_status)) as status FROM tb_registro 
	WHERE
		cod_prod LIKE '%' || arg_cod_prod || '%' 
		AND date_trunc('month',  datah) =  TO_timestamp(arg_dt1,'MM/YYYY')
		AND cod_status = 0
	GROUP BY cod_prod, dia
	ORDER BY cod_prod, dia;

--SELECT * FROM tb1 where not exists (select 1 from tb2 where tb2.dia = tb1.dia)  -- Pega os que não tem na outra tabela 			
		RETURN QUERY 
		SELECT tb1.cod_prod,tb1.dia,tb1.status as nok,tb2.status as ok, ((tb2.status * 100.0) / (tb1.status + tb2.status)) as yield 
			FROM tb1 LEFT OUTER JOIN tb2 using(cod_prod,dia)
		UNION (SELECT cod_prod,dia,0,status, 100.0 FROM tb2 where not exists (select 1 from tb1 where tb1.dia = tb2.dia))
		ORDER BY cod_prod,dia
		;


END;
$$;


ALTER FUNCTION public.sp_consulta2(arg_cod_prod character, arg_dt1 character varying) OWNER TO postgres;

--
-- TOC entry 390 (class 1255 OID 23802)
-- Name: sp_consulta2_media(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_consulta2_media() RETURNS TABLE(f2 date, f3 bigint, f4 bigint, f5 numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
--  SELECT sp_consulta2_Media();

	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT  
	--cast(to_char(datah, '01/MM/YY')  AS TIMESTAMP) as dia,
	--to_char(datah, 'MM/YY') as dia,
	--date_trunc('month',datah) as dia,
	to_date(to_char(datah, 'MM/YY'), 'MM/YY') as dia,
	 count(distinct(serial,cod_status)) as status  FROM tb_registro --nok
	WHERE
		 cod_status >= 1
	GROUP BY  dia
	ORDER BY  dia desc
	LIMIT 6
	;

	CREATE TEMP TABLE tb2 ON COMMIT DROP AS
	SELECT 
	--cast(to_char(datah, '01/MM/YY')  AS TIMESTAMP) as dia,
	--to_char(datah, 'MM/YY') as dia,
	--date_trunc('month',datah) as dia,
	to_date(to_char(datah, 'MM/YY'), 'MM/YY') as dia,
	 count(distinct(serial,cod_status)) as status FROM tb_registro 
	WHERE
		cod_status = 0
	GROUP BY  dia
	ORDER BY  dia desc
	LIMIT 6
	;

		RETURN QUERY 
		SELECT tb1.dia,tb1.status as nok,tb2.status as ok, ((tb2.status * 100.0) / (tb1.status + tb2.status)) as yield 
			FROM tb1 LEFT OUTER JOIN tb2 using(dia)
		UNION (SELECT dia,0,status, 100.0 FROM tb2 where not exists (select 1 from tb1 where tb1.dia = tb2.dia))
		ORDER BY dia desc
		;

END;
$$;


ALTER FUNCTION public.sp_consulta2_media() OWNER TO postgres;

--
-- TOC entry 391 (class 1255 OID 23803)
-- Name: sp_consulta2_media(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_consulta2_media(arg_gmp integer) RETURNS TABLE(f2 date, f3 bigint, f4 bigint, f5 numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
--  SELECT sp_consulta2_Media(200);

	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT  
	--cast(to_char(datah, '01/MM/YY')  AS TIMESTAMP) as dia,
	--to_char(datah, 'MM/YY') as dia,
	--date_trunc('month',datah) as dia,
	to_date(to_char(datah, 'MM/YY'), 'MM/YY') as dia,
	 count(distinct(serial,cod_status)) as status  FROM tb_registro --nok
	WHERE
		 cod_status >= 1 AND cod_gmp = arg_gmp
	GROUP BY  dia
	ORDER BY  dia desc
	LIMIT 6
	;

	CREATE TEMP TABLE tb2 ON COMMIT DROP AS
	SELECT 
	--cast(to_char(datah, '01/MM/YY')  AS TIMESTAMP) as dia,
	--to_char(datah, 'MM/YY') as dia,
	--date_trunc('month',datah) as dia,
	to_date(to_char(datah, 'MM/YY'), 'MM/YY') as dia,
	 count(distinct(serial,cod_status)) as status FROM tb_registro 
	WHERE
		cod_status = 0 AND cod_gmp = arg_gmp
	GROUP BY  dia
	ORDER BY  dia desc
	LIMIT 6
	;

		RETURN QUERY 
		SELECT tb1.dia,tb1.status as nok,tb2.status as ok, ((tb2.status * 100.0) / (tb1.status + tb2.status)) as yield 
			FROM tb1 LEFT OUTER JOIN tb2 using(dia)
		UNION (SELECT dia,0,status, 100.0 FROM tb2 where not exists (select 1 from tb1 where tb1.dia = tb2.dia))
		ORDER BY dia desc
		;

END;
$$;


ALTER FUNCTION public.sp_consulta2_media(arg_gmp integer) OWNER TO postgres;

--
-- TOC entry 392 (class 1255 OID 23804)
-- Name: sp_consulta2_media(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_consulta2_media(arg_gmp integer, arg_prod character varying) RETURNS TABLE(f2 date, f3 bigint, f4 bigint, f5 numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
--  SELECT sp_consulta2_media(110,'011036');

	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT  
	--cast(to_char(datah, '01/MM/YY')  AS TIMESTAMP) as dia,
	--to_char(datah, 'MM/YY') as dia,
	--date_trunc('month',datah) as dia,
	to_date(to_char(datah, 'MM/YY'), 'MM/YY') as dia,
	 count(distinct(serial,cod_status)) as status  FROM tb_registro --nok
	WHERE
		 cod_status >= 1 AND cod_gmp = arg_gmp AND cod_prod like arg_prod
	GROUP BY  dia
	ORDER BY  dia desc
 	LIMIT 6
	;

	CREATE TEMP TABLE tb2 ON COMMIT DROP AS
	SELECT 
	--cast(to_char(datah, '01/MM/YY')  AS TIMESTAMP) as dia,
	--to_char(datah, 'MM/YY') as dia,
	--date_trunc('month',datah) as dia,
	to_date(to_char(datah, 'MM/YY'), 'MM/YY') as dia,
	 count(distinct(serial,cod_status)) as status FROM tb_registro 
	WHERE
		cod_status = 0 AND cod_gmp = arg_gmp AND cod_prod like arg_prod
	GROUP BY  dia
	ORDER BY  dia desc
	LIMIT 6
	;

		RETURN QUERY 
		SELECT tb1.dia,tb1.status as nok,tb2.status as ok, ((tb2.status * 100.0) / (tb1.status + tb2.status)) as yield 
			FROM tb1 LEFT OUTER JOIN tb2 using(dia)
		UNION (SELECT dia,0,status, 100.0 FROM tb2 where not exists (select 1 from tb1 where tb1.dia = tb2.dia))
		ORDER BY dia desc
		;

END;
$$;


ALTER FUNCTION public.sp_consulta2_media(arg_gmp integer, arg_prod character varying) OWNER TO postgres;

--
-- TOC entry 393 (class 1255 OID 23805)
-- Name: sp_consulta2_totais(character, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_consulta2_totais(arg_cod_prod character, arg_dt1 character varying, arg_gmp integer) RETURNS TABLE(f2 text, f3 bigint, f4 bigint, f5 numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
--  SELECT sp_consulta2_Totais('','4/2012',-1);
--  SELECT sp_consulta('356','01/10/2011','30/10/2011');

IF arg_gmp <> -1 THEN

	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT  to_char(datah, 'DD/MM/YY') as dia, count(distinct(serial,cod_status)) as status  FROM tb_registro --nok
	WHERE
		cod_prod LIKE '%' || arg_cod_prod || '%' 
		AND date_trunc('month',  datah) =  TO_timestamp(arg_dt1,'MM/YYYY')
		AND cod_status >= 1
		AND cod_gmp = arg_gmp
	GROUP BY  dia
	ORDER BY  dia;

	CREATE TEMP TABLE tb2 ON COMMIT DROP AS
	SELECT  to_char(datah, 'DD/MM/YY')as dia, count(distinct(serial,cod_status)) as status FROM tb_registro 
	WHERE
		cod_prod LIKE '%' || arg_cod_prod || '%' 
		AND date_trunc('month',  datah) =  TO_timestamp(arg_dt1,'MM/YYYY')
		AND cod_status = 0
		AND cod_gmp = arg_gmp
	GROUP BY  dia
	ORDER BY  dia;

ELSE

	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT  to_char(datah, 'DD/MM/YY') as dia, count(distinct(serial,cod_status)) as status  FROM tb_registro --nok
	WHERE
		cod_prod LIKE '%' || arg_cod_prod || '%' 
		AND date_trunc('month',  datah) =  TO_timestamp(arg_dt1,'MM/YYYY')
		AND cod_status >= 1
	GROUP BY  dia
	ORDER BY  dia;

	CREATE TEMP TABLE tb2 ON COMMIT DROP AS
	SELECT  to_char(datah, 'DD/MM/YY')as dia, count(distinct(serial,cod_status)) as status FROM tb_registro 
	WHERE
		cod_prod LIKE '%' || arg_cod_prod || '%' 
		AND date_trunc('month',  datah) =  TO_timestamp(arg_dt1,'MM/YYYY')
		AND cod_status = 0
	GROUP BY  dia
	ORDER BY  dia;
END IF;

	RETURN QUERY 
	SELECT tb1.dia,tb1.status as nok,tb2.status as ok, round(((tb2.status * 100.0) / (tb1.status + tb2.status)),2) as yield 
		FROM tb1 LEFT OUTER JOIN tb2 using(dia)
	UNION (SELECT dia,0,status, 100.0 FROM tb2 where not exists (select 1 from tb1 where tb1.dia = tb2.dia))
	ORDER BY dia;

END;
$$;


ALTER FUNCTION public.sp_consulta2_totais(arg_cod_prod character, arg_dt1 character varying, arg_gmp integer) OWNER TO postgres;

--
-- TOC entry 436 (class 1255 OID 7932695)
-- Name: sp_consulta2_totais3(character, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_consulta2_totais3(arg_cod_prod character, arg_dt1 character varying, arg_dt2 character varying, arg_gmp integer) RETURNS TABLE(f2 text, f3 bigint, f4 bigint, f5 numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
--  SELECT * from sp_consulta2_Totais3('','13/9/2013','13/09/2013',110);
-- usado no consulta gerencia web
IF arg_gmp <> -1 THEN

	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT  to_char(datah, 'DD/MM/YY') as dia, count(distinct(serial,cod_status)) as status  FROM tb_registro --nok
	WHERE
		cod_prod LIKE '%' || arg_cod_prod || '%' 
		AND date_trunc('day',  datah) >=  TO_timestamp(arg_dt1,'dd/MM/YYYY')
		AND date_trunc('day',  datah) <=  TO_timestamp(arg_dt2,'dd/MM/YYYY')
		AND cod_status >= 1
		AND cod_gmp = arg_gmp
	GROUP BY  dia
	ORDER BY  dia;

	CREATE TEMP TABLE tb2 ON COMMIT DROP AS
	SELECT  to_char(datah, 'DD/MM/YY')as dia, count(distinct(serial,cod_status)) as status FROM tb_registro 
	WHERE
		cod_prod LIKE '%' || arg_cod_prod || '%' 
		AND date_trunc('day',  datah) >=  TO_timestamp(arg_dt1,'dd/MM/YYYY')
		AND date_trunc('day',  datah) <=  TO_timestamp(arg_dt2,'dd/MM/YYYY')
		AND cod_status = 0
		AND cod_gmp = arg_gmp
	GROUP BY  dia
	ORDER BY  dia;

ELSE

	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT  to_char(datah, 'DD/MM/YY') as dia, count(distinct(serial,cod_status)) as status  FROM tb_registro --nok
	WHERE
		cod_prod LIKE '%' || arg_cod_prod || '%' 
		AND date_trunc('day',  datah) >=  TO_timestamp(arg_dt1,'dd/MM/YYYY')
		AND date_trunc('day',  datah) <=  TO_timestamp(arg_dt2,'dd/MM/YYYY')
		AND cod_status >= 1
	GROUP BY  dia
	ORDER BY  dia;

	CREATE TEMP TABLE tb2 ON COMMIT DROP AS
	SELECT  to_char(datah, 'DD/MM/YY')as dia, count(distinct(serial,cod_status)) as status FROM tb_registro 
	WHERE
		cod_prod LIKE '%' || arg_cod_prod || '%' 
		AND date_trunc('day',  datah) >=  TO_timestamp(arg_dt1,'dd/MM/YYYY')
		AND date_trunc('day',  datah) <=  TO_timestamp(arg_dt2,'dd/MM/YYYY')
		AND cod_status = 0
	GROUP BY  dia
	ORDER BY  dia;
END IF;

	RETURN QUERY 
	SELECT tb1.dia,tb1.status as nok,tb2.status as ok, round(((tb2.status * 100.0) / (tb1.status + tb2.status)),2) as yield 
		FROM tb1 LEFT OUTER JOIN tb2 using(dia)
	UNION (SELECT dia,0,status, 100.0 FROM tb2 where not exists (select 1 from tb1 where tb1.dia = tb2.dia))
	ORDER BY dia;

END;
$$;


ALTER FUNCTION public.sp_consulta2_totais3(arg_cod_prod character, arg_dt1 character varying, arg_dt2 character varying, arg_gmp integer) OWNER TO postgres;

--
-- TOC entry 386 (class 1255 OID 23806)
-- Name: sp_consulta3(character, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_consulta3(arg_cod_prod character, arg_dt1 character varying) RETURNS TABLE(f1 character, f2 text, f3 bigint, f4 bigint, f5 bigint, f6 numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
--  SELECT sp_consulta2('11120','1/2012');
--  SELECT sp_consulta3('11120','1/2012');
--  SELECT sp_consulta('11120','01/01/2012','30/01/2012');

-- Conta Seriais c/status = ok, que não possuem NOK:
	CREATE TEMP TABLE tb0 ON COMMIT DROP AS
	SELECT a.cod_prod, to_char(a.datah, 'DD/MM/YY') as dia, count(distinct(a.serial)) as status FROM tb_registro a    
	WHERE    
		cod_prod LIKE '%' || arg_cod_prod || '%'    
		AND date_trunc('month',  datah) =  TO_timestamp(arg_dt1,'MM/YYYY')    
		AND cod_status = 0    
		AND    
		not exists (SELECT 1 FROM tb_registro where cod_status = 1 AND a.serial = serial and date_trunc('day',  a.datah) = date_trunc('day',  datah) )  
	GROUP BY cod_prod, dia    
	ORDER BY cod_prod, dia;

-- Todos os Seriais NOK:
	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT cod_prod, to_char(datah, 'DD/MM/YY') as dia, count(distinct(serial,cod_status)) as status  FROM tb_registro --nok
	WHERE
		cod_prod LIKE '%' || arg_cod_prod || '%'
		AND date_trunc('month',  datah) =  TO_timestamp(arg_dt1,'MM/YYYY')
		AND cod_status >= 1
	GROUP BY cod_prod, dia
	ORDER BY cod_prod, dia;

		
	RETURN QUERY 
		SELECT tb0.cod_prod,tb0.dia,tb0.status as ok,tb1.status as mok,(tb1.status + tb0.status) as produzido, ((tb0.status * 100.0) / (tb1.status + tb0.status)) as yield 
		FROM tb0 LEFT OUTER JOIN tb1 using(cod_prod,dia)
	ORDER BY cod_prod,dia
	;

/* 
	RETURN QUERY 
		SELECT tb0.cod_prod,tb0.dia,tb0.status as ok,tb1.status as mok,(tb1.status + tb0.status) as produzido, ((tb0.status * 100.0) / (tb1.status + tb0.status)) as yield 
		FROM tb0 LEFT OUTER JOIN tb1 using(cod_prod,dia)
	--UNION (SELECT cod_prod,dia,0,status, 100.0 FROM tb2 where not exists (select 1 from tb1 where tb1.dia = tb2.dia))
	ORDER BY cod_prod,dia
	;
*/
END;
$$;


ALTER FUNCTION public.sp_consulta3(arg_cod_prod character, arg_dt1 character varying) OWNER TO postgres;

--
-- TOC entry 387 (class 1255 OID 23807)
-- Name: sp_consulta_asistecmap(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_consulta_asistecmap(arg_dt1 character varying) RETURNS TABLE(f1 character varying, f2 character varying, f3 numeric, f4 bigint)
    LANGUAGE plpgsql
    AS $$
DECLARE
	qtd integer;
BEGIN

-- SELECT * FROM sp_consulta_asistecmap('6/2012')

	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT  cod_tp_defeito, sum(1) as qtd
	FROM 
	tb_assistec_rep
	WHERE
	date_trunc('month',  datareg) =  TO_timestamp(arg_dt1,'MM/YYYY')
		--and	cod_prod like arg_cod_prod || '%'
	group by cod_tp_defeito;

	RETURN QUERY 
	 SELECT 
	  tb_produto.str_prod,
	  tb_tp_defeito.str_defeito,
	  round( count(tb_assistec_rep.cod_tp_defeito) * 100.0 / tb1.qtd,2) as percent,
	  count(tb_assistec_rep.cod_tp_defeito) as cont
	FROM 
	  tb_tp_defeito, 
	  tb_assistec_rep, 
	  tb_assis_tec,
	  tb_produto,
	  tb1
	WHERE 
	  tb1.cod_tp_defeito = tb_assistec_rep.cod_tp_defeito AND
	  tb_tp_defeito.cod_tp_defeito = tb_assistec_rep.cod_tp_defeito AND
	  tb_assistec_rep.cod_assistec = tb_assis_tec.cod_assistec AND
	  tb_produto.cod_prod = tb_assis_tec.cod_prod 
	  AND	  date_trunc('month',  datah) =  TO_timestamp(arg_dt1,'MM/YYYY')
	GROUP BY str_prod,str_defeito,tb1.qtd
	ORDER BY str_defeito
	;

END;$$;


ALTER FUNCTION public.sp_consulta_asistecmap(arg_dt1 character varying) OWNER TO postgres;

--
-- TOC entry 388 (class 1255 OID 23808)
-- Name: sp_consulta_assistecgraf(character, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_consulta_assistecgraf(arg_cod_prod character, arg_dt1 character varying) RETURNS TABLE(f1 bigint, f2 numeric, f3 character varying, f4 integer, f5 integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
	qtd integer;
BEGIN

-- SELECT * from sp_consulta_assistecgraf('','8/2012')

	SELECT INTO qtd count(*) from tb_assis_tec,tb_assistec_rep WHERE 
		tb_assis_tec.cod_assistec = tb_assistec_rep.cod_assistec AND
		date_trunc('month',  datah) =  TO_timestamp(arg_dt1,'MM/YYYY')
	AND  cod_prod like arg_cod_prod || '%';


	RETURN QUERY 
	SELECT 
	count(*) as cont,		-- 1
	 count(*) * 100.0 / qtd as percent, -- 2
	tb_tp_defeito.str_defeito ,		-- 3
	qtd as  total, 		-- 4
	tb_assistec_rep.cod_tp_defeito 		-- 5
	FROM 
	tb_assistec_rep, 
	tb_tp_defeito,
	tb_assis_tec
	WHERE 
	tb_assis_tec.cod_assistec = tb_assistec_rep.cod_assistec AND
	tb_tp_defeito.cod_tp_defeito = tb_assistec_rep.cod_tp_defeito and
	date_trunc('month',  datareg) =  TO_timestamp(arg_dt1,'MM/YYYY')
	and
	cod_prod like arg_cod_prod || '%'
	group by tb_assistec_rep.cod_tp_defeito,tb_tp_defeito.str_defeito
	--,total
	ORDER BY percent desc;

END;$$;


ALTER FUNCTION public.sp_consulta_assistecgraf(arg_cod_prod character, arg_dt1 character varying) OWNER TO postgres;

--
-- TOC entry 394 (class 1255 OID 23809)
-- Name: sp_consulta_componemte(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_consulta_componemte(arg_prod character varying, arg_dt1 character varying) RETURNS TABLE(f1 bigint, f2 character, f3 character varying, f4 character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
-- select * from sp_consulta_componemte('','06/2012')
	RETURN QUERY 
	SELECT  count(str_compo) as cont, cod_prod, tb_defeito.str_compo, descricao1 
	  FROM tb_defeito, tb_item
	  WHERE cod_tp_defeito = 38 AND
	  date_trunc('month',  datahora) =  TO_timestamp(arg_dt1,'MM/YYYY') AND
	  cod_prod LIKE arg_prod || '%' AND
	  tb_item.itcodigo = upper(str_compo)
	GROUP BY str_compo,descricao1,cod_prod
	ORDER BY str_compo, cod_prod;

END;$$;


ALTER FUNCTION public.sp_consulta_componemte(arg_prod character varying, arg_dt1 character varying) OWNER TO postgres;

--
-- TOC entry 432 (class 1255 OID 5534103)
-- Name: sp_consulta_componemteat(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_consulta_componemteat(arg_prod character varying, arg_dt1 character varying) RETURNS TABLE(f1 bigint, f2 character, f3 character varying, f4 character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
-- select * from sp_consulta_componemteAt('','06/2013')
RETURN QUERY 
SELECT 
	count(str_compo) as cont, cod_prod, str_compo, descricao1 
FROM 
	public.tb_assistec_rep, 
	public.tb_item, 
	public.tb_assis_tec
WHERE 
	tb_assistec_rep.cod_assistec = tb_assis_tec.cod_assistec AND
	tb_item.itcodigo = tb_assistec_rep.str_compo and
	date_trunc('month',  datah) =  TO_timestamp(arg_dt1,'MM/YYYY') AND
	cod_prod LIKE arg_prod || '%' AND
	tb_item.itcodigo = upper(str_compo) AND
	str_compo <> ''
GROUP BY str_compo,descricao1,cod_prod
ORDER BY str_compo, cod_prod
;

END;$$;


ALTER FUNCTION public.sp_consulta_componemteat(arg_prod character varying, arg_dt1 character varying) OWNER TO postgres;

--
-- TOC entry 395 (class 1255 OID 23810)
-- Name: sp_consulta_defeitos(character, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_consulta_defeitos(arg_cod_prod character, arg_dt1 character varying) RETURNS TABLE(f1 bigint, f2 numeric, f3 character varying, f4 integer, f5 integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
	qtd integer;
BEGIN

-- SELECT sp_consulta_defeitos('','3/2012')

	--CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT INTO qtd SUM(1)
	FROM 
	public.tb_defeito
	WHERE
	date_trunc('month',  datahora) =  TO_timestamp(arg_dt1,'MM/YYYY')
	and
	cod_prod like arg_cod_prod || '%';


	RETURN QUERY 
	SELECT 
	count( tb_defeito.cod_tp_defeito ) as cont, count(tb_defeito.cod_tp_defeito) * 100.0 / qtd as percent,  tb_tp_defeito.str_defeito , qtd as  total, tb_defeito.cod_tp_defeito
	FROM 
	public.tb_defeito, 
	public.tb_tp_defeito
	WHERE 
	tb_tp_defeito.cod_tp_defeito = tb_defeito.cod_tp_defeito and
	date_trunc('month',  datahora) =  TO_timestamp(arg_dt1,'MM/YYYY')
	and
	cod_prod like arg_cod_prod || '%'
	group by tb_defeito.cod_tp_defeito,tb_tp_defeito.str_defeito,total
	ORDER BY percent desc;

END;$$;


ALTER FUNCTION public.sp_consulta_defeitos(arg_cod_prod character, arg_dt1 character varying) OWNER TO postgres;

--
-- TOC entry 396 (class 1255 OID 23811)
-- Name: sp_consulta_defeitosmap(character, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_consulta_defeitosmap(arg_cod_prod character, arg_dt1 character varying) RETURNS TABLE(f1 character varying, f2 character varying, f3 numeric, f4 bigint)
    LANGUAGE plpgsql
    AS $$
DECLARE
	qtd integer;
BEGIN

-- SELECT sp_consulta_defeitosMAP('','3/2012')

	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT  cod_tp_defeito, sum(1) as qtd
	FROM 
	public.tb_defeito
	WHERE
	date_trunc('month',  datahora) =  TO_timestamp(arg_dt1,'MM/YYYY')
		--and	cod_prod like arg_cod_prod || '%'
	group by cod_tp_defeito;

--SELECT tb_tp_defeito.str_defeito from tb_tp_defeito order by str_defeito;
	RETURN QUERY 
	 SELECT 
	  --count(tb_defeito.cod_prod) as qtd,
	  tb_produto.str_prod,
	  tb_tp_defeito.str_defeito,
	  round( count(tb_defeito.cod_tp_defeito) * 100.0 / tb1.qtd,2) as percent,
	  count(tb_defeito.cod_tp_defeito) as cont
	FROM 
	  public.tb_tp_defeito, 
	  public.tb_defeito, 
	  public.tb_produto,
	  tb1
	WHERE 
	  tb1.cod_tp_defeito = tb_defeito.cod_tp_defeito AND
	  tb_tp_defeito.cod_tp_defeito = tb_defeito.cod_tp_defeito AND
	  tb_produto.cod_prod = tb_defeito.cod_prod AND
	  date_trunc('month',  datahora) =  TO_timestamp(arg_dt1,'MM/YYYY')
	GROUP BY str_prod,str_defeito,tb1.qtd
	ORDER BY str_defeito
	;

END;$$;


ALTER FUNCTION public.sp_consulta_defeitosmap(arg_cod_prod character, arg_dt1 character varying) OWNER TO postgres;

--
-- TOC entry 424 (class 1255 OID 1154815)
-- Name: sp_consulta_mediahoras(character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_consulta_mediahoras(arg_prod character varying, arg_dt1 character varying, arg_gmp integer) RETURNS TABLE(txt text, posto integer, cont bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
-- select * from sp_consulta_mediahoras('011036','11/2012',110);
	CREATE TEMP TABLE tb2 ON COMMIT DROP AS 
	SELECT 
		date_trunc('hour',datah)::text as dia,
		cod_posto,
		count(distinct(serial)) as cont		 
	FROM tb_registro  WHERE
		cod_gmp = arg_gmp
		and date_trunc('month',  datah) =  TO_timestamp(arg_dt1,'MM/YYYY') 
		AND cod_prod = arg_prod
	group by dia,cod_posto
	;

	RETURN QUERY 
	SELECT  'Min: ' || min(tb2.cont) || ' Max: ' || max(tb2.cont)  || ' Media: ' || avg(tb2.cont) as txt, 0 as posto, 0  as cont FROM tb2
	WHERE tb2.cont > 3 --AND tb2.cont < 48
	union (SELECT * from tb2 )
	order by txt, posto;

END;$$;


ALTER FUNCTION public.sp_consulta_mediahoras(arg_prod character varying, arg_dt1 character varying, arg_gmp integer) OWNER TO postgres;

--
-- TOC entry 397 (class 1255 OID 23812)
-- Name: sp_cqi_gmp_falta(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_cqi_gmp_falta(arg_serial character varying) RETURNS TABLE(f1 character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
	registro RECORD;
	qtd integer;
BEGIN
-- Retorna os GMPs que faltam testar para liberar o produto.

	RETURN QUERY
	SELECT str_gmp
	FROM 
	  public.tb_registro, 
	  tb_prod_gmp
	WHERE 
	  tb_registro.serial = arg_serial AND
	  tb_registro.cod_prod = tb_prod_gmp.cod_prod 
	  AND
	  not exists (select 1 from tb_registro where
	  tb_registro.posto_gmp LIKE tb_prod_gmp.str_gmp AND
	  tb_registro.serial = arg_serial )
	GROUP BY str_gmp, tb_prod_gmp.cod_prod;

END;
$$;


ALTER FUNCTION public.sp_cqi_gmp_falta(arg_serial character varying) OWNER TO postgres;

--
-- TOC entry 398 (class 1255 OID 23813)
-- Name: sp_cqi_gmp_falta2(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_cqi_gmp_falta2(arg_serial character varying) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$
DECLARE
	--registro RECORD;
	--qtd integer;
BEGIN
-- Retorna os GMPs que faltam testar para liberar o produto.
-- select sp_cqi_gmp_falta('ABC123')
-- select sp_cqi_gmp_falta2('ABC123')

-- funcao que conta quantos tem, filtro por cod_gmp,  e posto se for informado

	CREATE TEMP TABLE tb0 ON COMMIT DROP AS
	SELECT  cod_prod, cod_gmp,cod_posto  from tb_registro
	where
	tb_registro.serial = arg_serial 
	--AND
	--cod_prod = tb_prod_gmp.cod_prod 
	group by cod_prod,cod_gmp,cod_posto
	;

	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT cod_prod,cod_gmp, count(cod_gmp) as contgmp from tb0
	group by cod_prod,cod_gmp
	;

	RETURN QUERY
	--SELECT 'GMP-' || tb1.cod_gmp || '-' || contgmp  
	SELECT 'GMP-' || tb_prod_gmp.cod_gmp || ' Requerido: ' || tb_prod_gmp.qtd_min
	
	FROM 
	  tb1, 	
	  tb_prod_gmp
	WHERE 
	  tb1.cod_prod = tb_prod_gmp.cod_prod 
	--AND	  tb1.cod_gmp = tb_prod_gmp.cod_gmp
	AND
	  not exists (select 1 from tb1 where
	  tb1.cod_gmp = tb_prod_gmp.cod_gmp 
	  AND tb1.contgmp  >= tb_prod_gmp.qtd_min 
	  --AND	 -- 'GMP-' || cod_gmp || '-' || cod_posto LIKE tb_prod_gmp.str_gmp 	
	  )
	GROUP BY  tb_prod_gmp.cod_gmp ,contgmp,tb_prod_gmp.qtd_min

	--UNION SELECT sp_cqi_gmp_falta(arg_serial)
	
	;


END;
$$;


ALTER FUNCTION public.sp_cqi_gmp_falta2(arg_serial character varying) OWNER TO postgres;

--
-- TOC entry 399 (class 1255 OID 23814)
-- Name: sp_cqi_gmp_falta3(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_cqi_gmp_falta3(arg_serial character varying) RETURNS SETOF character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	registro RECORD;
	qtd integer;
BEGIN
-- Retorna os GMPs que faltam testar para liberar o produto.
-- select sp_cqi_gmp_falta('B1FC13')
-- select sp_cqi_gmp_falta2('ABC123')
-- select sp_cqi_gmp_falta3('ABC123')
-- não funcionou - não usar.
	RETURN QUERY
	SELECT tb_prod_gmp.str_gmp
	FROM 
	  tb_registro, 
	  tb_prod_gmp
	WHERE 
	  tb_registro.serial = arg_serial AND
	  tb_registro.cod_prod = tb_prod_gmp.cod_prod 
	  AND
	  not exists (select 1 from tb_registro where
	  'GMP-' || tb_registro.cod_gmp || '-' || tb_registro.cod_posto LIKE tb_prod_gmp.str_gmp AND
	  tb_registro.serial = arg_serial )
	GROUP BY str_gmp, tb_prod_gmp.cod_prod;

END;
$$;


ALTER FUNCTION public.sp_cqi_gmp_falta3(arg_serial character varying) OWNER TO postgres;

--
-- TOC entry 400 (class 1255 OID 23815)
-- Name: sp_cqi_gmpnok(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_cqi_gmpnok(arg_serial character varying) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$
DECLARE
	registro RECORD;
	qtd integer;
BEGIN
-- retorna os GMPs cujo status esteja NOK; Cada registro NOK deve existir um OK.
 
	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT 
	  tb_registro.serial, 
	  tb_registro.cod_gmp,
	  tb_registro.cod_posto,
	  tb_registro.datah
	FROM 
	  public.tb_registro
	WHERE  
	  cod_status >= 1 AND
	  tb_registro.serial = arg_serial; 

	CREATE TEMP TABLE tb0 ON COMMIT DROP AS
	SELECT 
	  tb_registro.serial, 
	  tb_registro.cod_gmp,
	  tb_registro.cod_posto,
	  tb_registro.datah
	FROM 
	  public.tb_registro
	WHERE 
	  cod_status = 0 AND
	  tb_registro.serial = arg_serial;

	RETURN QUERY
	SELECT 	  'GMP - ' || tb1.cod_gmp || ' - ' ||  tb1.cod_posto
	FROM tb1 WHERE
		not exists (select 1 from tb0 WHERE 
			tb1.serial = tb0.serial AND
		--	tb1.posto_gmp = tb0.posto_gmp AND -- se difere de posto
			tb0.datah >= tb1.datah);

END;
$$;


ALTER FUNCTION public.sp_cqi_gmpnok(arg_serial character varying) OWNER TO postgres;

--
-- TOC entry 401 (class 1255 OID 23816)
-- Name: sp_cqi_registro(character varying, boolean, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_cqi_registro(arg_serial character varying, arg_cqf_cqi boolean, arg_cod_cr integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	id integer;
BEGIN
	 INSERT INTO tb_cqi_registro( 
	str_serial, cqf_cqi, cod_cr, datah) 
	VALUES ( arg_serial, arg_cqf_cqi, arg_cod_cr , CURRENT_TIMESTAMP)
	RETURNING cod_cqi_reg INTO id
	;

	--GET DIAGNOSTICS id = RESULT_OID;
	RETURN id;
END;$$;


ALTER FUNCTION public.sp_cqi_registro(arg_serial character varying, arg_cqf_cqi boolean, arg_cod_cr integer) OWNER TO postgres;

--
-- TOC entry 437 (class 1255 OID 8483537)
-- Name: sp_cria_user(character, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_cria_user(arg_user character, arg_nome character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

-- SELECT * FROM  sp_cria_user ( '1234' ,'Teste')

EXECUTE
"CREATE ROLE /"" || arg_user || "/" LOGIN PASSWORD '" || arg_user ||"'
   VALID UNTIL 'infinity';
GRANT consultar TO '" || arg_user || "';
GRANT inserir TO '" || arg_user || "';
COMMENT ON ROLE '" || arg_user || "'
  IS '" || arg_nome || "';";


END;
$$;


ALTER FUNCTION public.sp_cria_user(arg_user character, arg_nome character varying) OWNER TO postgres;

--
-- TOC entry 402 (class 1255 OID 23817)
-- Name: sp_defeito_insert(character varying, character varying, integer, integer, character varying, character varying, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_defeito_insert(arg_cod_prod character varying, arg_serial character varying, arg_cod_tp_defeito integer, arg_cod_sintoma integer, arg_tipo_montagem character varying, arg_cod_comp character varying, arg_pos_comp integer, arg_cod_cr integer, str_obs character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	registro RECORD;
	qtd integer := 0;
BEGIN
-- excluir daqui um tempo...
	INSERT INTO tb_defeito(
		    cod_prod, serial, cod_tp_defeito, cod_sintoma, tipo_montagem, 
		    cod_comp, pos_comp, datahora, cod_cr, str_obs)
	    VALUES (arg_cod_prod, arg_serial, arg_cod_tp_defeito, arg_cod_sintoma, arg_tipo_montagem, 
		arg_cod_comp, arg_pos_comp,LOCALTIMESTAMP, arg_cod_cr, str_obs);

	GET DIAGNOSTICS qtd = ROW_COUNT;

	RETURN qtd;
END;
$$;


ALTER FUNCTION public.sp_defeito_insert(arg_cod_prod character varying, arg_serial character varying, arg_cod_tp_defeito integer, arg_cod_sintoma integer, arg_tipo_montagem character varying, arg_cod_comp character varying, arg_pos_comp integer, arg_cod_cr integer, str_obs character varying) OWNER TO postgres;

--
-- TOC entry 403 (class 1255 OID 23818)
-- Name: sp_defeito_insert(character varying, character varying, integer, integer, character varying, character varying, integer, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_defeito_insert(arg_cod_prod character varying, arg_serial character varying, arg_cod_tp_defeito integer, arg_cod_sintoma integer, arg_tipo_montagem character varying, arg_cod_comp character varying, arg_pos_comp integer, arg_cod_cr integer, arg_obs character varying, arg_componemte character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	registro RECORD;
	qtd integer := 0;
BEGIN

	INSERT INTO tb_defeito(
		    cod_prod, serial, cod_tp_defeito, cod_sintoma, tipo_montagem, 
		    cod_comp, pos_comp, datahora, cod_cr, str_obs,str_compo)
	    VALUES (arg_cod_prod, arg_serial, arg_cod_tp_defeito, arg_cod_sintoma, arg_tipo_montagem, 
		arg_cod_comp, arg_pos_comp,LOCALTIMESTAMP, arg_cod_cr, arg_obs,arg_componemte );

	GET DIAGNOSTICS qtd = ROW_COUNT;

	RETURN qtd;
END;
$$;


ALTER FUNCTION public.sp_defeito_insert(arg_cod_prod character varying, arg_serial character varying, arg_cod_tp_defeito integer, arg_cod_sintoma integer, arg_tipo_montagem character varying, arg_cod_comp character varying, arg_pos_comp integer, arg_cod_cr integer, arg_obs character varying, arg_componemte character varying) OWNER TO postgres;

--
-- TOC entry 404 (class 1255 OID 23819)
-- Name: sp_eficiencia(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_eficiencia(arg_dt1 character varying, arg_linha integer) RETURNS TABLE(f1 timestamp without time zone, f2 double precision, f3 double precision, min_dia integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
-- select * from sp_eficiencia('09/2012',1);
/*
	Lista 
	data | Perda em minutos | Eficiencia % / Pela Hora trabalhada.
	por dia, da linha.
-usado, Grafico WEB
*/

	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT 
	  date_trunc('day',  datah) as datah,
	  tb_qtd_produz.min_dia, 
	 (extract(epoch from(tb_qtd_parada.datah_fim - tb_qtd_parada.datah_ini))/60) as tempo
	FROM 
	  tb_qtd_produz, 
	  tb_qtd_parada
	WHERE 
	  tb_qtd_parada.cod_qtd = tb_qtd_produz.cod_qtd AND
	  date_trunc('month',  datah) =  TO_timestamp(arg_dt1,'MM/YYYY') AND
	  cod_linha = arg_linha
	ORDER BY
	  tb_qtd_produz.cod_qtd ASC;

	RETURN QUERY 
	SELECT 
		datah, 
		SUM(tempo) as perda,
		100 - (SUM(tempo)  * 100.0 / tb1.min_dia ) as eficiencia,
		tb1.min_dia
	FROM tb1
	GROUP BY datah,tb1.min_dia
	ORDER BY datah;

END;
$$;


ALTER FUNCTION public.sp_eficiencia(arg_dt1 character varying, arg_linha integer) OWNER TO postgres;

--
-- TOC entry 405 (class 1255 OID 23820)
-- Name: sp_eficiencia_lista_ops_setp(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_eficiencia_lista_ops_setp(arg_dt1 character varying, arg_lin integer) RETURNS TABLE(cod_op integer, cod_prod character varying, cod_parada character varying, datah_ini timestamp without time zone, datah_fim timestamp without time zone, tempominu double precision, obs character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN

-- select * from sp_eficiencia_lista_ops_setp('09/2012',1)

/* Retorna os tempos de cada SETP por OP */
RETURN QUERY 
SELECT 
  tb_qtd_x_oprod.cod_op, 
  tb_qtd_x_oprod.cod_prod, 
  tb_qtd_parada.cod_parada, 
  tb_qtd_parada.datah_ini, 
  tb_qtd_parada.datah_fim,
  (extract(epoch from(tb_qtd_parada.datah_fim - tb_qtd_parada.datah_ini))/60) as tempominu,
  tb_qtd_parada.str_obs
FROM 
  public.tb_qtd_x_oprod, 
  public.tb_qtd_produz, 
  public.tb_qtd_parada
WHERE 
  tb_qtd_x_oprod.cod_qtd = tb_qtd_parada.cod_qtd AND
  tb_qtd_produz.cod_qtd = tb_qtd_x_oprod.cod_qtd AND
  tb_qtd_produz.cod_linha = arg_lin AND 
  date_trunc('month',  tb_qtd_produz.datah) =  TO_timestamp(arg_dt1,'MM/YYYY') AND 
  tb_qtd_parada.cod_parada = 'SETP'
order by tb_qtd_parada.datah_ini  ;


END;$$;


ALTER FUNCTION public.sp_eficiencia_lista_ops_setp(arg_dt1 character varying, arg_lin integer) OWNER TO postgres;

--
-- TOC entry 406 (class 1255 OID 23821)
-- Name: sp_eficiencia_map(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_eficiencia_map(arg_dt1 character varying, arg_linha integer) RETURNS TABLE(cod_op integer, datah text, cod_parada character varying, tempo double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN

/*
Mapeamento de Perdas			
Por OP, Dia, Parada, 

select * from sp_eficiencia_map('9/2012',1);

-usado WEB
*/
RETURN QUERY 
SELECT 
  tb_qtd_x_oprod.cod_op, 
  to_char(tb_qtd_produz.datah,'dd/MM/yyyy') as datah,
  tb_qtd_parada.cod_parada,   
  SUM(extract(epoch from(tb_qtd_parada.datah_fim - tb_qtd_parada.datah_ini))/60)  as tempox
FROM 
  public.tb_qtd_parada, 
  public.tb_qtd_x_oprod, 
  public.tb_qtd_produz
WHERE 
  tb_qtd_parada.cod_qtd = tb_qtd_produz.cod_qtd AND
  tb_qtd_x_oprod.cod_qtd = tb_qtd_produz.cod_qtd AND
  date_trunc('month',  tb_qtd_x_oprod.datah) =  TO_timestamp(arg_dt1,'MM/YYYY')
  AND
  tb_qtd_produz.cod_linha = arg_linha
GROUP BY 
  tb_qtd_x_oprod.cod_op, 
  tb_qtd_parada.cod_parada, 
  tb_qtd_produz.datah
ORDER BY
  tb_qtd_produz.datah ASC, cod_op, cod_parada;

END;$$;


ALTER FUNCTION public.sp_eficiencia_map(arg_dt1 character varying, arg_linha integer) OWNER TO postgres;

--
-- TOC entry 407 (class 1255 OID 23822)
-- Name: sp_eficiencia_map(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_eficiencia_map(arg_dt1 text, arg_linha integer) RETURNS TABLE(cod_op integer, datah text, cod_parada character varying, tempo double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN

/*
Mapeamento de Perdas			
Por OP, Dia, Parada, 

select * from sp_eficiencia_map('9/2012',1);

- NÃO UTILIZADO, SQL direto no java.
*/
RETURN QUERY 
SELECT 
  tb_qtd_x_oprod.cod_op, 
  to_char(tb_qtd_produz.datah,'dd/MM/yyyy') as datah,
  tb_qtd_parada.cod_parada,   
  SUM(extract(epoch from(tb_qtd_parada.datah_fim - tb_qtd_parada.datah_ini))/60)  as tempox
FROM 
  public.tb_qtd_parada, 
  public.tb_qtd_x_oprod, 
  public.tb_qtd_produz
WHERE 
  tb_qtd_parada.cod_qtd = tb_qtd_produz.cod_qtd AND
  tb_qtd_x_oprod.cod_qtd = tb_qtd_produz.cod_qtd AND
  date_trunc('month',  tb_qtd_x_oprod.datah) =  TO_timestamp(arg_dt1,'MM/YYYY')
  AND
  tb_qtd_produz.cod_linha = arg_linha
GROUP BY 
  tb_qtd_x_oprod.cod_op, 
  tb_qtd_parada.cod_parada, 
  tb_qtd_produz.datah
ORDER BY
  tb_qtd_produz.datah ASC, cod_op, cod_parada;

END;$$;


ALTER FUNCTION public.sp_eficiencia_map(arg_dt1 text, arg_linha integer) OWNER TO postgres;

--
-- TOC entry 408 (class 1255 OID 23823)
-- Name: sp_eficiencia_media(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_eficiencia_media(arg_dt1 character varying) RETURNS TABLE(f1 character varying, f2 double precision, f3 numeric, f4 numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
-- select * from sp_eficiencia_media('08/2012')
	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT 
		tb_qtd_parada.cod_parada,
		(extract(epoch from(tb_qtd_parada.datah_fim - tb_qtd_parada.datah_ini))/60) as tempo
	FROM 
		tb_qtd_parada
	WHERE 
		date_trunc('month',  datah_ini) =  TO_timestamp(arg_dt1,'MM/YYYY');

	CREATE TEMP TABLE tb2 ON COMMIT DROP AS
	SELECT 
		cod_parada,
		SUM(tempo) as perda
	FROM 
		tb1
	WHERE tempo > 0 
	GROUP BY cod_parada
	ORDER BY cod_parada;

	RETURN QUERY 
	SELECT 
		cod_parada,
		perda, 
		round( CAST( perda * 100.0 / (SELECT sum(perda) FROM tb2) AS NUMERIC) ,2) as percent,
		round( CAST( perda * 100.0 / (SELECT SUM(min_dia) as total_dia FROM tb_qtd_produz WHERE date_trunc('month',  datah) =  TO_timestamp(arg_dt1,'MM/YYYY')) AS NUMERIC) ,2) as percenthora
	FROM tb2
	ORDER BY cod_parada;
END;$$;


ALTER FUNCTION public.sp_eficiencia_media(arg_dt1 character varying) OWNER TO postgres;

--
-- TOC entry 409 (class 1255 OID 23824)
-- Name: sp_eficiencia_media(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_eficiencia_media(arg_dt1 character varying, arg_linha integer) RETURNS TABLE(f1 character varying, f2 double precision, f3 numeric, f4 numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
-- select * from sp_eficiencia_media('08/2012',2)
	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
	SELECT 
		tb_qtd_parada.cod_parada,
		(extract(epoch from(tb_qtd_parada.datah_fim - tb_qtd_parada.datah_ini))/60) as tempo
	FROM 
		tb_qtd_parada, tb_qtd_produz
	WHERE
		tb_qtd_produz.cod_qtd = tb_qtd_parada.cod_qtd
		AND
		date_trunc('month',  datah_ini) =  TO_timestamp(arg_dt1,'MM/YYYY')
		AND
		tb_qtd_produz.cod_linha = arg_linha
		;
	CREATE TEMP TABLE tb2 ON COMMIT DROP AS
	SELECT 
		cod_parada,
		SUM(tempo) as perda
	FROM 
		tb1
	WHERE tempo > 0 
	GROUP BY cod_parada
	ORDER BY cod_parada;

	RETURN QUERY 
	SELECT 
		cod_parada,
		perda, 
		round( CAST( perda * 100.0 / (SELECT sum(perda) FROM tb2) AS NUMERIC) ,2) as percent,
		round( CAST( perda * 100.0 / (SELECT SUM(min_dia) as total_dia FROM tb_qtd_produz WHERE tb_qtd_produz.cod_linha = arg_linha AND date_trunc('month',  datah) =  TO_timestamp(arg_dt1,'MM/YYYY')) AS NUMERIC) ,2) as percenthora
	FROM tb2
	ORDER BY cod_parada;
END;$$;


ALTER FUNCTION public.sp_eficiencia_media(arg_dt1 character varying, arg_linha integer) OWNER TO postgres;

--
-- TOC entry 430 (class 1255 OID 5294913)
-- Name: sp_estrut_compare(character, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_estrut_compare(arg_cod_prod1 character, arg_cod_prod2 character) RETURNS TABLE(codigo character varying, descricao text)
    LANGUAGE plpgsql
    AS $$
BEGIN

-- Lista os Componentes identicos na estrutura
-- select * from sp_estrut_compare ('011053','011036');
	CREATE TEMP TABLE tb1x ON COMMIT DROP AS
		SELECT escodigo
		--itcodigo,
		--localmontag 
		FROM tb_estrutura_prod
		where itcodigo LIKE  arg_cod_prod1;

	CREATE TEMP TABLE tb2x ON COMMIT DROP AS
		SELECT tb_estrutura_prod.escodigo FROM tb_estrutura_prod,tb1x
		where tb1x.escodigo = tb_estrutura_prod.itcodigo;

	CREATE TEMP TABLE tb3x ON COMMIT DROP AS
		SELECT tb_estrutura_prod.escodigo --,a.descricao1 			|| ' / '  || b.descricao1 
		FROM tb_estrutura_prod,tb2x,tb_item a , tb_item b
		where tb2x.escodigo = tb_estrutura_prod.itcodigo
		--and tb_estrutura_prod.localmontag like '%'|| arg_local ||',%'
		and a.itcodigo = tb_estrutura_prod.escodigo
		and b.itcodigo = tb_estrutura_prod.itcodigo
		UNION (
			SELECT escodigo
			--tb2x.itcodigo,
			--localmontag,tb_item.descricao1 
			FROM tb2x,tb_item
			where tb_item.itcodigo = tb2x.escodigo --AND localmontag like '%'|| arg_local ||',%'
		)
		UNION (
			SELECT escodigo
			--tb1x.itcodigo,
			--localmontag,tb_item.descricao1 
			FROM tb1x,tb_item
			where tb_item.itcodigo = tb1x.escodigo --AND localmontag like '%'|| arg_local ||',%'
		)
		;


	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
		SELECT escodigo,itcodigo,localmontag FROM tb_estrutura_prod
		where itcodigo LIKE  arg_cod_prod2;

	CREATE TEMP TABLE tb2 ON COMMIT DROP AS
		SELECT tb_estrutura_prod.* FROM tb_estrutura_prod,tb1
		where tb1.escodigo = tb_estrutura_prod.itcodigo;

	CREATE TEMP TABLE tb3 ON COMMIT DROP AS
		SELECT tb_estrutura_prod.*,a.descricao1 
			|| ' / '  || b.descricao1 as descricao
		FROM tb_estrutura_prod,tb2,tb_item a , tb_item b
		where tb2.escodigo = tb_estrutura_prod.itcodigo
		--and tb_estrutura_prod.localmontag like '%'|| arg_local ||',%'
		and a.itcodigo = tb_estrutura_prod.escodigo
		and b.itcodigo = tb_estrutura_prod.itcodigo
		UNION (
			SELECT escodigo,tb2.itcodigo,localmontag,tb_item.descricao1 FROM tb2,tb_item
			where tb_item.itcodigo = tb2.escodigo --AND localmontag like '%'|| arg_local ||',%'
		)
		UNION (
			SELECT escodigo,tb1.itcodigo,localmontag,tb_item.descricao1 FROM tb1,tb_item
			where tb_item.itcodigo = tb1.escodigo --AND localmontag like '%'|| arg_local ||',%'
		)
		;

		RETURN QUERY 
		select tb3.escodigo,  tb3.descricao from tb3x, tb3
		where tb3x.escodigo = tb3.escodigo
		order by tb3x.escodigo;

END;
$$;


ALTER FUNCTION public.sp_estrut_compare(arg_cod_prod1 character, arg_cod_prod2 character) OWNER TO postgres;

--
-- TOC entry 431 (class 1255 OID 5306405)
-- Name: sp_estrut_compare2(character, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_estrut_compare2(arg_cod_prod1 character, arg_cod_prod2 character) RETURNS TABLE(codigo character varying, descricao text)
    LANGUAGE plpgsql
    AS $$
BEGIN


--- Nao usado --- terminar... funcao sp_estrut_compare2 mais reduzido....
-- Lista os Componentes identicos na estrutura
-- select * from sp_estrut_compare2('011276%','011259%');
	CREATE TEMP TABLE tb1x ON COMMIT DROP AS
		SELECT escodigo
		--itcodigo,
		--localmontag 
		FROM tb_estrutura_prod
		where itcodigo LIKE  '011259%';

	CREATE TEMP TABLE tb2x ON COMMIT DROP AS
		SELECT tb_estrutura_prod.escodigo FROM tb_estrutura_prod,tb1x
		where tb1x.escodigo = tb_estrutura_prod.itcodigo;

	CREATE TEMP TABLE tb3x ON COMMIT DROP AS
		SELECT tb_estrutura_prod.escodigo --,a.descricao1 			|| ' / '  || b.descricao1 
		FROM tb_estrutura_prod,tb2x --,tb_item a , tb_item b
		where tb2x.escodigo = tb_estrutura_prod.itcodigo
		--and tb_estrutura_prod.localmontag like '%'|| arg_local ||',%'
		--and a.itcodigo = tb_estrutura_prod.escodigo
		--and b.itcodigo = tb_estrutura_prod.itcodigo
		UNION (
			SELECT escodigo
			--tb2x.itcodigo,
			--localmontag,tb_item.descricao1 
			FROM tb2x --,tb_item
			--where tb_item.itcodigo = tb2x.escodigo --AND localmontag like '%'|| arg_local ||',%'
		)
		UNION (
			SELECT escodigo
			--tb1x.itcodigo,
			--localmontag,tb_item.descricao1 
			FROM tb1x --,tb_item
			--where tb_item.itcodigo = tb1x.escodigo --AND localmontag like '%'|| arg_local ||',%'
		)
		;


	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
		SELECT escodigo FROM tb_estrutura_prod
		where itcodigo LIKE  '011276'; --arg_cod_prod2;

	--CREATE TEMP TABLE tb2 ON COMMIT DROP AS
		SELECT tb_estrutura_prod.escodigo FROM tb_estrutura_prod,tb1
		where tb1.escodigo = tb_estrutura_prod.itcodigo;

	--CREATE TEMP TABLE tb3 ON COMMIT DROP AS
		SELECT tb_estrutura_prod.*,a.descricao1 
			|| ' / '  || b.descricao1 as descricao
		FROM tb_estrutura_prod,tb2,tb_item a , tb_item b
		where tb2.escodigo = tb_estrutura_prod.itcodigo
		--and tb_estrutura_prod.localmontag like '%'|| arg_local ||',%'
		and a.itcodigo = tb_estrutura_prod.escodigo
		and b.itcodigo = tb_estrutura_prod.itcodigo
		UNION (
			SELECT escodigo,tb2.itcodigo,localmontag,tb_item.descricao1 FROM tb2,tb_item
			where tb_item.itcodigo = tb2.escodigo --AND localmontag like '%'|| arg_local ||',%'
		)
		UNION (
			SELECT escodigo,tb1.itcodigo,localmontag,tb_item.descricao1 FROM tb1,tb_item
			where tb_item.itcodigo = tb1.escodigo --AND localmontag like '%'|| arg_local ||',%'
		)
		;

		RETURN QUERY 
		select tb3.escodigo,  tb3.descricao from tb3x, tb3
		where tb3x.escodigo = tb3.escodigo
		order by tb3x.escodigo;

END;
$$;


ALTER FUNCTION public.sp_estrut_compare2(arg_cod_prod1 character, arg_cod_prod2 character) OWNER TO postgres;

--
-- TOC entry 435 (class 1255 OID 7779813)
-- Name: sp_estrut_compare_reverso(character, character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_estrut_compare_reverso(arg_cod_prod1 character, arg_cod_prod2 character) RETURNS TABLE(codigo character varying, descricao character, b character varying, c character)
    LANGUAGE plpgsql
    AS $$
BEGIN

-- Lista os Componentes identicos na estrutura
-- select * from sp_estrut_compare_reverso ('011053','011036');
	CREATE TEMP TABLE tb1x ON COMMIT DROP AS
		SELECT escodigo
		FROM tb_estrutura_prod
		where itcodigo LIKE  arg_cod_prod1;

	CREATE TEMP TABLE tb2x ON COMMIT DROP AS
		SELECT tb_estrutura_prod.escodigo FROM tb_estrutura_prod,tb1x
		where tb1x.escodigo = tb_estrutura_prod.itcodigo;

	CREATE TEMP TABLE tb3x ON COMMIT DROP AS
		SELECT tb_estrutura_prod.escodigo , arg_cod_prod1 as prod
		FROM tb_estrutura_prod,tb2x
		where tb2x.escodigo = tb_estrutura_prod.itcodigo
		UNION (
			SELECT *, arg_cod_prod1 as prod
			FROM tb2x
		)
		UNION (
			SELECT *, arg_cod_prod1 as prod
			FROM tb1x
		)
		;


	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
		SELECT escodigo FROM tb_estrutura_prod
		where itcodigo LIKE  arg_cod_prod2;

	CREATE TEMP TABLE tb2 ON COMMIT DROP AS
		SELECT tb_estrutura_prod.escodigo FROM tb_estrutura_prod,tb1
		where tb1.escodigo = tb_estrutura_prod.itcodigo;

	CREATE TEMP TABLE tb3 ON COMMIT DROP AS
		SELECT tb_estrutura_prod.escodigo, arg_cod_prod2 as prod
		FROM tb_estrutura_prod,tb2
		where tb2.escodigo = tb_estrutura_prod.itcodigo
		UNION (
			SELECT *, arg_cod_prod2 as prod
			FROM tb2
		)
		UNION (
			SELECT *, arg_cod_prod2 as prod
			FROM tb1
		)
		;

		RETURN QUERY 
		 SELECT * FROM tb3 FULL OUTER JOIN tb3x ON tb3.escodigo = tb3x.escodigo ORDER BY 2,4 asc;
		 


END;
$$;


ALTER FUNCTION public.sp_estrut_compare_reverso(arg_cod_prod1 character, arg_cod_prod2 character) OWNER TO postgres;

--
-- TOC entry 410 (class 1255 OID 23825)
-- Name: sp_estrut_loc(character, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_estrut_loc(arg_cod_prod character, arg_local character varying) RETURNS TABLE(f1 character varying, f2 character varying, f3 character varying, f4 text)
    LANGUAGE plpgsql
    AS $$
BEGIN
--  select * from sp_estrut_loc('011036%','LD9')
	CREATE TEMP TABLE tb1 ON COMMIT DROP AS
		SELECT escodigo,itcodigo,localmontag FROM tb_estrutura
		where itcodigo LIKE  arg_cod_prod || '%';

	CREATE TEMP TABLE tb2 ON COMMIT DROP AS
		SELECT tb_estrutura.* FROM tb_estrutura,tb1
		where tb1.escodigo = tb_estrutura.itcodigo;

	RETURN QUERY 
		SELECT tb_estrutura.*,a.descricao1 
			|| ' / '  || b.descricao1 
		FROM tb_estrutura,tb2,tb_item a , tb_item b
		where tb2.escodigo = tb_estrutura.itcodigo
		and tb_estrutura.localmontag like '%'|| arg_local ||',%'
		and a.itcodigo = tb_estrutura.escodigo
		and b.itcodigo = tb_estrutura.itcodigo
		UNION (
			SELECT escodigo,tb2.itcodigo,localmontag,tb_item.descricao1 FROM tb2,tb_item
			where tb_item.itcodigo = tb2.escodigo AND localmontag like '%'|| arg_local ||',%'
		)
		UNION (
			SELECT escodigo,tb1.itcodigo,localmontag,tb_item.descricao1 FROM tb1,tb_item
			where tb_item.itcodigo = tb1.escodigo AND localmontag like '%'|| arg_local ||',%'
		)
		;

END;
$$;


ALTER FUNCTION public.sp_estrut_loc(arg_cod_prod character, arg_local character varying) OWNER TO postgres;

--
-- TOC entry 438 (class 1255 OID 507931)
-- Name: sp_import_op(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_import_op() RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	qtd integer;
BEGIN
-- utulizado em Script para atualizar OPs e ns.
-- select * from sp_import_OP();
-- SELECT * FROM TB_OP
	qtd = 0;
CREATE TEMP TABLE tb1 (qtd1 int) ON COMMIT DROP;

SELECT INTO qtd count(*) from tb_op_nunser;
insert into tb1 values (qtd);

	TRUNCATE tb_op_nunser;


	COPY tb_op_nunser FROM '/sfms/rs-numser.txt' DELIMITERS '|' CSV HEADER;
	
SELECT INTO qtd count(*) from tb_op_nunser;
insert into tb1 values (qtd);

SELECT INTO qtd count(*) from tb_op;
insert into tb1 values (qtd);

	TRUNCATE tb_op;
	
	COPY tb_op FROM '/sfms/ord-prod.txt' DELIMITERS '|' CSV HEADER;
	
SELECT INTO qtd count(*) from tb_op;
insert into tb1 values (qtd);

	UPDATE tb_op 
		SET  item = upper (item)
	WHERE 
		item like 'th%' or
		item like 'st%' or
		item like 'cp%' or
		item like 'mx%' or
		item like 'ae%' or
		item like 'lf%';

GET DIAGNOSTICS qtd = ROW_COUNT;
insert into tb1 values (qtd);

	-- Delete OP com Conflito:
	DELETE FROM tb_op
	WHERE op = 4546;

	DELETE FROM tb_op
	WHERE op = 4539;
	
	DELETE FROM tb_op_nunser
	WHERE nroop = 4539;

	DELETE FROM tb_op_nunser
	WHERE nroop = 4546;


	RETURN QUERY select qtd1 from tb1;

END;
$$;


ALTER FUNCTION public.sp_import_op() OWNER TO postgres;

--
-- TOC entry 411 (class 1255 OID 23826)
-- Name: sp_insert_status(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_insert_status(param_status character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$BEGIN
  INSERT INTO tb_status (status) 
  VALUES (param_status);
  return 'ok';
END;$$;


ALTER FUNCTION public.sp_insert_status(param_status character varying) OWNER TO postgres;

--
-- TOC entry 420 (class 1255 OID 30239)
-- Name: sp_op_infoser(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_op_infoser(arg_ser character varying) RETURNS TABLE(op integer, nroserieini character, nroseriefim character, item character varying, descricao character varying, data_op date, qtd_op integer)
    LANGUAGE plpgsql
    AS $$

BEGIN
/*

Informações OP e registros 
por Serial

select * from sp_op_infoser('ABC123')

*/

RETURN QUERY
	SELECT 
		nroop,
		tb_op_nunser.nroserieini, 
		tb_op_nunser.nroseriefim,
		tb_op.item,
		tb_item.descricao1,
		tb_op.data,
		tb_op.qtd
	FROM 
		tb_op_nunser, 
		tb_op, 
		tb_item 
	WHERE 
		decode(arg_ser, 'hex')  >=  decode(tb_op_nunser.nroserieini, 'hex') and 
		decode(arg_ser, 'hex')  <=  decode(tb_op_nunser.nroseriefim, 'hex') and 
		tb_op_nunser.nroop = tb_op.op AND 
		tb_item.itcodigo = tb_op.item;



END;$$;


ALTER FUNCTION public.sp_op_infoser(arg_ser character varying) OWNER TO postgres;

--
-- TOC entry 421 (class 1255 OID 1244471)
-- Name: sp_op_prev(timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_op_prev(arg_dt timestamp without time zone, arg_horas integer) RETURNS TABLE(dt_prevista timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
DECLARE
	qtd1 bigint := 0;
	cont1 bigint := 0;
	horast bigint := arg_horas;
BEGIN

/*

   Utilizado para calcular horas de produção.

   
*/

-- select * from sp_op_prev('2013-01-01 08:00'::timestamp, 48)
-- select * from sp_op_prev(localtimestamp, 8)


	CREATE TEMP TABLE tb1(timeofday text, qtd bigint) ON COMMIT DROP;

	WHILE qtd1 <= horast LOOP
		--CREATE TEMP TABLE tb1 ON COMMIT DROP; --AS
		INSERT INTO tb1 
		SELECT --to_char(diahora, 'dd/MM/yyyy hh24:mi') AS TimeOfDay,
			max(diahora)::timestamp without time zone as timeofday,
			count(diahora) as qtd
		FROM (
			SELECT  arg_dt + sequence.day * interval '1 hour' AS diahora
			FROM generate_series(0,arg_horas  + cont1) 		AS sequence(day)
			where extract(DOW FROM arg_dt + sequence.day * interval '1 hour') BETWEEN 1 and 5
			and  ( extract(hour FROM arg_dt + sequence.day * interval '1 hour') BETWEEN 8 and 11
			or   extract(hour FROM arg_dt + sequence.day * interval '1 hour') BETWEEN 13 and 17 )
			GROUP BY sequence.day
			) DQ
		order by 1;
		select max(tb1.qtd) into qtd1 from tb1;
		cont1:= cont1 + 1;
	END LOOP;

	RETURN QUERY select   max(tb1.timeofday)::timestamp without time zone from tb1;
END;
$$;


ALTER FUNCTION public.sp_op_prev(arg_dt timestamp without time zone, arg_horas integer) OWNER TO postgres;

--
-- TOC entry 427 (class 1255 OID 1315091)
-- Name: sp_op_prev2(timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_op_prev2(arg_dt timestamp without time zone, arg_horas integer) RETURNS timestamp without time zone
    LANGUAGE plpgsql
    AS $$
DECLARE
	qtd1 bigint := 0;
	cont1 bigint := 0;
	horast bigint := arg_horas;
	timeofday timestamp without time zone;
	qtd bigint:=0;

	curs1 refcursor;
BEGIN

-- select * from sp_op_prev2('2013-01-01 08:00'::timestamp, 48)
-- select * from sp_op_prev2(localtimestamp, 8)

-- SCROLL CURSOR FOR SELECT * FROM filmes;

	--CREATE TEMP TABLE tb1(timeofday text, qtd bigint) ON COMMIT DROP;

	WHILE qtd1 <= horast LOOP
		--CREATE TEMP TABLE tb1 ON COMMIT DROP; --AS
		--INSERT INTO tb1 
		OPEN curs1 FOR
		SELECT --to_char(diahora, 'dd/MM/yyyy hh24:mi') AS TimeOfDay,
			max(diahora)::timestamp without time zone as timeofday,
			count(diahora) as qtd
		FROM (
			SELECT  arg_dt + sequence.day * interval '1 hour' AS diahora
			FROM generate_series(0,arg_horas  + cont1) 		AS sequence(day)
			where extract(DOW FROM arg_dt + sequence.day * interval '1 hour') BETWEEN 1 and 5
			and  ( extract(hour FROM arg_dt + sequence.day * interval '1 hour') BETWEEN 8 and 11
			or   extract(hour FROM arg_dt + sequence.day * interval '1 hour') BETWEEN 13 and 17 )
			GROUP BY sequence.day
			) DQ
		order by 1;

		FETCH curs1 INTO timeofday, qtd;
		CLOSE curs1;

		--select max(tb1.qtd) into qtd1 from tb1;
		qtd1 := qtd;

		cont1:= cont1 + 1;

		
	END LOOP;

	RETURN timeofday;
END;
$$;


ALTER FUNCTION public.sp_op_prev2(arg_dt timestamp without time zone, arg_horas integer) OWNER TO postgres;

--
-- TOC entry 425 (class 1255 OID 29514)
-- Name: sp_op_resumo_mes(character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_op_resumo_mes(arg_mes character varying, arg_gmp integer, arg_prod character varying) RETURNS TABLE(op integer, item character varying, data_op date, nroserieini character, nroseriefim character, dt_min timestamp without time zone, dt_max timestamp without time zone, qtd_op integer, cont bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
/*
	Resumo da semana com os Dados da OP e contagem

Por mês
Por GMP
Por Produto 

*/
--   select * from sp_op_resumo_mes('12/2012', 110 , '011235' )
--   select * from sp_op_serfal(4460);
--   select * from sp_op_resumo_reg(4460);
	RETURN QUERY 
	SELECT 
		tb_op.op, 
		tb_op.item, 
		tb_op.data as data_op, 
		tb_op_nunser.nroserieini, 
		tb_op_nunser.nroseriefim,
		min(tb_registro.datah) as dt_min,
		max(tb_registro.datah) as dt_max,
		tb_op.qtd as qtd_op, 
		count(distinct tb_registro.serial) as cont
	FROM 
	  tb_op, 
	  tb_op_nunser, 
	  tb_registro
	WHERE 
	  tb_registro.datah >= TO_timestamp(arg_mes,'MM/YYYY') and 
	  tb_op.data >= TO_timestamp(arg_mes,'MM/YYYY')  and
	  tb_op_nunser.nroop = tb_op.op AND
	  tb_registro.serial >= tb_op_nunser.nroserieini AND
	  tb_registro.serial <= tb_op_nunser.nroseriefim 
	  AND tb_registro.cod_gmp = arg_gmp
	  AND tb_registro.cod_prod like arg_prod || '%'
	GROUP BY   
	  tb_op.op, 
	  tb_op.item, 
	  tb_op.qtd, 
	  tb_op.data, 
	  tb_op_nunser.nroserieini, 
	  tb_op_nunser.nroseriefim
	order by dt_max;

END;
$$;


ALTER FUNCTION public.sp_op_resumo_mes(arg_mes character varying, arg_gmp integer, arg_prod character varying) OWNER TO postgres;

--
-- TOC entry 419 (class 1255 OID 32247)
-- Name: sp_op_resumo_reg(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_op_resumo_reg(arg_op integer) RETURNS TABLE(op integer, item character varying, qtd_op integer, data_op date, nroserieini character, nroseriefim character, cont bigint, dt_min timestamp without time zone, dt_max timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN

--select * from sp_op_resumo_reg(54450);

/*
Resumo da OP, contagem dos registros desta OP.
*/

	RETURN QUERY 
	SELECT 
	  tb_op.op, 
	  tb_op.item, 
	  tb_op.qtd, 
	  tb_op.data as dada_op, 
	  tb_op_nunser.nroserieini, 
	  tb_op_nunser.nroseriefim,
	  count(distinct tb_registro.serial),
	   min(tb_registro.datah) as dt_min,
	   max(tb_registro.datah) as dt_max
	FROM 
	  tb_op, 
	  tb_op_nunser, 
	  tb_registro
	WHERE 
	  tb_op.op = arg_op
	  AND tb_op_nunser.nroop = tb_op.op 
	  AND tb_registro.serial >= tb_op_nunser.nroserieini 
	  AND tb_registro.serial <= tb_op_nunser.nroseriefim 
	  AND tb_registro.datah >= tb_op.data
	  AND tb_registro.cod_gmp = 110
	GROUP BY   
	  tb_op.op, 
	  tb_op.item, 
	  tb_op.qtd, 
	  tb_op.data, 
	  tb_op_nunser.nroserieini, 
	  tb_op_nunser.nroseriefim
	;

END;
$$;


ALTER FUNCTION public.sp_op_resumo_reg(arg_op integer) OWNER TO postgres;

--
-- TOC entry 426 (class 1255 OID 1248659)
-- Name: sp_op_resumo_reg2(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_op_resumo_reg2(arg_op integer) RETURNS TABLE(op integer, item character varying, qtd_op integer, data_op date, nroserieini character, nroseriefim character, cont bigint, dt_min timestamp without time zone, dt_max timestamp without time zone, dt_prevista timestamp without time zone, media_hora integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
	media integer:= 0;
	dtprev timestamp without time zone;
BEGIN

--select * from sp_op_resumo_reg2(53056);

/*
Resumo da OP, contagem dos registros desta OP. com previsão de término

*/

--Obtem a media de horas da op:
--	CREATE TEMP TABLE tb3 ON COMMIT DROP AS 


	CREATE TEMP TABLE tb2 ON COMMIT DROP AS 
	SELECT 
		date_trunc('hour',datah)::text as dia,
		qtd, 
		count(distinct serial) as cont
	from (
		SELECT
			tb_registro.serial, min(datah) as datah, tb_op.qtd -- filtra o primeiro serial registrado
		FROM 
			tb_op, 
			tb_op_nunser, 
			tb_registro
		WHERE 
			tb_op_nunser.nroop = tb_op.op AND
			tb_registro.serial >= tb_op_nunser.nroserieini AND
			tb_registro.serial <= tb_op_nunser.nroseriefim 
			and tb_op.op = arg_op
			and cod_gmp = 110
		GROUP BY   tb_registro.serial, tb_op.qtd
		order by tb_registro.serial
	) tb3
	GROUP BY   
		dia, qtd
	order by dia;

	SELECT 
		trunc(qtd / avg(tb2.cont))  INTO media
	FROM tb2
	GROUP BY qtd;
/*
	CREATE TEMP TABLE tb2 ON COMMIT DROP AS 
	SELECT 
		date_trunc('hour',tb_registro.datah)::text as dia,
		tb_op.qtd, 
		count(distinct tb_registro.serial) as cont
	FROM 
		tb_op, 
		tb_op_nunser, 
		tb_registro
	WHERE 
		tb_op_nunser.nroop = tb_op.op AND
		tb_registro.serial >= tb_op_nunser.nroserieini AND
		tb_registro.serial <= tb_op_nunser.nroseriefim 
		and tb_op.op = arg_op
		and cod_gmp = 110
	GROUP BY   
		dia, qtd
	order by dia;

	SELECT 
		trunc(qtd / avg(tb2.cont)) INTO media
	FROM tb2
	GROUP BY qtd;
*/
--RAISE INFO  'media hora % ', media;

	RETURN QUERY 
	SELECT 
		tb_op.op, 
		tb_op.item, 
		tb_op.qtd, 
		tb_op.data as dada_op, 
		tb_op_nunser.nroserieini, 
		tb_op_nunser.nroseriefim,
		count(distinct tb_registro.serial),
		min(tb_registro.datah) as dt_min,
		max(tb_registro.datah) as dt_max,
		(select * from sp_op_prev(min(tb_registro.datah)::timestamp, media)) as dt_prevista,
		avg(tb2.cont)::integer
	FROM 
	  tb_op, 
	  tb_op_nunser, 
	  tb_registro,tb2
	WHERE 
	  tb_op.op = arg_op
	  AND tb_op_nunser.nroop = tb_op.op 
	  AND tb_registro.serial >= tb_op_nunser.nroserieini 
	  AND tb_registro.serial <= tb_op_nunser.nroseriefim 
	  AND tb_registro.datah >= tb_op.data
	  AND tb_registro.cod_gmp = 110
	GROUP BY   
	  tb_op.op, 
	  tb_op.item, 
	  tb_op.qtd, 
	  tb_op.data, 
	  tb_op_nunser.nroserieini, 
	  tb_op_nunser.nroseriefim
	;

END;
$$;


ALTER FUNCTION public.sp_op_resumo_reg2(arg_op integer) OWNER TO postgres;

--
-- TOC entry 440 (class 1255 OID 9589063)
-- Name: sp_op_resumo_reg3(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_op_resumo_reg3(arg_op integer) RETURNS TABLE(op integer, item character varying, data_op date, nroserieini character, nroseriefim character, dt_min timestamp without time zone, dt_max timestamp without time zone, qtd_op integer, cont bigint, dt_prevista timestamp without time zone, media integer, yield numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN

--select * from sp_op_resumo_reg3(4554);

/*
Resumo da OP, contagem dos registros desta OP. com previsão de término
Atualizado 11/2013

*/


                CREATE TEMP TABLE tb0 ON COMMIT DROP AS
                SELECT 
                  *
                FROM 
                  tb_op, 
                  tb_op_nunser, 
                  tb_registro
                WHERE 
		tb_op.op = arg_op
                  AND tb_op_nunser.nroop = tb_op.op
                  AND tb_registro.serial >= tb_op_nunser.nroserieini
                  AND tb_registro.serial <= tb_op_nunser.nroseriefim 
                  AND tb_registro.datah >= tb_op.data
		--  AND tb_registro.datah >= date_trunc('week',  localtimestamp - interval  '7 day')   -- pega os registros da SEMANA!
		--  AND 	tb_op.data >= date_trunc('week',  localtimestamp - interval  '7 day')  
                  AND tb_registro.cod_gmp = 110 ;

		CREATE TEMP TABLE tb111 ON COMMIT DROP AS
		SELECT
			SUM(case when cod_status = 1 then 1 else 0 end) as nok,
			SUM(case when cod_status = 0 then 1 else 0 end) as ok, 
			tb0.op
		FROM tb0 GROUP BY tb0.op ;

		CREATE TEMP TABLE tb33 ON COMMIT DROP AS
                SELECT tb111.op,  nok, ok, round(((ok * 100.0) / (nok + ok)),2) as yield FROM tb111 ;
		

CREATE TEMP TABLE tb2 ON COMMIT DROP AS 
	SELECT 
		date_trunc('hour',datah)::text as dia,
		qtd, 
		count(distinct serial) as cont,
		tb0.op
	from  tb0
	GROUP BY   
		dia, qtd, tb0.op
	order by dia;

-- Obtem as Horas Com base na media:
CREATE TEMP TABLE tb5 ON COMMIT DROP AS
	SELECT 
		tb2.op,
		trunc(tb2.qtd / avg(tb2.cont)) as horas  --INTO media 
		,avg(tb2.cont) as media
	FROM tb2
	GROUP BY tb2.qtd,tb2.op;

--RAISE INFO  'media hora % ', media;

-- uni a media etc...
CREATE TEMP TABLE tb6 ON COMMIT DROP AS
	SELECT 
		tb_op.op, 
		tb_op.item, 
		tb_op.qtd, 
		tb_op.data as dada_op, 
		tb_op_nunser.nroserieini, 
		tb_op_nunser.nroseriefim,
		count(distinct tb0.serial) as contagem,
		min(tb0.datah) as dt_min,
		max(tb0.datah) as dt_max,
		avg(tb5.media)::integer as media
	FROM 
		tb0, tb5, 
		tb_op_nunser,
		tb_op
	WHERE 
		tb0.op = tb_op.op and
		tb_op.op = tb5.op
		AND tb_op_nunser.nroop = tb0.op 
	GROUP BY   
		tb_op.op, 
		tb_op.item, 
		tb_op.qtd, 
		tb_op.data, 
		tb_op_nunser.nroserieini, 
		tb_op_nunser.nroseriefim
	;

-- calcula as horas previsao do dia:
	RETURN QUERY 
	SELECT 
		tb6.op, 
		tb6.item, 
		tb6.dada_op, 
		tb6.nroserieini, 
		tb6.nroseriefim,
		date_trunc('minute',tb6.dt_min),
		date_trunc('minute',tb6.dt_max),
		tb6.qtd, 
		tb6.contagem,
		(select * from sp_op_prev2(tb6.dt_min::timestamp, tb5.horas::integer)) as dt_prevista, --
		tb6.media,
		tb33.yield
	FROM tb6, tb5, tb33
	where tb5.op = tb6.op AND tb33.op = tb5.op
	ORDER BY tb6.dt_max;


END;
$$;


ALTER FUNCTION public.sp_op_resumo_reg3(arg_op integer) OWNER TO postgres;

--
-- TOC entry 418 (class 1255 OID 23829)
-- Name: sp_op_resumo_semana(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_op_resumo_semana() RETURNS TABLE(op integer, item character varying, data_op date, nroserieini character, nroseriefim character, dt_min timestamp without time zone, dt_max timestamp without time zone, qtd_op integer, cont bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
/*
	Resumo da semana com os Dados da OP e contagem
*/
--   select * from sp_op_resumo_semana()
--   select * from sp_op_serfal(4460);
--   select * from sp_op_resumo_reg(4460);
	RETURN QUERY 
	SELECT 
		tb_op.op, 
		tb_op.item, 
		tb_op.data as data_op, 
		tb_op_nunser.nroserieini, 
		tb_op_nunser.nroseriefim,
		min(tb_registro.datah) as dt_min,
		max(tb_registro.datah) as dt_max,
		tb_op.qtd as qtd_op, 
		count(distinct tb_registro.serial) as cont
	FROM 
	  tb_op, 
	  tb_op_nunser, 
	  tb_registro
	WHERE 
	  tb_registro.datah >= date_trunc('week',  localtimestamp - interval  '7 day')  and -- pega os registros da SEMANA!
	  tb_op.data >= date_trunc('week',  localtimestamp - interval  '7 day')  and
	  tb_op_nunser.nroop = tb_op.op AND
	  tb_registro.serial >= tb_op_nunser.nroserieini AND
	  tb_registro.serial <= tb_op_nunser.nroseriefim 
	  AND tb_registro.cod_gmp = 110
	GROUP BY   
	  tb_op.op, 
	  tb_op.item, 
	  tb_op.qtd, 
	  tb_op.data, 
	  tb_op_nunser.nroserieini, 
	  tb_op_nunser.nroseriefim
	order by dt_max;

END;
$$;


ALTER FUNCTION public.sp_op_resumo_semana() OWNER TO postgres;

--
-- TOC entry 428 (class 1255 OID 1321201)
-- Name: sp_op_resumo_semana2(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_op_resumo_semana2() RETURNS TABLE(op integer, item character varying, data_op date, nroserieini character, nroseriefim character, dt_min timestamp without time zone, dt_max timestamp without time zone, qtd_op integer, cont bigint, dt_prevista timestamp without time zone, media integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

/* Relatorio de Ops na Semana, contagem, media hora e Data Estimada
select * from sp_op_resumo_semana2();
*/

-- filtra os seriais duplicados com primeiro registrado:
CREATE TEMP TABLE tb3 ON COMMIT DROP AS 
		SELECT
			tb_op.op,
			--tb_op.item,
			tb_op.qtd, 
			--tb_op.data as dada_op, 
			--tb_op_nunser.nroserieini, 
			--tb_op_nunser.nroseriefim,
			tb_registro.serial,
			min(datah) as datah 
		FROM 
			tb_op, 
			tb_op_nunser, 
			tb_registro
		WHERE 
			tb_op_nunser.nroop = tb_op.op AND
			tb_registro.serial >= tb_op_nunser.nroserieini AND
			tb_registro.serial <= tb_op_nunser.nroseriefim AND
			tb_registro.datah >= date_trunc('week',  localtimestamp - interval  '7 day')  AND -- pega os registros da SEMANA!
			tb_op.data >= date_trunc('week',  localtimestamp - interval  '7 day')  AND
			cod_gmp = 110
		GROUP BY
			tb_op.op,
			--tb_op.item,
			tb_op.qtd, 
			--dada_op, 
			--tb_op_nunser.nroserieini, 
			--tb_op_nunser.nroseriefim,
			tb_registro.serial
		order by tb_registro.serial;

-- Conta quantidade Por hora:
CREATE TEMP TABLE tb2 ON COMMIT DROP AS 
	SELECT 
		date_trunc('hour',tb3.datah)::text as dia,
		tb3.qtd, 
		count(distinct tb3.serial) as cont,
		tb3.op
	from  tb3
	GROUP BY   
		dia, tb3.qtd, tb3.op
	order by dia;

-- Obtem as Horas Com base na media:
CREATE TEMP TABLE tb5 ON COMMIT DROP AS
	SELECT 
		tb2.op,
		trunc(tb2.qtd / avg(tb2.cont)) as horas  --INTO media 
		,avg(tb2.cont) as media
	FROM tb2
	GROUP BY tb2.qtd,tb2.op;

--RAISE INFO  'media hora % ', media;

-- uni a media etc...
CREATE TEMP TABLE tb6 ON COMMIT DROP AS
	SELECT 
		tb_op.op, 
		tb_op.item, 
		tb_op.qtd, 
		tb_op.data as dada_op, 
		tb_op_nunser.nroserieini, 
		tb_op_nunser.nroseriefim,
		count(distinct tb3.serial) as contagem,
		min(tb3.datah) as dt_min,
		max(tb3.datah) as dt_max,
		avg(tb5.media)::integer as media
	FROM 
		tb3, tb5, 
		tb_op_nunser,
		tb_op
	WHERE 
		tb3.op = tb_op.op and
		tb_op.op = tb5.op
		AND tb_op_nunser.nroop = tb3.op 
	GROUP BY   
		tb_op.op, 
		tb_op.item, 
		tb_op.qtd, 
		tb_op.data, 
		tb_op_nunser.nroserieini, 
		tb_op_nunser.nroseriefim
	;

-- calcula as horas previsao do dia:
	RETURN QUERY 
	SELECT 
		tb6.op, 
		tb6.item, 
		tb6.dada_op, 
		tb6.nroserieini, 
		tb6.nroseriefim,
		tb6.dt_min,
		tb6.dt_max,
		tb6.qtd, 
		tb6.contagem,
		(select * from sp_op_prev2(tb6.dt_min::timestamp, tb5.horas::integer)) as dt_prevista, --
		tb6.media
	FROM tb6, tb5
	where tb5.op = tb6.op
	ORDER BY dt_max;


END;
$$;


ALTER FUNCTION public.sp_op_resumo_semana2() OWNER TO postgres;

--
-- TOC entry 439 (class 1255 OID 9561514)
-- Name: sp_op_resumo_semana3(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_op_resumo_semana3() RETURNS TABLE(op integer, item character varying, data_op date, nroserieini character, nroseriefim character, dt_min timestamp without time zone, dt_max timestamp without time zone, qtd_op integer, cont bigint, dt_prevista timestamp without time zone, media integer, yield numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN

/* 
Relatorio de Ops na Semana, contagem, media hora e Data Estimada
atualizado 22/11/2013 inserir Yeld
select * from sp_op_resumo_semana3();
*/


                CREATE TEMP TABLE tb0 ON COMMIT DROP AS
                SELECT 
                  *
                FROM 
                  tb_op, 
                  tb_op_nunser, 
                  tb_registro
                WHERE 
                   tb_op_nunser.nroop = tb_op.op
                  AND tb_registro.serial >= tb_op_nunser.nroserieini
                  AND tb_registro.serial <= tb_op_nunser.nroseriefim 
                  AND tb_registro.datah >= tb_op.data
		  AND tb_registro.datah >= date_trunc('week',  localtimestamp - interval  '7 day')   -- pega os registros da SEMANA!
		  AND 	tb_op.data >= date_trunc('week',  localtimestamp - interval  '7 day')  
                  AND tb_registro.cod_gmp = 110 ;


CREATE TEMP TABLE tb111 ON COMMIT DROP AS
SELECT
                SUM(case when cod_status = 1 then 1 else 0 end) as nok,
                SUM(case when cod_status = 0 then 1 else 0 end) as ok, 
                tb0.op
FROM tb0 GROUP BY tb0.op ;

  CREATE TEMP TABLE tb33 ON COMMIT DROP AS
                SELECT tb111.op,  nok, ok, round(((ok * 100.0) / (nok + ok)),2) as yield FROM tb111 ;
		
/*  
-- filtra os seriais duplicados com primeiro registrado:
CREATE TEMP TABLE tb3 ON COMMIT DROP AS 
		SELECT
			tb0.op,
			qtd, 
			serial,
			min(datah) as datah 
		FROM 
			tb0
		GROUP BY
			tb0.op,
			--tb_op.item,
			qtd, 
			--dada_op, 
			--tb_op_nunser.nroserieini, 
			--tb_op_nunser.nroseriefim,
			serial
		;--order by datah --tb_registro.serial;

*/
-- Conta quantidade Por hora:
CREATE TEMP TABLE tb2 ON COMMIT DROP AS 
	SELECT 
		date_trunc('hour',datah)::text as dia,
		qtd, 
		count(distinct serial) as cont,
		tb0.op
	from  tb0
	GROUP BY   
		dia, qtd, tb0.op
	order by dia;

-- Obtem as Horas Com base na media:
CREATE TEMP TABLE tb5 ON COMMIT DROP AS
	SELECT 
		tb2.op,
		trunc(tb2.qtd / avg(tb2.cont)) as horas  --INTO media 
		,avg(tb2.cont) as media
	FROM tb2
	GROUP BY tb2.qtd,tb2.op;

--RAISE INFO  'media hora % ', media;

-- uni a media etc...
CREATE TEMP TABLE tb6 ON COMMIT DROP AS
	SELECT 
		tb_op.op, 
		tb_op.item, 
		tb_op.qtd, 
		tb_op.data as dada_op, 
		tb_op_nunser.nroserieini, 
		tb_op_nunser.nroseriefim,
		count(distinct tb0.serial) as contagem,
		min(tb0.datah) as dt_min,
		max(tb0.datah) as dt_max,
		avg(tb5.media)::integer as media
	FROM 
		tb0, tb5, 
		tb_op_nunser,
		tb_op
	WHERE 
		tb0.op = tb_op.op and
		tb_op.op = tb5.op
		AND tb_op_nunser.nroop = tb0.op 
	GROUP BY   
		tb_op.op, 
		tb_op.item, 
		tb_op.qtd, 
		tb_op.data, 
		tb_op_nunser.nroserieini, 
		tb_op_nunser.nroseriefim
	;

-- calcula as horas previsao do dia:
	RETURN QUERY 
	SELECT 
		tb6.op, 
		tb6.item, 
		tb6.dada_op, 
		tb6.nroserieini, 
		tb6.nroseriefim,
		date_trunc('minute',tb6.dt_min),
		date_trunc('minute',tb6.dt_max),
		tb6.qtd, 
		tb6.contagem,
		(select * from sp_op_prev2(tb6.dt_min::timestamp, tb5.horas::integer)) as dt_prevista, --
		tb6.media,
		tb33.yield
	FROM tb6, tb5, tb33
	where tb5.op = tb6.op AND tb33.op = tb5.op
	ORDER BY tb6.dt_max;


END;
$$;


ALTER FUNCTION public.sp_op_resumo_semana3() OWNER TO postgres;

--
-- TOC entry 412 (class 1255 OID 23830)
-- Name: sp_op_serfal(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_op_serfal(arg_op integer) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$
BEGIN
--select * from sp_op_serfal(51621);

/*
-- Funcao para retornar os Seriais que estao faltando registrar
*/

--gera todos os seriais da OP:
CREATE TEMP TABLE tb1 ON COMMIT DROP AS
SELECT upper( to_hex ( generate_series( hex_to_int(tb_op_nunser.nroserieini) , hex_to_int(tb_op_nunser.nroseriefim) ) ) ) as serials
FROM tb_op_nunser,tb_op
WHERE
  tb_op.op = tb_op_nunser.nroop AND
  tb_op_nunser.nroop = arg_op
order by serials;

--compara estes com os registrados:
RETURN QUERY
SELECT serials FROM tb1 WHERE	 
not exists ( 
	SELECT 
	  distinct tb_registro.serial
	FROM 
	  tb_op, 
	  tb_op_nunser, 
	  tb_registro
	WHERE 
          tb_op_nunser.nroop = arg_op
	  AND tb_op_nunser.nroop = tb_op.op
	  AND tb_registro.serial >= tb_op_nunser.nroserieini
	  AND tb_registro.serial <= tb_op_nunser.nroseriefim 
	  AND tb_registro.datah >= tb_op.data
	  AND tb_registro.cod_gmp = 110 
	  AND tb_registro.serial = tb1.serials  
)
order by serials;


END;
$$;


ALTER FUNCTION public.sp_op_serfal(arg_op integer) OWNER TO postgres;

--
-- TOC entry 413 (class 1255 OID 23831)
-- Name: sp_operador(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_operador(arg_cod integer, arg_oper character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	registro RECORD;
	qtd integer;
BEGIN

	SELECT INTO registro cod_cr FROM tb_operador where cod_cr = arg_cod;

	IF NOT FOUND THEN
		INSERT INTO tb_operador(
		cod_cr, str_nome)
		VALUES (arg_cod, arg_oper);
	ELSE
		UPDATE tb_operador
		SET  str_nome = arg_oper
		WHERE cod_cr = arg_cod;
	END IF;

	GET DIAGNOSTICS qtd = ROW_COUNT;
	RETURN qtd;
END;$$;


ALTER FUNCTION public.sp_operador(arg_cod integer, arg_oper character varying) OWNER TO postgres;

--
-- TOC entry 3230 (class 0 OID 0)
-- Dependencies: 413
-- Name: FUNCTION sp_operador(arg_cod integer, arg_oper character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION sp_operador(arg_cod integer, arg_oper character varying) IS 'Insere ou Altera se codigo não for zero ou nulo.';


--
-- TOC entry 414 (class 1255 OID 23832)
-- Name: sp_operador_pesq(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_operador_pesq(arg_cod integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	registro varchar;
BEGIN

	SELECT INTO registro str_nome FROM tb_operador where cod_cr = arg_cod;

	RETURN registro;
END;$$;


ALTER FUNCTION public.sp_operador_pesq(arg_cod integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 324 (class 1259 OID 23833)
-- Name: tb_produto; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_produto (
    cod_prod character(6) NOT NULL,
    str_prod character varying(50) NOT NULL,
    str_ean character varying(5) NOT NULL,
    str3 character varying(10),
    cqi_cqf integer,
    prod_ecm boolean
);


ALTER TABLE public.tb_produto OWNER TO postgres;

--
-- TOC entry 3231 (class 0 OID 0)
-- Dependencies: 324
-- Name: COLUMN tb_produto.str_ean; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN tb_produto.str_ean IS 'Valor do Cod Barras';


--
-- TOC entry 3232 (class 0 OID 0)
-- Dependencies: 324
-- Name: COLUMN tb_produto.str3; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN tb_produto.str3 IS 'Serve para comprar o Nome Real do Produto nas pesquisas';


--
-- TOC entry 415 (class 1255 OID 23836)
-- Name: sp_prod_pesq2(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_prod_pesq2(arg_str character varying) RETURNS SETOF tb_produto
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY SELECT * 
	FROM tb_produto
	WHERE UPPER(str_prod) LIKE '%' || UPPER(arg_str) || '%'
	ORDER BY str_prod;
	RETURN;
END;
$$;


ALTER FUNCTION public.sp_prod_pesq2(arg_str character varying) OWNER TO postgres;

--
-- TOC entry 374 (class 1255 OID 23837)
-- Name: sp_produto(character, character varying, character varying, character varying, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_produto(arg_cod character, arg_str character varying, arg_str_ean character varying, arg_str3 character varying, arg_cqf integer, arg_ecm boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	registro RECORD;
	qtd integer;
BEGIN

	SELECT INTO registro cod_prod FROM tb_produto where cod_prod = arg_cod;

	IF FOUND THEN

		UPDATE tb_produto
		SET str_prod=arg_str, str_ean=arg_str_ean, str3=arg_str3, cqi_cqf = arg_cqf , prod_ecm = arg_ecm
		WHERE cod_prod = arg_cod;

	ELSEIF NOT FOUND THEN

		INSERT INTO tb_produto(
		cod_prod, str_prod, str_ean, str3, cqi_cqf, prod_ecm)
		VALUES (arg_cod, arg_str, arg_str_ean, arg_str3, arg_cqf, arg_ecm);
	
	END IF;

	GET DIAGNOSTICS qtd = ROW_COUNT;
	RETURN qtd;
END;$$;


ALTER FUNCTION public.sp_produto(arg_cod character, arg_str character varying, arg_str_ean character varying, arg_str3 character varying, arg_cqf integer, arg_ecm boolean) OWNER TO postgres;

--
-- TOC entry 375 (class 1255 OID 23838)
-- Name: sp_qtdproduz_insert(integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_qtdproduz_insert(arg_cod_linha integer, arg_datah timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	r1 tb_qtd_produz.cod_qtd%TYPE;
BEGIN
--
		INSERT INTO tb_qtd_produz(cod_linha, datah)
		VALUES (arg_cod_linha,arg_datah)
		RETURNING cod_qtd INTO r1; -- retorna o numero gerado PrimaryKey

	RETURN r1;
END;
$$;


ALTER FUNCTION public.sp_qtdproduz_insert(arg_cod_linha integer, arg_datah timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 376 (class 1255 OID 23839)
-- Name: sp_qtdproduz_insert(integer, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_qtdproduz_insert(arg_cod_op integer, arg_cod_linha integer, arg_cod_cr integer, arg_cod_prod character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	r1 tb_qtd_produz.cod_qtd%TYPE;
BEGIN
--
		INSERT INTO tb_qtd_produz(cod_op, cod_linha, cod_cr, cod_prod)
		VALUES (arg_cod_op, arg_cod_linha, arg_cod_cr, arg_cod_prod)
		RETURNING cod_qtd INTO r1; -- retorna o numero gerado PrimaryKey

	RETURN r1;
END;
$$;


ALTER FUNCTION public.sp_qtdproduz_insert(arg_cod_op integer, arg_cod_linha integer, arg_cod_cr integer, arg_cod_prod character varying) OWNER TO postgres;

--
-- TOC entry 377 (class 1255 OID 23840)
-- Name: sp_registro_del(integer, integer, character, character, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_registro_del(arg_cod_cr integer, arg_cod_status integer, arg_cod_prod character, arg_serial character, arg_dt1 timestamp without time zone, arg_dt2 timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql
    AS $$
	DECLARE
		qtd integer;
	BEGIN
		DELETE FROM tb_registro
		WHERE 
			cod_cr = arg_cod_cr AND 
			cod_status = arg_cod_status AND
			cod_prod = arg_cod_prod AND
			serial LIKE '%' || arg_serial || '%' AND
			datah BETWEEN arg_dt1 AND arg_dt2;

		GET DIAGNOSTICS qtd = ROW_COUNT;
		RETURN qtd;
	END;
$$;


ALTER FUNCTION public.sp_registro_del(arg_cod_cr integer, arg_cod_status integer, arg_cod_prod character, arg_serial character, arg_dt1 timestamp without time zone, arg_dt2 timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 378 (class 1255 OID 23841)
-- Name: sp_registro_insert(integer, integer, character varying, character, character, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_registro_insert(arg_cod_cr integer, arg_cod_status integer, arg_cod_prod_ean character varying, arg_serial character, arg_posto_gmp character, arg_complemento character varying, arg_inspecao character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	registro RECORD;
	qtd integer := 0;
	cod_gmp integer;
	posto integer;
	pescaGmp RECORD;
BEGIN

	posto := substring(arg_posto_gmp from 9 for 3);

	SELECT INTO pescaGmp 
	 tb_gmp.cod_gmp
	   FROM 
	     public.tb_gmp
	       WHERE 
	          tb_gmp.str_gmp = substring(arg_posto_gmp from 5 for 3);
	          

	SELECT INTO registro 
	 tb_produto.cod_prod
	   FROM 
	     public.tb_produto
	       WHERE 
	          tb_produto.str_ean = arg_cod_prod_ean;

	IF FOUND THEN
		INSERT INTO tb_registro(
			    cod_cr,
			    cod_status,
			     cod_prod,
			      serial,
			       posto_gmp,
				datah,
				 complemento,
				  inspecao,
				   cod_gmp,
				    cod_posto)
		    VALUES (arg_cod_cr,
			    arg_cod_status,
			     registro.cod_prod,
			      arg_serial,
			       arg_posto_gmp,
			       LOCALTIMESTAMP,
				 arg_complemento,
				  arg_inspecao,
				   pescaGmp.cod_gmp,
				    posto);

		GET DIAGNOSTICS qtd = ROW_COUNT;
	end if;

	RETURN qtd;
END;
$$;


ALTER FUNCTION public.sp_registro_insert(arg_cod_cr integer, arg_cod_status integer, arg_cod_prod_ean character varying, arg_serial character, arg_posto_gmp character, arg_complemento character varying, arg_inspecao character varying) OWNER TO postgres;

--
-- TOC entry 379 (class 1255 OID 23842)
-- Name: sp_registro_insert(integer, integer, character varying, character, character, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_registro_insert(arg_cod_cr integer, arg_cod_status integer, arg_cod_prod_ean character varying, arg_serial character, arg_posto_gmp character, arg_complemento character varying, arg_inspecao character varying, arg_dt1 character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	qtd integer := 0;
	cod_gmp integer;
	posto integer;
	pescaGmp RECORD;
BEGIN
-- funcao ok, usada na importacao etc..

	posto := substring(arg_posto_gmp from 9 for 3);

	SELECT INTO pescaGmp 
	 tb_gmp.cod_gmp
	   FROM 
	     public.tb_gmp
	       WHERE 
	          tb_gmp.str_gmp = substring(arg_posto_gmp from 5 for 3);
	
	INSERT INTO tb_registro(
		    cod_cr,
		    cod_status,
		     cod_prod,
		      serial,
		       posto_gmp,
			datah,
			 complemento,
			  inspecao,
			   cod_gmp,
			    cod_posto)
	    VALUES (arg_cod_cr,
		    arg_cod_status,
		     arg_cod_prod_ean,
		      arg_serial,
		       arg_posto_gmp,
		       TO_timestamp(arg_dt1,'DD/MM/YY HH24:MI:SS'),
		    --  LOCALTIMESTAMP,
			 arg_complemento,
			  arg_inspecao,
			   pescaGmp.cod_gmp,
			    posto  );

	GET DIAGNOSTICS qtd = ROW_COUNT;
--lanca excessao:
	if qtd = 0 then
		RAISE EXCEPTION 'Inserido % registro.', qtd;
	end if;

	RETURN qtd;
END;
$$;


ALTER FUNCTION public.sp_registro_insert(arg_cod_cr integer, arg_cod_status integer, arg_cod_prod_ean character varying, arg_serial character, arg_posto_gmp character, arg_complemento character varying, arg_inspecao character varying, arg_dt1 character varying) OWNER TO postgres;

--
-- TOC entry 434 (class 1255 OID 3792372)
-- Name: sp_registro_insert2(integer, integer, character, character, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_registro_insert2(arg_cod_cr integer, arg_cod_status integer, arg_serial character, arg_posto_gmp character, arg_complemento character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	registro RECORD;
	qtd integer := 0;
	cod_gmp integer;
	posto integer;
	pescaGmp RECORD;
BEGIN
-- 03/04/2013 - Paulo Vinicius.
-- usada para inserção direta, sem precisar informar o Produto, consultando tb_op
-- web
-- select sp_registro_insert2 ( 2093, 0 , 'B49D08', 'GMP-CQF-003' , 'TESTE' );

--desmenbrando GMP:
	posto := substring(arg_posto_gmp from 9 for 3);
	SELECT INTO pescaGmp 
	 tb_gmp.cod_gmp
	   FROM 
	     public.tb_gmp
	       WHERE 
	          tb_gmp.str_gmp = substring(arg_posto_gmp from 5 for 3);
	          
-- consulta produto pelo serial e op:
	SELECT INTO registro  
	  tb_produto.cod_prod
	    FROM tb_op_nunser, tb_op , tb_produto
	      where 
	        decode(arg_serial, 'hex')  >=  decode(nroserieini, 'hex') and 
	          decode(arg_serial, 'hex')  <=  decode(nroseriefim, 'hex') and 
	            tb_op_nunser.nroop = tb_op.op and
		      --tb_produto.str3 = tb_op.item; -- aletrado para aceitar extencao
		      tb_op.item like tb_produto.str3 || '%'
		        and str3 <> '';

	IF FOUND THEN
		INSERT INTO tb_registro(
			    cod_cr,
			    cod_status,
			     cod_prod,
			      serial,
			       posto_gmp,
				datah,
				 complemento,
				   cod_gmp,
				    cod_posto)
		    VALUES (arg_cod_cr,
			    arg_cod_status,
			     registro.cod_prod,
			      arg_serial,
			       arg_posto_gmp,
			       LOCALTIMESTAMP,
				 arg_complemento,
				   pescaGmp.cod_gmp,
				    posto);

		GET DIAGNOSTICS qtd = ROW_COUNT;
		--lanca excessao:
			if qtd = 0 then
				RAISE EXCEPTION 'Inserido % registro.', qtd;
			end if;
	else
		RAISE EXCEPTION 'O.P. ou produto Nao Cadastrado.';
	end if;

	RETURN qtd;
END;
$$;


ALTER FUNCTION public.sp_registro_insert2(arg_cod_cr integer, arg_cod_status integer, arg_serial character, arg_posto_gmp character, arg_complemento character varying) OWNER TO postgres;

--
-- TOC entry 380 (class 1255 OID 23843)
-- Name: sp_registro_insert_frame(integer, integer, character varying, character, character, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_registro_insert_frame(arg_cod_cr integer, arg_cod_status integer, arg_cod_prod_ean character varying, arg_serial character, arg_posto_gmp character, arg_complemento character varying, arg_inspecao character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	qtd integer := 0;
	cod_gmp integer;
	posto integer;
	pescaGmp RECORD;
BEGIN

	posto := substring(arg_posto_gmp from 9 for 3);

	SELECT INTO pescaGmp 
	 tb_gmp.cod_gmp
	   FROM 
	     public.tb_gmp
	       WHERE 
	          tb_gmp.str_gmp = substring(arg_posto_gmp from 5 for 3);

		INSERT INTO tb_registro(
			    cod_cr,
			    cod_status,
			     cod_prod,
			      serial,
			       posto_gmp,
				datah,
				 complemento,
				  inspecao,
				   cod_gmp,
				    cod_posto)
		    VALUES (arg_cod_cr,
			    arg_cod_status,
			     arg_cod_prod_ean,
			      arg_serial,
			       arg_posto_gmp,
			       LOCALTIMESTAMP,
				 arg_complemento,
				  arg_inspecao,
				   pescaGmp.cod_gmp,
				    posto);

		GET DIAGNOSTICS qtd = ROW_COUNT;

	RETURN qtd;
END;
$$;


ALTER FUNCTION public.sp_registro_insert_frame(arg_cod_cr integer, arg_cod_status integer, arg_cod_prod_ean character varying, arg_serial character, arg_posto_gmp character, arg_complemento character varying, arg_inspecao character varying) OWNER TO postgres;

--
-- TOC entry 325 (class 1259 OID 23844)
-- Name: tb_registro; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_registro (
    cod_cr integer NOT NULL,
    cod_status integer NOT NULL,
    serial character(6) NOT NULL,
    posto_gmp character(11),
    datah timestamp without time zone NOT NULL,
    complemento character varying(50),
    inspecao character varying(30),
    cod_prod character(6) NOT NULL,
    cod_gmp integer,
    cod_posto integer
);


ALTER TABLE public.tb_registro OWNER TO postgres;

--
-- TOC entry 381 (class 1255 OID 23847)
-- Name: sp_registro_pesq2(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_registro_pesq2(arg_cod_cr integer, arg_dt1 character varying, arg_dt2 character varying) RETURNS SETOF tb_registro
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY SELECT
		*
	FROM tb_registro WHERE
		cod_cr = arg_cod_cr
		AND
		datah BETWEEN TO_timestamp(arg_dt1,'DD/MM/YYYY HH24:MI:SS') AND TO_timestamp(arg_dt2,'DD/MM/YYYY HH24:MI:SS')
	ORDER BY datah DESC;
	RETURN;
END;
$$;


ALTER FUNCTION public.sp_registro_pesq2(arg_cod_cr integer, arg_dt1 character varying, arg_dt2 character varying) OWNER TO postgres;

--
-- TOC entry 382 (class 1255 OID 23848)
-- Name: sp_registro_pesq2(integer, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_registro_pesq2(arg_cod_cr integer, arg_serial character varying, arg_dt1 character varying, arg_dt2 character varying) RETURNS SETOF tb_registro
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY SELECT
		cod_cr, 
		cod_status, 
		cod_prod, 
		serial, 
		posto_gmp, 
		datah, 
		complemento,
		inspecao
	FROM tb_registro WHERE
		cod_cr = arg_cod_cr
		AND
		serial LIKE '%' || arg_serial || '%' 
		AND
		datah BETWEEN TO_timestamp(arg_dt1,'DD/MM/YYYY HH24:MI:SS') AND TO_timestamp(arg_dt2,'DD/MM/YYYY HH24:MI:SS');

	RETURN;
END;
$$;


ALTER FUNCTION public.sp_registro_pesq2(arg_cod_cr integer, arg_serial character varying, arg_dt1 character varying, arg_dt2 character varying) OWNER TO postgres;

--
-- TOC entry 422 (class 1255 OID 49222)
-- Name: sp_resumo_dia2(timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_resumo_dia2(arg_dt1 timestamp without time zone) RETURNS TABLE(cod_prod character, ok bigint, nok bigint, defeitos bigint, str_prod character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN

/*
	Usado no Resumo dia  - Web
*/

-- select * from sp_resumo_dia2(to_date('02/10/2012','DD/MM/YYYY'))
	CREATE TEMP TABLE tb1 ON COMMIT DROP AS -- OK
	SELECT 
		tb_registro.cod_prod, 
		count(distinct(tb_registro.serial)) as status 
	 FROM tb_registro 
	WHERE
		date_trunc('day', tb_registro.datah) =  arg_dt1
		AND tb_registro.cod_status = 0 
		AND tb_registro.cod_gmp = 110
	GROUP BY  tb_registro.cod_prod;

	CREATE TEMP TABLE tb2 ON COMMIT DROP AS
	SELECT  
		tb_registro.cod_prod, 
		count(distinct(tb_registro.serial)) as status 
	 FROM tb_registro 
	WHERE
		date_trunc('day', tb_registro.datah) =  arg_dt1
		AND tb_registro.cod_status >= 1
		AND tb_registro.cod_gmp = 110
	GROUP BY  tb_registro.cod_prod;


	CREATE TEMP TABLE tb3 ON COMMIT DROP AS
	SELECT  
		tb_defeito.cod_prod,
		count(distinct(tb_defeito.serial)) as defeitos 
	 FROM tb_defeito
	WHERE
		date_trunc('day', tb_defeito.datahora) =  arg_dt1
	GROUP BY  tb_defeito.cod_prod;

	CREATE TEMP TABLE tb4 ON COMMIT DROP AS
	SELECT 
		tb1.cod_prod,
		tb1.status as ok,
		tb2.status as nok,
		tb3.defeitos
	FROM
		tb1
	FULL JOIN tb2 ON tb1.cod_prod = tb2.cod_prod 
	FULL JOIN tb3 ON tb1.cod_prod = tb3.cod_prod 
	WHERE tb1.cod_prod is not null
	UNION (	SELECT tb2.cod_prod,0,tb2.status,0 FROM tb2 where not exists (select 1 from tb1 where tb1.cod_prod = tb2.cod_prod))
	UNION (	SELECT tb3.cod_prod,0,0,tb3.defeitos FROM tb3 where not exists (select 1 from tb1 where tb1.cod_prod = tb3.cod_prod))
	;


	RETURN QUERY 
	SELECT 
		tb4.cod_prod,
		tb4.ok,
		tb4.nok,
		tb4.defeitos,
		tb_produto.str_prod
	FROM 
		tb4, tb_produto
	WHERE
		tb_produto.cod_prod = tb4.cod_prod
	ORDER BY ok desc;
	

END;
$$;


ALTER FUNCTION public.sp_resumo_dia2(arg_dt1 timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 423 (class 1255 OID 255209)
-- Name: sp_resumo_dia2semana(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_resumo_dia2semana() RETURNS TABLE(cod_prod character, ok bigint, nok bigint, defeitos bigint, str_prod character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN

/*
	Usado no Resumo Semana  - Web
*/

-- select * from sp_resumo_dia2semana()
	CREATE TEMP TABLE tb1 ON COMMIT DROP AS -- OK
	SELECT 
		tb_registro.cod_prod, 
		count(distinct(tb_registro.serial)) as status 
	 FROM tb_registro 
	WHERE
		date_trunc('day', tb_registro.datah) >=  date_trunc('week',  localtimestamp)
		AND tb_registro.cod_status = 0 
		AND tb_registro.cod_gmp = 110
	GROUP BY  tb_registro.cod_prod;

	CREATE TEMP TABLE tb2 ON COMMIT DROP AS
	SELECT  
		tb_registro.cod_prod, 
		count(distinct(tb_registro.serial)) as status 
	 FROM tb_registro 
	WHERE
		date_trunc('day', tb_registro.datah) >=  date_trunc('week',  localtimestamp)
		AND tb_registro.cod_status >= 1
		AND tb_registro.cod_gmp = 110
	GROUP BY  tb_registro.cod_prod;


	CREATE TEMP TABLE tb3 ON COMMIT DROP AS
	SELECT  
		tb_defeito.cod_prod,
		count(distinct(tb_defeito.serial)) as defeitos 
	 FROM tb_defeito
	WHERE
		date_trunc('day', tb_defeito.datahora) >=  date_trunc('week',  localtimestamp)
	GROUP BY  tb_defeito.cod_prod;

	CREATE TEMP TABLE tb4 ON COMMIT DROP AS
	SELECT 
		tb1.cod_prod,
		tb1.status as ok,
		tb2.status as nok,
		tb3.defeitos
	FROM
		tb1
	FULL JOIN tb2 ON tb1.cod_prod = tb2.cod_prod 
	FULL JOIN tb3 ON tb1.cod_prod = tb3.cod_prod 
	WHERE tb1.cod_prod is not null
	UNION (	SELECT tb2.cod_prod,0,tb2.status,0 FROM tb2 where not exists (select 1 from tb1 where tb1.cod_prod = tb2.cod_prod))
	UNION (	SELECT tb3.cod_prod,0,0,tb3.defeitos FROM tb3 where not exists (select 1 from tb1 where tb1.cod_prod = tb3.cod_prod))
	;


	RETURN QUERY 
	SELECT 
		tb4.cod_prod,
		tb4.ok,
		tb4.nok,
		tb4.defeitos,
		tb_produto.str_prod
	FROM 
		tb4, tb_produto
	WHERE
		tb_produto.cod_prod = tb4.cod_prod
	ORDER BY ok desc;
	

END;
$$;


ALTER FUNCTION public.sp_resumo_dia2semana() OWNER TO postgres;

--
-- TOC entry 429 (class 1255 OID 1394801)
-- Name: sp_resumo_dia3(timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_resumo_dia3(arg_dt1 timestamp without time zone) RETURNS TABLE(cod_prod character, ok bigint, nok bigint, defeitos bigint, str_prod character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN

/*
	Usado no Resumo dia  - Web
	VERSÃO 3.0

Em testes Desenpenho e performance.
não usado ainda.

*/

-- select * from sp_resumo_dia3(to_date('11/12/2012','DD/MM/YYYY'))
	CREATE TEMP TABLE tb0 ON COMMIT DROP AS -- OK
	SELECT --distinct
		tb_registro.cod_prod, 
		tb_registro.serial,
		tb_registro.cod_status
	 FROM tb_registro 
	WHERE
		date_trunc('day', tb_registro.datah) = arg_dt1
		AND tb_registro.cod_gmp = 110
	;


	CREATE TEMP TABLE tb1ok ON COMMIT DROP AS -- OK
	SELECT 
		tb0.cod_prod, 
		count(distinct(tb0.serial)) as status 
	FROM 
		tb0
	WHERE
		tb0.cod_status = 0 
	GROUP BY tb0.cod_prod;

	CREATE TEMP TABLE tb2nok ON COMMIT DROP AS
	SELECT
		tb0.cod_prod, 
		count(distinct(tb0.serial)) as status 
	FROM 
		tb0 
	WHERE
		tb0.cod_status >= 1
	GROUP BY  tb0.cod_prod;


	CREATE TEMP TABLE tb3def ON COMMIT DROP AS
	SELECT  
		tb_defeito.cod_prod,
		count(distinct(tb_defeito.serial)) as defeitos 
	 FROM tb_defeito
	WHERE
		date_trunc('day', tb_defeito.datahora) =  arg_dt1
	GROUP BY  tb_defeito.cod_prod;

	CREATE TEMP TABLE tb4 ON COMMIT DROP AS
	SELECT 
		ass.cod_prod,
		tb1ok.status as ok,
		tb2nok.status as nok,
		tb3def.defeitos
	FROM
		-- lista com todos os produtos:
		(   select tb0.cod_prod from tb0 group by tb0.cod_prod ) ass
	left JOIN tb1ok using(cod_prod)
	left JOIN tb2nok using(cod_prod)
	left JOIN tb3def using(cod_prod);


	RETURN QUERY 
	SELECT 
		tb4.cod_prod,
		tb4.ok,
		tb4.nok,
		tb4.defeitos,
		tb_produto.str_prod
	FROM 
		tb4, tb_produto
	WHERE
		tb_produto.cod_prod = tb4.cod_prod
	ORDER BY ok desc;
	

END;
$$;


ALTER FUNCTION public.sp_resumo_dia3(arg_dt1 timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 416 (class 1255 OID 23850)
-- Name: sp_status_upin(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_status_upin(cod integer, txt character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE
 qtd integer;

BEGIN

	UPDATE tb_status
	   SET  status=txt
	 WHERE cod_status=cod;


GET DIAGNOSTICS qtd = ROW_COUNT;
    RETURN qtd;
END;$$;


ALTER FUNCTION public.sp_status_upin(cod integer, txt character varying) OWNER TO postgres;

--
-- TOC entry 417 (class 1255 OID 23851)
-- Name: sp_trunc_strutura(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sp_trunc_strutura() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

	--TRUNCATE TABLE tb_item;

	TRUNCATE TABLE tb_estrutura;

END;
$$;


ALTER FUNCTION public.sp_trunc_strutura() OWNER TO postgres;

--
-- TOC entry 326 (class 1259 OID 23852)
-- Name: tb_status; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_status (
    cod_status integer NOT NULL,
    status character varying(50) NOT NULL
);


ALTER TABLE public.tb_status OWNER TO postgres;

--
-- TOC entry 327 (class 1259 OID 23855)
-- Name: TB_STATUS_cod_status_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "TB_STATUS_cod_status_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."TB_STATUS_cod_status_seq" OWNER TO postgres;

--
-- TOC entry 3236 (class 0 OID 0)
-- Dependencies: 327
-- Name: TB_STATUS_cod_status_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "TB_STATUS_cod_status_seq" OWNED BY tb_status.cod_status;


--
-- TOC entry 328 (class 1259 OID 23857)
-- Name: tb_assis_tec; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_assis_tec (
    cod_assistec integer NOT NULL,
    cod_cr integer NOT NULL,
    cod_deposito smallint NOT NULL,
    datah timestamp without time zone DEFAULT ('now'::text)::timestamp without time zone,
    str_relatorio character varying(20),
    obs character varying(60),
    cod_prod character(6) NOT NULL,
    cod_prod2 character(5),
    serial character(6) NOT NULL,
    op_num integer
);


ALTER TABLE public.tb_assis_tec OWNER TO postgres;

--
-- TOC entry 329 (class 1259 OID 23861)
-- Name: tb_assis_tec_cod_assistec_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tb_assis_tec_cod_assistec_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tb_assis_tec_cod_assistec_seq OWNER TO postgres;

--
-- TOC entry 3239 (class 0 OID 0)
-- Dependencies: 329
-- Name: tb_assis_tec_cod_assistec_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tb_assis_tec_cod_assistec_seq OWNED BY tb_assis_tec.cod_assistec;


--
-- TOC entry 330 (class 1259 OID 23863)
-- Name: tb_assistec_rep; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_assistec_rep (
    cod_assistec integer NOT NULL,
    cod_tp_defeito integer NOT NULL,
    cod_sintoma integer NOT NULL,
    cod_comp character varying(5) NOT NULL,
    pos_comp integer NOT NULL,
    str_sa character varying(50),
    tipo_montagem character(1) NOT NULL,
    datareg timestamp without time zone DEFAULT ('now'::text)::timestamp without time zone NOT NULL,
    str_compo character varying(13)
);


ALTER TABLE public.tb_assistec_rep OWNER TO postgres;

--
-- TOC entry 331 (class 1259 OID 23867)
-- Name: tb_componente; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_componente (
    cod_comp character varying(4) NOT NULL,
    str_comp character varying(40)
);


ALTER TABLE public.tb_componente OWNER TO postgres;

--
-- TOC entry 332 (class 1259 OID 23870)
-- Name: tb_cqi_chamada; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_cqi_chamada (
    cod_chamada integer NOT NULL,
    cod_prod character(6),
    inicio smallint NOT NULL,
    periodi smallint NOT NULL,
    str_chamada character varying NOT NULL,
    link_ilustracao character varying
);


ALTER TABLE public.tb_cqi_chamada OWNER TO postgres;

--
-- TOC entry 333 (class 1259 OID 23876)
-- Name: tb_cqi_chamada_cod_chamada_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tb_cqi_chamada_cod_chamada_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tb_cqi_chamada_cod_chamada_seq OWNER TO postgres;

--
-- TOC entry 3244 (class 0 OID 0)
-- Dependencies: 333
-- Name: tb_cqi_chamada_cod_chamada_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tb_cqi_chamada_cod_chamada_seq OWNED BY tb_cqi_chamada.cod_chamada;


--
-- TOC entry 334 (class 1259 OID 23878)
-- Name: tb_cqi_lista; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_cqi_lista (
    cod_lista integer NOT NULL,
    str_lista character varying NOT NULL,
    str_descricao character varying NOT NULL
);


ALTER TABLE public.tb_cqi_lista OWNER TO postgres;

--
-- TOC entry 335 (class 1259 OID 23884)
-- Name: tb_cqi_lista_cod_lista_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tb_cqi_lista_cod_lista_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tb_cqi_lista_cod_lista_seq OWNER TO postgres;

--
-- TOC entry 3247 (class 0 OID 0)
-- Dependencies: 335
-- Name: tb_cqi_lista_cod_lista_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tb_cqi_lista_cod_lista_seq OWNED BY tb_cqi_lista.cod_lista;


--
-- TOC entry 336 (class 1259 OID 23886)
-- Name: tb_cqi_reg_status; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_cqi_reg_status (
    cod_cqi_reg integer NOT NULL,
    cod_veri integer NOT NULL,
    status boolean NOT NULL
);


ALTER TABLE public.tb_cqi_reg_status OWNER TO postgres;

--
-- TOC entry 337 (class 1259 OID 23889)
-- Name: tb_cqi_registro; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_cqi_registro (
    cod_cqi_reg integer NOT NULL,
    str_serial character(6) NOT NULL,
    cqf_cqi boolean NOT NULL,
    cod_cr integer NOT NULL,
    datah timestamp without time zone NOT NULL
);


ALTER TABLE public.tb_cqi_registro OWNER TO postgres;

--
-- TOC entry 338 (class 1259 OID 23892)
-- Name: tb_cqi_registro_cod_cqi_reg_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tb_cqi_registro_cod_cqi_reg_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tb_cqi_registro_cod_cqi_reg_seq OWNER TO postgres;

--
-- TOC entry 3251 (class 0 OID 0)
-- Dependencies: 338
-- Name: tb_cqi_registro_cod_cqi_reg_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tb_cqi_registro_cod_cqi_reg_seq OWNED BY tb_cqi_registro.cod_cqi_reg;


--
-- TOC entry 339 (class 1259 OID 23894)
-- Name: tb_cqi_verifica; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_cqi_verifica (
    cod_chamada integer NOT NULL,
    cod_lista integer NOT NULL,
    cod_veri integer NOT NULL
);


ALTER TABLE public.tb_cqi_verifica OWNER TO postgres;

--
-- TOC entry 340 (class 1259 OID 23897)
-- Name: tb_cqi_verifica_cod_veri_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tb_cqi_verifica_cod_veri_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tb_cqi_verifica_cod_veri_seq OWNER TO postgres;

--
-- TOC entry 3254 (class 0 OID 0)
-- Dependencies: 340
-- Name: tb_cqi_verifica_cod_veri_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tb_cqi_verifica_cod_veri_seq OWNED BY tb_cqi_verifica.cod_veri;


--
-- TOC entry 341 (class 1259 OID 23899)
-- Name: tb_defeito; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_defeito (
    cod_prod character(6),
    serial character(6),
    cod_tp_defeito integer,
    cod_sintoma integer,
    tipo_montagem character(1),
    cod_comp character varying(4),
    pos_comp integer,
    datahora timestamp without time zone,
    cod_cr integer,
    str_obs character varying(60),
    str_compo character varying(13)
);


ALTER TABLE public.tb_defeito OWNER TO postgres;

--
-- TOC entry 3256 (class 0 OID 0)
-- Dependencies: 341
-- Name: COLUMN tb_defeito.cod_sintoma; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN tb_defeito.cod_sintoma IS '
';


--
-- TOC entry 342 (class 1259 OID 23902)
-- Name: tb_estrutura; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_estrutura (
    escodigo character varying NOT NULL,
    itcodigo character varying NOT NULL,
    localmontag character varying
);


ALTER TABLE public.tb_estrutura OWNER TO postgres;

--
-- TOC entry 359 (class 1259 OID 5308772)
-- Name: tb_estrutura_prod; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_estrutura_prod (
    escodigo character varying NOT NULL,
    itcodigo character varying NOT NULL,
    localmontag character varying
);


ALTER TABLE public.tb_estrutura_prod OWNER TO postgres;

--
-- TOC entry 343 (class 1259 OID 23908)
-- Name: tb_gmp; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_gmp (
    cod_gmp integer NOT NULL,
    str_gmp character(3),
    obs character varying(30)
);


ALTER TABLE public.tb_gmp OWNER TO postgres;

--
-- TOC entry 344 (class 1259 OID 23911)
-- Name: tb_item; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_item (
    itcodigo character varying NOT NULL,
    descricao1 character varying,
    gecodigo integer
);


ALTER TABLE public.tb_item OWNER TO postgres;

--
-- TOC entry 345 (class 1259 OID 23917)
-- Name: tb_op; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_op (
    estado integer,
    op integer NOT NULL,
    item character varying(12),
    qtd integer,
    data date
);


ALTER TABLE public.tb_op OWNER TO postgres;

--
-- TOC entry 346 (class 1259 OID 23920)
-- Name: tb_op_nunser; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_op_nunser (
    nroop integer NOT NULL,
    nroserieini character(6),
    nroseriefim character(6)
);


ALTER TABLE public.tb_op_nunser OWNER TO postgres;

--
-- TOC entry 347 (class 1259 OID 23923)
-- Name: tb_operador; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_operador (
    cod_cr integer NOT NULL,
    str_nome character varying(50),
    grupo character varying(30)
);


ALTER TABLE public.tb_operador OWNER TO postgres;

--
-- TOC entry 3264 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN tb_operador.cod_cr; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN tb_operador.cod_cr IS 'Código do Crachá';


--
-- TOC entry 3265 (class 0 OID 0)
-- Dependencies: 347
-- Name: COLUMN tb_operador.str_nome; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN tb_operador.str_nome IS 'Nome';


--
-- TOC entry 348 (class 1259 OID 23926)
-- Name: tb_prod_gmp; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_prod_gmp (
    cod_prod_gmp integer NOT NULL,
    cod_prod character(6) NOT NULL,
    str_gmp character varying(11),
    qtd_min integer DEFAULT 1 NOT NULL,
    cod_gmp integer,
    cod_posto integer
);


ALTER TABLE public.tb_prod_gmp OWNER TO postgres;

--
-- TOC entry 349 (class 1259 OID 23930)
-- Name: tb_prod_gmp_cod_prod_gmp_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tb_prod_gmp_cod_prod_gmp_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tb_prod_gmp_cod_prod_gmp_seq OWNER TO postgres;

--
-- TOC entry 3268 (class 0 OID 0)
-- Dependencies: 349
-- Name: tb_prod_gmp_cod_prod_gmp_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tb_prod_gmp_cod_prod_gmp_seq OWNED BY tb_prod_gmp.cod_prod_gmp;


--
-- TOC entry 350 (class 1259 OID 23932)
-- Name: tb_qtd_parada; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_qtd_parada (
    cod_qtd integer,
    cod_parada character varying(6) NOT NULL,
    datah_ini timestamp without time zone NOT NULL,
    datah_fim timestamp without time zone NOT NULL,
    str_obs character varying(120),
    cod_op integer
);


ALTER TABLE public.tb_qtd_parada OWNER TO postgres;

--
-- TOC entry 351 (class 1259 OID 23935)
-- Name: tb_qtd_prod_reg; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_qtd_prod_reg (
    cod_qtd integer,
    quantidade integer NOT NULL,
    datahora timestamp without time zone NOT NULL,
    tipo_bot boolean
);


ALTER TABLE public.tb_qtd_prod_reg OWNER TO postgres;

--
-- TOC entry 352 (class 1259 OID 23938)
-- Name: tb_qtd_produz; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_qtd_produz (
    cod_qtd integer NOT NULL,
    cod_linha integer NOT NULL,
    datah timestamp without time zone NOT NULL,
    min_dia integer DEFAULT 500 NOT NULL
);


ALTER TABLE public.tb_qtd_produz OWNER TO postgres;

--
-- TOC entry 353 (class 1259 OID 23942)
-- Name: tb_qtd_produz_cod_qtd_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tb_qtd_produz_cod_qtd_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tb_qtd_produz_cod_qtd_seq OWNER TO postgres;

--
-- TOC entry 3273 (class 0 OID 0)
-- Dependencies: 353
-- Name: tb_qtd_produz_cod_qtd_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tb_qtd_produz_cod_qtd_seq OWNED BY tb_qtd_produz.cod_qtd;


--
-- TOC entry 354 (class 1259 OID 23944)
-- Name: tb_qtd_x_oper; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_qtd_x_oper (
    cod_qtd integer NOT NULL,
    cod_cr integer NOT NULL,
    datah timestamp without time zone NOT NULL
);


ALTER TABLE public.tb_qtd_x_oper OWNER TO postgres;

--
-- TOC entry 355 (class 1259 OID 23947)
-- Name: tb_qtd_x_oprod; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_qtd_x_oprod (
    cod_qtd integer NOT NULL,
    cod_op integer NOT NULL,
    datah timestamp without time zone NOT NULL,
    cod_prod character varying(25) NOT NULL
);


ALTER TABLE public.tb_qtd_x_oprod OWNER TO postgres;

--
-- TOC entry 356 (class 1259 OID 23950)
-- Name: tb_sintoma; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_sintoma (
    cod_sintoma integer NOT NULL,
    str_sintoma character varying(29),
    obs character varying(20)
);


ALTER TABLE public.tb_sintoma OWNER TO postgres;

--
-- TOC entry 357 (class 1259 OID 23962)
-- Name: tb_tp_defeito; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_tp_defeito (
    cod_tp_defeito integer NOT NULL,
    str_defeito character varying(30) NOT NULL,
    str_grupo character varying(15),
    str_obs character varying(20),
    str_alias character varying(30),
    save_comp boolean,
    exibe_reparo boolean
);


ALTER TABLE public.tb_tp_defeito OWNER TO postgres;

--
-- TOC entry 3278 (class 0 OID 0)
-- Dependencies: 357
-- Name: COLUMN tb_tp_defeito.save_comp; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN tb_tp_defeito.save_comp IS 'Obriga Salvar o Componente? > Nao implementado';


--
-- TOC entry 358 (class 1259 OID 23965)
-- Name: tb_tp_parada; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tb_tp_parada (
    cod_parada character varying(6) NOT NULL,
    str_parada character varying(50) NOT NULL
);


ALTER TABLE public.tb_tp_parada OWNER TO postgres;

--
-- TOC entry 3029 (class 2604 OID 23968)
-- Name: cod_assistec; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_assis_tec ALTER COLUMN cod_assistec SET DEFAULT nextval('tb_assis_tec_cod_assistec_seq'::regclass);


--
-- TOC entry 3031 (class 2604 OID 23969)
-- Name: cod_chamada; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_cqi_chamada ALTER COLUMN cod_chamada SET DEFAULT nextval('tb_cqi_chamada_cod_chamada_seq'::regclass);


--
-- TOC entry 3032 (class 2604 OID 23970)
-- Name: cod_lista; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_cqi_lista ALTER COLUMN cod_lista SET DEFAULT nextval('tb_cqi_lista_cod_lista_seq'::regclass);


--
-- TOC entry 3033 (class 2604 OID 23971)
-- Name: cod_cqi_reg; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_cqi_registro ALTER COLUMN cod_cqi_reg SET DEFAULT nextval('tb_cqi_registro_cod_cqi_reg_seq'::regclass);


--
-- TOC entry 3034 (class 2604 OID 23972)
-- Name: cod_veri; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_cqi_verifica ALTER COLUMN cod_veri SET DEFAULT nextval('tb_cqi_verifica_cod_veri_seq'::regclass);


--
-- TOC entry 3036 (class 2604 OID 23973)
-- Name: cod_prod_gmp; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_prod_gmp ALTER COLUMN cod_prod_gmp SET DEFAULT nextval('tb_prod_gmp_cod_prod_gmp_seq'::regclass);


--
-- TOC entry 3038 (class 2604 OID 23974)
-- Name: cod_qtd; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_qtd_produz ALTER COLUMN cod_qtd SET DEFAULT nextval('tb_qtd_produz_cod_qtd_seq'::regclass);


--
-- TOC entry 3027 (class 2604 OID 23975)
-- Name: cod_status; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_status ALTER COLUMN cod_status SET DEFAULT nextval('"TB_STATUS_cod_status_seq"'::regclass);


--
-- TOC entry 3044 (class 2606 OID 23994)
-- Name: cod_assistec; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_assis_tec
    ADD CONSTRAINT cod_assistec PRIMARY KEY (cod_assistec);


--
-- TOC entry 3048 (class 2606 OID 23996)
-- Name: cod_chamada; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_cqi_chamada
    ADD CONSTRAINT cod_chamada PRIMARY KEY (cod_chamada);


--
-- TOC entry 3046 (class 2606 OID 23998)
-- Name: cod_comp; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_componente
    ADD CONSTRAINT cod_comp PRIMARY KEY (cod_comp);


--
-- TOC entry 3052 (class 2606 OID 24000)
-- Name: cod_cqi_reg; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_cqi_registro
    ADD CONSTRAINT cod_cqi_reg PRIMARY KEY (cod_cqi_reg);


--
-- TOC entry 3070 (class 2606 OID 24002)
-- Name: cod_cr; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_operador
    ADD CONSTRAINT cod_cr PRIMARY KEY (cod_cr);


--
-- TOC entry 3058 (class 2606 OID 24004)
-- Name: cod_gmp; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_gmp
    ADD CONSTRAINT cod_gmp PRIMARY KEY (cod_gmp);


--
-- TOC entry 3050 (class 2606 OID 24008)
-- Name: cod_lista; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_cqi_lista
    ADD CONSTRAINT cod_lista PRIMARY KEY (cod_lista);


--
-- TOC entry 3040 (class 2606 OID 24010)
-- Name: cod_prod; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_produto
    ADD CONSTRAINT cod_prod PRIMARY KEY (cod_prod);


--
-- TOC entry 3076 (class 2606 OID 24012)
-- Name: cod_sintoma; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_sintoma
    ADD CONSTRAINT cod_sintoma PRIMARY KEY (cod_sintoma);


--
-- TOC entry 3042 (class 2606 OID 24014)
-- Name: cod_status; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_status
    ADD CONSTRAINT cod_status PRIMARY KEY (cod_status);


--
-- TOC entry 3078 (class 2606 OID 24016)
-- Name: cod_tp_defeito; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_tp_defeito
    ADD CONSTRAINT cod_tp_defeito PRIMARY KEY (cod_tp_defeito);


--
-- TOC entry 3054 (class 2606 OID 24018)
-- Name: cod_veri; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_cqi_verifica
    ADD CONSTRAINT cod_veri PRIMARY KEY (cod_veri);


--
-- TOC entry 3056 (class 2606 OID 24022)
-- Name: tb_estrutura_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_estrutura
    ADD CONSTRAINT tb_estrutura_pkey PRIMARY KEY (escodigo, itcodigo);


--
-- TOC entry 3082 (class 2606 OID 5308779)
-- Name: tb_estrutura_prod_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_estrutura_prod
    ADD CONSTRAINT tb_estrutura_prod_pkey PRIMARY KEY (escodigo, itcodigo);


--
-- TOC entry 3060 (class 2606 OID 24024)
-- Name: tb_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_item
    ADD CONSTRAINT tb_item_pkey PRIMARY KEY (itcodigo);


--
-- TOC entry 3064 (class 2606 OID 24026)
-- Name: tb_op_nunser_nroseriefim_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_op_nunser
    ADD CONSTRAINT tb_op_nunser_nroseriefim_key UNIQUE (nroseriefim);


--
-- TOC entry 3066 (class 2606 OID 24028)
-- Name: tb_op_nunser_nroserieini_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_op_nunser
    ADD CONSTRAINT tb_op_nunser_nroserieini_key UNIQUE (nroserieini);


--
-- TOC entry 3068 (class 2606 OID 24030)
-- Name: tb_op_nunser_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_op_nunser
    ADD CONSTRAINT tb_op_nunser_pkey PRIMARY KEY (nroop);


--
-- TOC entry 3062 (class 2606 OID 24032)
-- Name: tb_op_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_op
    ADD CONSTRAINT tb_op_pkey PRIMARY KEY (op);


--
-- TOC entry 3072 (class 2606 OID 24034)
-- Name: tb_prod_gmp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_prod_gmp
    ADD CONSTRAINT tb_prod_gmp_pkey PRIMARY KEY (cod_prod_gmp);


--
-- TOC entry 3074 (class 2606 OID 24036)
-- Name: tb_qtd_produz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_qtd_produz
    ADD CONSTRAINT tb_qtd_produz_pkey PRIMARY KEY (cod_qtd);


--
-- TOC entry 3080 (class 2606 OID 24038)
-- Name: tb_tp_parada_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tb_tp_parada
    ADD CONSTRAINT tb_tp_parada_pkey PRIMARY KEY (cod_parada);


--
-- TOC entry 3096 (class 2606 OID 24039)
-- Name: cod_chamada; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_cqi_verifica
    ADD CONSTRAINT cod_chamada FOREIGN KEY (cod_chamada) REFERENCES tb_cqi_chamada(cod_chamada);


--
-- TOC entry 3098 (class 2606 OID 24044)
-- Name: cod_comp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_defeito
    ADD CONSTRAINT cod_comp FOREIGN KEY (cod_comp) REFERENCES tb_componente(cod_comp);


--
-- TOC entry 3093 (class 2606 OID 24049)
-- Name: cod_cqi_reg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_cqi_reg_status
    ADD CONSTRAINT cod_cqi_reg FOREIGN KEY (cod_cqi_reg) REFERENCES tb_cqi_registro(cod_cqi_reg);


--
-- TOC entry 3099 (class 2606 OID 24054)
-- Name: cod_cr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_defeito
    ADD CONSTRAINT cod_cr FOREIGN KEY (cod_cr) REFERENCES tb_operador(cod_cr);


--
-- TOC entry 3095 (class 2606 OID 24059)
-- Name: cod_cr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_cqi_registro
    ADD CONSTRAINT cod_cr FOREIGN KEY (cod_cr) REFERENCES tb_operador(cod_cr);


--
-- TOC entry 3083 (class 2606 OID 3797484)
-- Name: cod_cr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_registro
    ADD CONSTRAINT cod_cr FOREIGN KEY (cod_cr) REFERENCES tb_operador(cod_cr);


--
-- TOC entry 3105 (class 2606 OID 24074)
-- Name: cod_gmp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_prod_gmp
    ADD CONSTRAINT cod_gmp FOREIGN KEY (cod_gmp) REFERENCES tb_gmp(cod_gmp);


--
-- TOC entry 3084 (class 2606 OID 3797489)
-- Name: cod_gmp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_registro
    ADD CONSTRAINT cod_gmp FOREIGN KEY (cod_gmp) REFERENCES tb_gmp(cod_gmp);


--
-- TOC entry 3097 (class 2606 OID 24079)
-- Name: cod_lista; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_cqi_verifica
    ADD CONSTRAINT cod_lista FOREIGN KEY (cod_lista) REFERENCES tb_cqi_lista(cod_lista);


--
-- TOC entry 3100 (class 2606 OID 24089)
-- Name: cod_prod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_defeito
    ADD CONSTRAINT cod_prod FOREIGN KEY (cod_prod) REFERENCES tb_produto(cod_prod);


--
-- TOC entry 3092 (class 2606 OID 24094)
-- Name: cod_prod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_cqi_chamada
    ADD CONSTRAINT cod_prod FOREIGN KEY (cod_prod) REFERENCES tb_produto(cod_prod);


--
-- TOC entry 3085 (class 2606 OID 3797494)
-- Name: cod_prod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_registro
    ADD CONSTRAINT cod_prod FOREIGN KEY (cod_prod) REFERENCES tb_produto(cod_prod);


--
-- TOC entry 3101 (class 2606 OID 24099)
-- Name: cod_sintoma; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_defeito
    ADD CONSTRAINT cod_sintoma FOREIGN KEY (cod_sintoma) REFERENCES tb_sintoma(cod_sintoma);


--
-- TOC entry 3086 (class 2606 OID 3797499)
-- Name: cod_status; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_registro
    ADD CONSTRAINT cod_status FOREIGN KEY (cod_status) REFERENCES tb_status(cod_status);


--
-- TOC entry 3102 (class 2606 OID 24109)
-- Name: cod_tp_defeito; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_defeito
    ADD CONSTRAINT cod_tp_defeito FOREIGN KEY (cod_tp_defeito) REFERENCES tb_tp_defeito(cod_tp_defeito);


--
-- TOC entry 3094 (class 2606 OID 24114)
-- Name: cod_veri; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_cqi_reg_status
    ADD CONSTRAINT cod_veri FOREIGN KEY (cod_veri) REFERENCES tb_cqi_verifica(cod_veri);


--
-- TOC entry 3087 (class 2606 OID 24119)
-- Name: tb_assis_tec_cod_cr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_assis_tec
    ADD CONSTRAINT tb_assis_tec_cod_cr_fkey FOREIGN KEY (cod_cr) REFERENCES tb_operador(cod_cr);


--
-- TOC entry 3088 (class 2606 OID 24124)
-- Name: tb_assis_tec_cod_prod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_assis_tec
    ADD CONSTRAINT tb_assis_tec_cod_prod_fkey FOREIGN KEY (cod_prod) REFERENCES tb_produto(cod_prod);


--
-- TOC entry 3089 (class 2606 OID 4598563)
-- Name: tb_assistec_rep_cod_comp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_assistec_rep
    ADD CONSTRAINT tb_assistec_rep_cod_comp_fkey FOREIGN KEY (cod_comp) REFERENCES tb_componente(cod_comp);


--
-- TOC entry 3090 (class 2606 OID 4598568)
-- Name: tb_assistec_rep_cod_sintoma_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_assistec_rep
    ADD CONSTRAINT tb_assistec_rep_cod_sintoma_fkey FOREIGN KEY (cod_sintoma) REFERENCES tb_sintoma(cod_sintoma);


--
-- TOC entry 3091 (class 2606 OID 4598573)
-- Name: tb_assistec_rep_cod_tp_defeito_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_assistec_rep
    ADD CONSTRAINT tb_assistec_rep_cod_tp_defeito_fkey FOREIGN KEY (cod_tp_defeito) REFERENCES tb_tp_defeito(cod_tp_defeito);


--
-- TOC entry 3103 (class 2606 OID 24144)
-- Name: tb_estrutura_escodigo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_estrutura
    ADD CONSTRAINT tb_estrutura_escodigo_fkey FOREIGN KEY (escodigo) REFERENCES tb_item(itcodigo);


--
-- TOC entry 3104 (class 2606 OID 24149)
-- Name: tb_estrutura_itcodigo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_estrutura
    ADD CONSTRAINT tb_estrutura_itcodigo_fkey FOREIGN KEY (itcodigo) REFERENCES tb_item(itcodigo);


--
-- TOC entry 3112 (class 2606 OID 5308780)
-- Name: tb_estrutura_prod_escodigo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_estrutura_prod
    ADD CONSTRAINT tb_estrutura_prod_escodigo_fkey FOREIGN KEY (escodigo) REFERENCES tb_item(itcodigo);


--
-- TOC entry 3113 (class 2606 OID 5308785)
-- Name: tb_estrutura_prod_itcodigo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_estrutura_prod
    ADD CONSTRAINT tb_estrutura_prod_itcodigo_fkey FOREIGN KEY (itcodigo) REFERENCES tb_item(itcodigo);


--
-- TOC entry 3106 (class 2606 OID 24154)
-- Name: tb_prod_gmp_cod_prod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_prod_gmp
    ADD CONSTRAINT tb_prod_gmp_cod_prod_fkey FOREIGN KEY (cod_prod) REFERENCES tb_produto(cod_prod);


--
-- TOC entry 3107 (class 2606 OID 24159)
-- Name: tb_qtd_parada_cod_parada_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_qtd_parada
    ADD CONSTRAINT tb_qtd_parada_cod_parada_fkey FOREIGN KEY (cod_parada) REFERENCES tb_tp_parada(cod_parada);


--
-- TOC entry 3108 (class 2606 OID 24164)
-- Name: tb_qtd_parada_cod_qtd_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_qtd_parada
    ADD CONSTRAINT tb_qtd_parada_cod_qtd_fkey FOREIGN KEY (cod_qtd) REFERENCES tb_qtd_produz(cod_qtd);


--
-- TOC entry 3109 (class 2606 OID 24169)
-- Name: tb_qtd_prod_reg_cod_qtd_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_qtd_prod_reg
    ADD CONSTRAINT tb_qtd_prod_reg_cod_qtd_fkey FOREIGN KEY (cod_qtd) REFERENCES tb_qtd_produz(cod_qtd);


--
-- TOC entry 3110 (class 2606 OID 24174)
-- Name: tb_qtd_x_oper_cod_cr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_qtd_x_oper
    ADD CONSTRAINT tb_qtd_x_oper_cod_cr_fkey FOREIGN KEY (cod_cr) REFERENCES tb_operador(cod_cr);


--
-- TOC entry 3111 (class 2606 OID 87024)
-- Name: tb_qtd_x_oprod_cod_qtd_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tb_qtd_x_oprod
    ADD CONSTRAINT tb_qtd_x_oprod_cod_qtd_fkey FOREIGN KEY (cod_qtd) REFERENCES tb_qtd_produz(cod_qtd);


--
-- TOC entry 3227 (class 0 OID 0)
-- Dependencies: 51
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 3233 (class 0 OID 0)
-- Dependencies: 324
-- Name: tb_produto; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_produto FROM PUBLIC;
REVOKE ALL ON TABLE tb_produto FROM postgres;
GRANT ALL ON TABLE tb_produto TO postgres;
GRANT ALL ON TABLE tb_produto TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_produto TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_produto TO excluir;


--
-- TOC entry 3234 (class 0 OID 0)
-- Dependencies: 325
-- Name: tb_registro; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_registro FROM PUBLIC;
REVOKE ALL ON TABLE tb_registro FROM postgres;
GRANT ALL ON TABLE tb_registro TO postgres;
GRANT INSERT,UPDATE ON TABLE tb_registro TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_registro TO excluir;
GRANT SELECT,INSERT ON TABLE tb_registro TO consultar;


--
-- TOC entry 3235 (class 0 OID 0)
-- Dependencies: 326
-- Name: tb_status; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_status FROM PUBLIC;
REVOKE ALL ON TABLE tb_status FROM postgres;
GRANT ALL ON TABLE tb_status TO postgres;
GRANT SELECT ON TABLE tb_status TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_status TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_status TO excluir;


--
-- TOC entry 3237 (class 0 OID 0)
-- Dependencies: 327
-- Name: TB_STATUS_cod_status_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE "TB_STATUS_cod_status_seq" FROM PUBLIC;
REVOKE ALL ON SEQUENCE "TB_STATUS_cod_status_seq" FROM postgres;
GRANT ALL ON SEQUENCE "TB_STATUS_cod_status_seq" TO postgres;
GRANT SELECT ON SEQUENCE "TB_STATUS_cod_status_seq" TO consultar;
GRANT ALL ON SEQUENCE "TB_STATUS_cod_status_seq" TO PUBLIC;


--
-- TOC entry 3238 (class 0 OID 0)
-- Dependencies: 328
-- Name: tb_assis_tec; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_assis_tec FROM PUBLIC;
REVOKE ALL ON TABLE tb_assis_tec FROM postgres;
GRANT ALL ON TABLE tb_assis_tec TO postgres;
GRANT SELECT ON TABLE tb_assis_tec TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_assis_tec TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_assis_tec TO excluir;


--
-- TOC entry 3240 (class 0 OID 0)
-- Dependencies: 329
-- Name: tb_assis_tec_cod_assistec_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE tb_assis_tec_cod_assistec_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE tb_assis_tec_cod_assistec_seq FROM postgres;
GRANT ALL ON SEQUENCE tb_assis_tec_cod_assistec_seq TO postgres;
GRANT SELECT ON SEQUENCE tb_assis_tec_cod_assistec_seq TO consultar;
GRANT ALL ON SEQUENCE tb_assis_tec_cod_assistec_seq TO PUBLIC;


--
-- TOC entry 3241 (class 0 OID 0)
-- Dependencies: 330
-- Name: tb_assistec_rep; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_assistec_rep FROM PUBLIC;
REVOKE ALL ON TABLE tb_assistec_rep FROM postgres;
GRANT ALL ON TABLE tb_assistec_rep TO postgres;
GRANT SELECT ON TABLE tb_assistec_rep TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_assistec_rep TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_assistec_rep TO excluir;


--
-- TOC entry 3242 (class 0 OID 0)
-- Dependencies: 331
-- Name: tb_componente; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_componente FROM PUBLIC;
REVOKE ALL ON TABLE tb_componente FROM postgres;
GRANT ALL ON TABLE tb_componente TO postgres;
GRANT SELECT ON TABLE tb_componente TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_componente TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_componente TO excluir;


--
-- TOC entry 3243 (class 0 OID 0)
-- Dependencies: 332
-- Name: tb_cqi_chamada; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_cqi_chamada FROM PUBLIC;
REVOKE ALL ON TABLE tb_cqi_chamada FROM postgres;
GRANT ALL ON TABLE tb_cqi_chamada TO postgres;
GRANT SELECT ON TABLE tb_cqi_chamada TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_cqi_chamada TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_cqi_chamada TO excluir;


--
-- TOC entry 3245 (class 0 OID 0)
-- Dependencies: 333
-- Name: tb_cqi_chamada_cod_chamada_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE tb_cqi_chamada_cod_chamada_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE tb_cqi_chamada_cod_chamada_seq FROM postgres;
GRANT ALL ON SEQUENCE tb_cqi_chamada_cod_chamada_seq TO postgres;
GRANT SELECT ON SEQUENCE tb_cqi_chamada_cod_chamada_seq TO consultar;
GRANT ALL ON SEQUENCE tb_cqi_chamada_cod_chamada_seq TO PUBLIC;


--
-- TOC entry 3246 (class 0 OID 0)
-- Dependencies: 334
-- Name: tb_cqi_lista; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_cqi_lista FROM PUBLIC;
REVOKE ALL ON TABLE tb_cqi_lista FROM postgres;
GRANT ALL ON TABLE tb_cqi_lista TO postgres;
GRANT SELECT ON TABLE tb_cqi_lista TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_cqi_lista TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_cqi_lista TO excluir;


--
-- TOC entry 3248 (class 0 OID 0)
-- Dependencies: 335
-- Name: tb_cqi_lista_cod_lista_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE tb_cqi_lista_cod_lista_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE tb_cqi_lista_cod_lista_seq FROM postgres;
GRANT ALL ON SEQUENCE tb_cqi_lista_cod_lista_seq TO postgres;
GRANT SELECT ON SEQUENCE tb_cqi_lista_cod_lista_seq TO consultar;
GRANT ALL ON SEQUENCE tb_cqi_lista_cod_lista_seq TO PUBLIC;


--
-- TOC entry 3249 (class 0 OID 0)
-- Dependencies: 336
-- Name: tb_cqi_reg_status; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_cqi_reg_status FROM PUBLIC;
REVOKE ALL ON TABLE tb_cqi_reg_status FROM postgres;
GRANT ALL ON TABLE tb_cqi_reg_status TO postgres;
GRANT SELECT ON TABLE tb_cqi_reg_status TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_cqi_reg_status TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_cqi_reg_status TO excluir;


--
-- TOC entry 3250 (class 0 OID 0)
-- Dependencies: 337
-- Name: tb_cqi_registro; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_cqi_registro FROM PUBLIC;
REVOKE ALL ON TABLE tb_cqi_registro FROM postgres;
GRANT ALL ON TABLE tb_cqi_registro TO postgres;
GRANT SELECT ON TABLE tb_cqi_registro TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_cqi_registro TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_cqi_registro TO excluir;


--
-- TOC entry 3252 (class 0 OID 0)
-- Dependencies: 338
-- Name: tb_cqi_registro_cod_cqi_reg_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE tb_cqi_registro_cod_cqi_reg_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE tb_cqi_registro_cod_cqi_reg_seq FROM postgres;
GRANT ALL ON SEQUENCE tb_cqi_registro_cod_cqi_reg_seq TO postgres;
GRANT ALL ON SEQUENCE tb_cqi_registro_cod_cqi_reg_seq TO inserir;
GRANT SELECT ON SEQUENCE tb_cqi_registro_cod_cqi_reg_seq TO consultar;
GRANT ALL ON SEQUENCE tb_cqi_registro_cod_cqi_reg_seq TO PUBLIC;


--
-- TOC entry 3253 (class 0 OID 0)
-- Dependencies: 339
-- Name: tb_cqi_verifica; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_cqi_verifica FROM PUBLIC;
REVOKE ALL ON TABLE tb_cqi_verifica FROM postgres;
GRANT ALL ON TABLE tb_cqi_verifica TO postgres;
GRANT SELECT ON TABLE tb_cqi_verifica TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_cqi_verifica TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_cqi_verifica TO excluir;


--
-- TOC entry 3255 (class 0 OID 0)
-- Dependencies: 340
-- Name: tb_cqi_verifica_cod_veri_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE tb_cqi_verifica_cod_veri_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE tb_cqi_verifica_cod_veri_seq FROM postgres;
GRANT ALL ON SEQUENCE tb_cqi_verifica_cod_veri_seq TO postgres;
GRANT SELECT ON SEQUENCE tb_cqi_verifica_cod_veri_seq TO consultar;
GRANT ALL ON SEQUENCE tb_cqi_verifica_cod_veri_seq TO PUBLIC;


--
-- TOC entry 3257 (class 0 OID 0)
-- Dependencies: 341
-- Name: tb_defeito; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_defeito FROM PUBLIC;
REVOKE ALL ON TABLE tb_defeito FROM postgres;
GRANT ALL ON TABLE tb_defeito TO postgres;
GRANT SELECT ON TABLE tb_defeito TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_defeito TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_defeito TO excluir;


--
-- TOC entry 3258 (class 0 OID 0)
-- Dependencies: 342
-- Name: tb_estrutura; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_estrutura FROM PUBLIC;
REVOKE ALL ON TABLE tb_estrutura FROM postgres;
GRANT ALL ON TABLE tb_estrutura TO postgres;
GRANT SELECT ON TABLE tb_estrutura TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_estrutura TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_estrutura TO excluir;


--
-- TOC entry 3259 (class 0 OID 0)
-- Dependencies: 359
-- Name: tb_estrutura_prod; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_estrutura_prod FROM PUBLIC;
REVOKE ALL ON TABLE tb_estrutura_prod FROM postgres;
GRANT ALL ON TABLE tb_estrutura_prod TO postgres;
GRANT SELECT ON TABLE tb_estrutura_prod TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_estrutura_prod TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_estrutura_prod TO excluir;


--
-- TOC entry 3260 (class 0 OID 0)
-- Dependencies: 343
-- Name: tb_gmp; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_gmp FROM PUBLIC;
REVOKE ALL ON TABLE tb_gmp FROM postgres;
GRANT ALL ON TABLE tb_gmp TO postgres;
GRANT SELECT ON TABLE tb_gmp TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_gmp TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_gmp TO excluir;


--
-- TOC entry 3261 (class 0 OID 0)
-- Dependencies: 344
-- Name: tb_item; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_item FROM PUBLIC;
REVOKE ALL ON TABLE tb_item FROM postgres;
GRANT ALL ON TABLE tb_item TO postgres;
GRANT SELECT ON TABLE tb_item TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_item TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_item TO excluir;


--
-- TOC entry 3262 (class 0 OID 0)
-- Dependencies: 345
-- Name: tb_op; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_op FROM PUBLIC;
REVOKE ALL ON TABLE tb_op FROM postgres;
GRANT ALL ON TABLE tb_op TO postgres;
GRANT SELECT ON TABLE tb_op TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_op TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_op TO excluir;


--
-- TOC entry 3263 (class 0 OID 0)
-- Dependencies: 346
-- Name: tb_op_nunser; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_op_nunser FROM PUBLIC;
REVOKE ALL ON TABLE tb_op_nunser FROM postgres;
GRANT ALL ON TABLE tb_op_nunser TO postgres;
GRANT SELECT ON TABLE tb_op_nunser TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_op_nunser TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_op_nunser TO excluir;


--
-- TOC entry 3266 (class 0 OID 0)
-- Dependencies: 347
-- Name: tb_operador; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_operador FROM PUBLIC;
REVOKE ALL ON TABLE tb_operador FROM postgres;
GRANT ALL ON TABLE tb_operador TO postgres;
GRANT SELECT ON TABLE tb_operador TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_operador TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_operador TO excluir;


--
-- TOC entry 3267 (class 0 OID 0)
-- Dependencies: 348
-- Name: tb_prod_gmp; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_prod_gmp FROM PUBLIC;
REVOKE ALL ON TABLE tb_prod_gmp FROM postgres;
GRANT ALL ON TABLE tb_prod_gmp TO postgres;
GRANT SELECT ON TABLE tb_prod_gmp TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_prod_gmp TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_prod_gmp TO excluir;


--
-- TOC entry 3269 (class 0 OID 0)
-- Dependencies: 349
-- Name: tb_prod_gmp_cod_prod_gmp_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE tb_prod_gmp_cod_prod_gmp_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE tb_prod_gmp_cod_prod_gmp_seq FROM postgres;
GRANT ALL ON SEQUENCE tb_prod_gmp_cod_prod_gmp_seq TO postgres;
GRANT SELECT ON SEQUENCE tb_prod_gmp_cod_prod_gmp_seq TO consultar;
GRANT ALL ON SEQUENCE tb_prod_gmp_cod_prod_gmp_seq TO PUBLIC;


--
-- TOC entry 3270 (class 0 OID 0)
-- Dependencies: 350
-- Name: tb_qtd_parada; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_qtd_parada FROM PUBLIC;
REVOKE ALL ON TABLE tb_qtd_parada FROM postgres;
GRANT ALL ON TABLE tb_qtd_parada TO postgres;
GRANT SELECT ON TABLE tb_qtd_parada TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_qtd_parada TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_qtd_parada TO excluir;


--
-- TOC entry 3271 (class 0 OID 0)
-- Dependencies: 351
-- Name: tb_qtd_prod_reg; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_qtd_prod_reg FROM PUBLIC;
REVOKE ALL ON TABLE tb_qtd_prod_reg FROM postgres;
GRANT ALL ON TABLE tb_qtd_prod_reg TO postgres;
GRANT SELECT ON TABLE tb_qtd_prod_reg TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_qtd_prod_reg TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_qtd_prod_reg TO excluir;


--
-- TOC entry 3272 (class 0 OID 0)
-- Dependencies: 352
-- Name: tb_qtd_produz; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_qtd_produz FROM PUBLIC;
REVOKE ALL ON TABLE tb_qtd_produz FROM postgres;
GRANT ALL ON TABLE tb_qtd_produz TO postgres;
GRANT SELECT ON TABLE tb_qtd_produz TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_qtd_produz TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_qtd_produz TO excluir;


--
-- TOC entry 3274 (class 0 OID 0)
-- Dependencies: 353
-- Name: tb_qtd_produz_cod_qtd_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE tb_qtd_produz_cod_qtd_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE tb_qtd_produz_cod_qtd_seq FROM postgres;
GRANT ALL ON SEQUENCE tb_qtd_produz_cod_qtd_seq TO postgres;
GRANT SELECT ON SEQUENCE tb_qtd_produz_cod_qtd_seq TO consultar;
GRANT ALL ON SEQUENCE tb_qtd_produz_cod_qtd_seq TO PUBLIC;


--
-- TOC entry 3275 (class 0 OID 0)
-- Dependencies: 354
-- Name: tb_qtd_x_oper; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_qtd_x_oper FROM PUBLIC;
REVOKE ALL ON TABLE tb_qtd_x_oper FROM postgres;
GRANT ALL ON TABLE tb_qtd_x_oper TO postgres;
GRANT SELECT ON TABLE tb_qtd_x_oper TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_qtd_x_oper TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_qtd_x_oper TO excluir;


--
-- TOC entry 3276 (class 0 OID 0)
-- Dependencies: 355
-- Name: tb_qtd_x_oprod; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_qtd_x_oprod FROM PUBLIC;
REVOKE ALL ON TABLE tb_qtd_x_oprod FROM postgres;
GRANT ALL ON TABLE tb_qtd_x_oprod TO postgres;
GRANT SELECT ON TABLE tb_qtd_x_oprod TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_qtd_x_oprod TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_qtd_x_oprod TO excluir;


--
-- TOC entry 3277 (class 0 OID 0)
-- Dependencies: 356
-- Name: tb_sintoma; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_sintoma FROM PUBLIC;
REVOKE ALL ON TABLE tb_sintoma FROM postgres;
GRANT ALL ON TABLE tb_sintoma TO postgres;
GRANT SELECT ON TABLE tb_sintoma TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_sintoma TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_sintoma TO excluir;


--
-- TOC entry 3279 (class 0 OID 0)
-- Dependencies: 357
-- Name: tb_tp_defeito; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_tp_defeito FROM PUBLIC;
REVOKE ALL ON TABLE tb_tp_defeito FROM postgres;
GRANT ALL ON TABLE tb_tp_defeito TO postgres;
GRANT SELECT ON TABLE tb_tp_defeito TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_tp_defeito TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_tp_defeito TO excluir;


--
-- TOC entry 3280 (class 0 OID 0)
-- Dependencies: 358
-- Name: tb_tp_parada; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tb_tp_parada FROM PUBLIC;
REVOKE ALL ON TABLE tb_tp_parada FROM postgres;
GRANT ALL ON TABLE tb_tp_parada TO postgres;
GRANT SELECT,REFERENCES ON TABLE tb_tp_parada TO consultar;
GRANT INSERT,UPDATE ON TABLE tb_tp_parada TO inserir;
GRANT DELETE,UPDATE ON TABLE tb_tp_parada TO excluir;


-- Completed on 2014-03-12 15:09:12

--
-- PostgreSQL database dump complete
--

