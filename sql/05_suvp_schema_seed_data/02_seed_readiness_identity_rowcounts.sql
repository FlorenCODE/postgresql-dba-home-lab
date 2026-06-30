/*
File: 02_seed_readiness_identity_rowcounts.sql
Purpose: Confirm identity/default behavior for primary key columns and capture current exact row counts before inserting synthetic SUVP seed data.
Run on: db-primary / dba_lab
Execution tool: pgAdmin Query Tool
*/

-- ============================================================
-- Query 1: Check whether ID columns are generated automatically
-- ============================================================

SELECT
    table_schema,
    table_name,
    column_name,
    data_type,
    is_identity,
    identity_generation,
    column_default
FROM information_schema.columns
WHERE table_schema IN ('app', 'audit', 'security', 'lab_admin')
  AND (
        column_name LIKE '%_id'
        OR column_name IN (
            'audit_event_id',
            'app_role_id',
            'app_permission_id',
            'role_permission_id',
            'user_role_assignment_id',
            'heartbeat_id'
        )
      )
ORDER BY
    table_schema,
    table_name,
    ordinal_position;


-- ============================================================
-- Query 2: Capture exact current row counts before seeding
-- ============================================================

SELECT 'app.instructors' AS table_name, COUNT(*) AS row_count FROM app.instructors
UNION ALL
SELECT 'app.students', COUNT(*) FROM app.students
UNION ALL
SELECT 'app.courses', COUNT(*) FROM app.courses
UNION ALL
SELECT 'app.course_enrollments', COUNT(*) FROM app.course_enrollments
UNION ALL
SELECT 'app.assessment_sessions', COUNT(*) FROM app.assessment_sessions
UNION ALL
SELECT 'app.student_responses', COUNT(*) FROM app.student_responses
UNION ALL
SELECT 'app.understanding_reports', COUNT(*) FROM app.understanding_reports
UNION ALL
SELECT 'audit.audit_events', COUNT(*) FROM audit.audit_events
UNION ALL
SELECT 'security.app_roles', COUNT(*) FROM security.app_roles
UNION ALL
SELECT 'security.app_permissions', COUNT(*) FROM security.app_permissions
UNION ALL
SELECT 'security.role_permissions', COUNT(*) FROM security.role_permissions
UNION ALL
SELECT 'security.user_role_assignments', COUNT(*) FROM security.user_role_assignments
UNION ALL
SELECT 'lab_admin.replication_heartbeat', COUNT(*) FROM lab_admin.replication_heartbeat
ORDER BY table_name;