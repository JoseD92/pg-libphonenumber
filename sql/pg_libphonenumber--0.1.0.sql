-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION pg_libphonenumber" to load this file. \quit

CREATE TYPE phone_number;

--Basic function definitions

CREATE FUNCTION phone_number_in(cstring) RETURNS phone_number
    LANGUAGE c IMMUTABLE STRICT
    AS 'pg_libphonenumber', 'phone_number_in';

CREATE FUNCTION phone_number_out(phone_number) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS 'pg_libphonenumber', 'phone_number_out';

CREATE FUNCTION phone_number_recv(internal) RETURNS phone_number
    LANGUAGE c IMMUTABLE STRICT
    AS 'pg_libphonenumber', 'phone_number_recv';

CREATE FUNCTION phone_number_send(phone_number) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS 'pg_libphonenumber', 'phone_number_send';

CREATE TYPE phone_number (
    INTERNALLENGTH = 8,
    INPUT = phone_number_in,
    OUTPUT = phone_number_out,
    RECEIVE = phone_number_recv,
    SEND = phone_number_send,
    ALIGNMENT = double,
    STORAGE = plain
);

--Cast definitions

CREATE CAST (phone_number AS text)
    WITH INOUT;

--Operator definitions

CREATE FUNCTION phone_number_equal(phone_number, phone_number) RETURNS bool
    LANGUAGE c IMMUTABLE STRICT
    AS 'pg_libphonenumber', 'phone_number_equal';

CREATE OPERATOR = (
    leftarg = phone_number,
    rightarg = phone_number,
    procedure = phone_number_equal,
    commutator = =,
    negator = <>,
    restrict = eqsel,
    join = eqjoinsel,
    hashes = true,
    merges = true
);

CREATE FUNCTION phone_number_not_equal(phone_number, phone_number) RETURNS bool
    LANGUAGE c IMMUTABLE STRICT
    AS 'pg_libphonenumber', 'phone_number_not_equal';

CREATE OPERATOR <> (
    leftarg = phone_number,
    rightarg = phone_number,
    procedure = phone_number_not_equal,
    commutator = <>,
    negator = =,
    restrict = neqsel,
    join = neqjoinsel
);

CREATE FUNCTION phone_number_less(phone_number, phone_number) RETURNS bool
    LANGUAGE c IMMUTABLE STRICT
    AS 'pg_libphonenumber', 'phone_number_less';

CREATE OPERATOR < (
    leftarg = phone_number,
    rightarg = phone_number,
    procedure = phone_number_less,
    commutator = >,
    negator = >=,
    restrict = scalarltsel,
    join = scalarltjoinsel
);

CREATE FUNCTION phone_number_less_or_equal(phone_number, phone_number) RETURNS bool
    LANGUAGE c IMMUTABLE STRICT
    AS 'pg_libphonenumber', 'phone_number_less_or_equal';

CREATE OPERATOR <= (
    leftarg = phone_number,
    rightarg = phone_number,
    procedure = phone_number_less_or_equal,
    commutator = >=,
    negator = >,
    restrict = scalarltsel,
    join = scalarltjoinsel
);

CREATE FUNCTION phone_number_greater(phone_number, phone_number) RETURNS bool
    LANGUAGE c IMMUTABLE STRICT
    AS 'pg_libphonenumber', 'phone_number_greater';

CREATE OPERATOR > (
    leftarg = phone_number,
    rightarg = phone_number,
    procedure = phone_number_greater,
    commutator = >,
    negator = <=,
    restrict = scalargtsel,
    join = scalargtjoinsel
);

CREATE FUNCTION phone_number_greater_or_equal(phone_number, phone_number) RETURNS bool
    LANGUAGE c IMMUTABLE STRICT
    AS 'pg_libphonenumber', 'phone_number_greater_or_equal';

CREATE OPERATOR >= (
    leftarg = phone_number,
    rightarg = phone_number,
    procedure = phone_number_greater_or_equal,
    commutator = >=,
    negator = <,
    restrict = scalargtsel,
    join = scalargtjoinsel
);

CREATE FUNCTION phone_number_cmp(phone_number, phone_number) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS 'pg_libphonenumber', 'phone_number_cmp';

CREATE OPERATOR CLASS phone_number_ops
    DEFAULT FOR TYPE phone_number USING btree AS
        OPERATOR 1 <,
        OPERATOR 2 <=,
        OPERATOR 3 =,
        OPERATOR 4 >=,
        OPERATOR 5 >,
        FUNCTION 1 phone_number_cmp(phone_number, phone_number);

--General functions

CREATE FUNCTION parse_phone_number(text, text) RETURNS phone_number
    LANGUAGE c IMMUTABLE STRICT
    AS 'pg_libphonenumber', 'parse_phone_number';

