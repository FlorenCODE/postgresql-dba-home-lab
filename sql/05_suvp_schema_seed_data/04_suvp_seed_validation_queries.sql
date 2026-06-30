-- ============================================================
-- Step 15: Validate audit events on db-primary
-- Screenshot:
--   2026-06-29_15_db-primary_suvp_seed_validation_audit_events.png
-- CSV:
--   2026-06-29_15_db-primary_suvp_seed_validation_audit_events.csv
-- ============================================================

SELECT
    audit_event_id,
    actor_role,
    event_type,
    actor_instructor_id,
    actor_student_id,
    course_id,
    session_id,
    event_summary,
    event_details,
    occurred_at
FROM audit.audit_events
ORDER BY audit_event_id DESC
LIMIT 15;