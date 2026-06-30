/*
File: 01_constraint_definitions.sql
Purpose: Capture exact CHECK, PRIMARY KEY, FOREIGN KEY, and UNIQUE constraint definitions before inserting synthetic SUVP data.
Run on: db-primary / dba_lab
Execution tool: pgAdmin Query Tool
*/

SELECT
    n.nspname AS schema_name,
    c.relname AS table_name,
    con.conname AS constraint_name,
    CASE con.contype
        WHEN 'c' THEN 'CHECK'
        WHEN 'f' THEN 'FOREIGN KEY'
        WHEN 'p' THEN 'PRIMARY KEY'
        WHEN 'u' THEN 'UNIQUE'
        ELSE con.contype::text
    END AS constraint_type,
    pg_get_constraintdef(con.oid, true) AS constraint_definition
FROM pg_constraint con
JOIN pg_class c
    ON c.oid = con.conrelid
JOIN pg_namespace n
    ON n.oid = c.relnamespace
WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
ORDER BY
    n.nspname,
    c.relname,
    constraint_type,
    con.conname;