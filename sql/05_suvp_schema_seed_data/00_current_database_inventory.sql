/*
File: 00_current_database_inventory.sql
Purpose: Capture the current dba_lab database structure before adding SUVP-compatible schema improvements and synthetic data.
Run on: db-primary / dba_lab
Execution tool: pgAdmin Query Tool
*/

-- ============================================================
-- Query 1: Confirm current database and server role
-- Expected on db-primary:
-- server_ip = 10.0.0.119
-- database_name = dba_lab
-- is_replica = false
-- ============================================================

SELECT
    inet_server_addr() AS server_ip,
    current_database() AS database_name,
    current_user AS connected_user,
    pg_is_in_recovery() AS is_replica;


-- ============================================================
-- Query 2: List non-system schemas
-- ============================================================

SELECT
    schema_name
FROM information_schema.schemata
WHERE schema_name NOT IN ('information_schema', 'pg_catalog')
  AND schema_name NOT LIKE 'pg_toast%'
ORDER BY schema_name;


-- ============================================================
-- Query 3: List user-created tables
-- ============================================================

SELECT
    table_schema,
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema NOT IN ('information_schema', 'pg_catalog')
ORDER BY table_schema, table_name;


-- ============================================================
-- Query 4: List columns for user-created tables
-- ============================================================

SELECT
    table_schema,
    table_name,
    ordinal_position,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema NOT IN ('information_schema', 'pg_catalog')
ORDER BY table_schema, table_name, ordinal_position;


-- ============================================================
-- Query 5: List primary keys, foreign keys, and unique constraints
-- ============================================================

SELECT
    tc.table_schema,
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    ccu.table_schema AS foreign_table_schema,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints tc
LEFT JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
   AND tc.table_schema = kcu.table_schema
LEFT JOIN information_schema.constraint_column_usage ccu
    ON tc.constraint_name = ccu.constraint_name
   AND tc.table_schema = ccu.table_schema
WHERE tc.table_schema NOT IN ('information_schema', 'pg_catalog')
ORDER BY tc.table_schema, tc.table_name, tc.constraint_type, tc.constraint_name;


-- ============================================================
-- Query 6: List indexes
-- ============================================================

SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY schemaname, tablename, indexname;


-- ============================================================
-- Query 7: Estimate row counts for user-created tables
-- ============================================================

SELECT
    schemaname,
    relname AS table_name,
    n_live_tup AS estimated_live_rows
FROM pg_stat_user_tables
ORDER BY schemaname, relname;