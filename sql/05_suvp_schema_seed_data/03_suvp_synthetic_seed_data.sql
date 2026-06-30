/*
File: 03_suvp_synthetic_seed_data.sql
Purpose: Insert synthetic SUVP-compatible data into the existing DBA lab schema.
Run on: db-primary / dba_lab only
Execution tool: pgAdmin Query Tool

Safety notes:
- Uses synthetic, non-real student/instructor data.
- Uses natural unique keys and ON CONFLICT where constraints exist.
- Avoids manually inserting GENERATED ALWAYS identity columns.
- Designed to be safe to rerun for base entities.
*/

BEGIN;

-- ============================================================
-- 1. Security roles
-- ============================================================

INSERT INTO security.app_roles (
    role_code,
    role_name,
    role_description,
    is_active
)
VALUES
    ('instructor', 'Instructor', 'Can assign assessments, review understanding reports, and release feedback.', true),
    ('student', 'Student', 'Can complete assigned understanding verification assessments.', true),
    ('admin', 'Administrator', 'Can manage platform settings, roles, and operational controls.', true),
    ('reviewer', 'Reviewer', 'Can review assessment outcomes and support instructional quality checks.', true)
ON CONFLICT (role_code) DO UPDATE
SET
    role_name = EXCLUDED.role_name,
    role_description = EXCLUDED.role_description,
    is_active = EXCLUDED.is_active;


-- ============================================================
-- 2. Security permissions
-- ============================================================

INSERT INTO security.app_permissions (
    permission_code,
    permission_name,
    permission_description
)
VALUES
    ('assign_assessment', 'Assign Assessment', 'Create and assign student understanding verification sessions.'),
    ('complete_assessment', 'Complete Assessment', 'Submit written and/or oral assessment responses.'),
    ('view_own_feedback', 'View Own Feedback', 'View feedback released by an instructor.'),
    ('view_understanding_report', 'View Understanding Report', 'View AI-supported understanding reports.'),
    ('save_instructor_review', 'Save Instructor Review', 'Record instructor review decisions and notes.'),
    ('release_feedback', 'Release Feedback', 'Release reviewed feedback to students.'),
    ('view_dashboard', 'View Dashboard', 'View instructional dashboards and aggregate reporting.'),
    ('manage_security', 'Manage Security', 'Manage roles, permissions, and user role assignments.'),
    ('view_audit_events', 'View Audit Events', 'View audit events and operational records.')
ON CONFLICT (permission_code) DO UPDATE
SET
    permission_name = EXCLUDED.permission_name,
    permission_description = EXCLUDED.permission_description;


-- ============================================================
-- 3. Role-permission mapping
-- ============================================================

WITH role_permission_seed AS (
    SELECT *
    FROM (VALUES
        ('instructor', 'assign_assessment'),
        ('instructor', 'view_understanding_report'),
        ('instructor', 'save_instructor_review'),
        ('instructor', 'release_feedback'),
        ('instructor', 'view_dashboard'),
        ('instructor', 'view_audit_events'),

        ('student', 'complete_assessment'),
        ('student', 'view_own_feedback'),

        ('reviewer', 'view_understanding_report'),
        ('reviewer', 'save_instructor_review'),
        ('reviewer', 'view_dashboard'),
        ('reviewer', 'view_audit_events'),

        ('admin', 'assign_assessment'),
        ('admin', 'complete_assessment'),
        ('admin', 'view_own_feedback'),
        ('admin', 'view_understanding_report'),
        ('admin', 'save_instructor_review'),
        ('admin', 'release_feedback'),
        ('admin', 'view_dashboard'),
        ('admin', 'manage_security'),
        ('admin', 'view_audit_events')
    ) AS v(role_code, permission_code)
)
INSERT INTO security.role_permissions (
    app_role_id,
    app_permission_id
)
SELECT
    r.app_role_id,
    p.app_permission_id
FROM role_permission_seed seed
JOIN security.app_roles r
    ON r.role_code = seed.role_code
JOIN security.app_permissions p
    ON p.permission_code = seed.permission_code
ON CONFLICT (app_role_id, app_permission_id) DO NOTHING;


-- ============================================================
-- 4. Synthetic instructors
-- ============================================================

INSERT INTO app.instructors (
    employee_number,
    first_name,
    last_name,
    email,
    department,
    active
)
VALUES
    ('SYN-INST-001', 'Maya', 'Chen', 'maya.chen.synthetic@suvp-lab.example', 'School of Business - Data Analytics', true),
    ('SYN-INST-002', 'Daniel', 'Brooks', 'daniel.brooks.synthetic@suvp-lab.example', 'School of Business - Management', true),
    ('SYN-INST-003', 'Alicia', 'Rivera', 'alicia.rivera.synthetic@suvp-lab.example', 'School of Business - Economics', true)
ON CONFLICT (employee_number) DO UPDATE
SET
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    email = EXCLUDED.email,
    department = EXCLUDED.department,
    active = EXCLUDED.active;


-- ============================================================
-- 5. Synthetic students
-- ============================================================

INSERT INTO app.students (
    student_number,
    first_name,
    last_name,
    email,
    active
)
VALUES
    ('SYN-STU-001', 'Jordan', 'Lee', 'jordan.lee.synthetic@suvp-lab.example', true),
    ('SYN-STU-002', 'Priya', 'Patel', 'priya.patel.synthetic@suvp-lab.example', true),
    ('SYN-STU-003', 'Marcus', 'Johnson', 'marcus.johnson.synthetic@suvp-lab.example', true),
    ('SYN-STU-004', 'Elena', 'Garcia', 'elena.garcia.synthetic@suvp-lab.example', true),
    ('SYN-STU-005', 'Noah', 'Kim', 'noah.kim.synthetic@suvp-lab.example', true),
    ('SYN-STU-006', 'Amara', 'Wilson', 'amara.wilson.synthetic@suvp-lab.example', true),
    ('SYN-STU-007', 'Sophia', 'Nguyen', 'sophia.nguyen.synthetic@suvp-lab.example', true),
    ('SYN-STU-008', 'Ethan', 'Miller', 'ethan.miller.synthetic@suvp-lab.example', true)
ON CONFLICT (student_number) DO UPDATE
SET
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    email = EXCLUDED.email,
    active = EXCLUDED.active;


-- ============================================================
-- 6. Synthetic courses
-- ============================================================

WITH course_seed AS (
    SELECT *
    FROM (VALUES
        ('SUVP-ADS-501', 'Applied Data Science for Business - Synthetic Lab', 'Summer', 2026, 'SYN-INST-001', true),
        ('SUVP-MGMT-310', 'Management Decision-Making - Synthetic Lab', 'Summer', 2026, 'SYN-INST-002', true),
        ('SUVP-ECON-220', 'Microeconomics Analysis - Synthetic Lab', 'Summer', 2026, 'SYN-INST-003', true)
    ) AS v(course_code, course_title, term, academic_year, employee_number, active)
)
INSERT INTO app.courses (
    course_code,
    course_title,
    term,
    academic_year,
    instructor_id,
    active
)
SELECT
    seed.course_code,
    seed.course_title,
    seed.term,
    seed.academic_year,
    i.instructor_id,
    seed.active
FROM course_seed seed
JOIN app.instructors i
    ON i.employee_number = seed.employee_number
ON CONFLICT (course_code, term, academic_year) DO UPDATE
SET
    course_title = EXCLUDED.course_title,
    instructor_id = EXCLUDED.instructor_id,
    active = EXCLUDED.active;


-- ============================================================
-- 7. Synthetic enrollments
-- ============================================================

WITH enrollment_seed AS (
    SELECT *
    FROM (VALUES
        ('SUVP-ADS-501', 'Summer', 2026, 'SYN-STU-001', 'active'),
        ('SUVP-ADS-501', 'Summer', 2026, 'SYN-STU-002', 'active'),
        ('SUVP-ADS-501', 'Summer', 2026, 'SYN-STU-003', 'active'),
        ('SUVP-ADS-501', 'Summer', 2026, 'SYN-STU-004', 'active'),

        ('SUVP-MGMT-310', 'Summer', 2026, 'SYN-STU-003', 'active'),
        ('SUVP-MGMT-310', 'Summer', 2026, 'SYN-STU-004', 'completed'),
        ('SUVP-MGMT-310', 'Summer', 2026, 'SYN-STU-005', 'active'),
        ('SUVP-MGMT-310', 'Summer', 2026, 'SYN-STU-006', 'inactive'),

        ('SUVP-ECON-220', 'Summer', 2026, 'SYN-STU-001', 'active'),
        ('SUVP-ECON-220', 'Summer', 2026, 'SYN-STU-007', 'active'),
        ('SUVP-ECON-220', 'Summer', 2026, 'SYN-STU-008', 'active')
    ) AS v(course_code, term, academic_year, student_number, enrollment_status)
)
INSERT INTO app.course_enrollments (
    course_id,
    student_id,
    enrollment_status
)
SELECT
    c.course_id,
    s.student_id,
    seed.enrollment_status
FROM enrollment_seed seed
JOIN app.courses c
    ON c.course_code = seed.course_code
   AND c.term = seed.term
   AND c.academic_year = seed.academic_year
JOIN app.students s
    ON s.student_number = seed.student_number
ON CONFLICT (course_id, student_id) DO UPDATE
SET
    enrollment_status = EXCLUDED.enrollment_status;


-- ============================================================
-- 8. Synthetic assessment sessions
--    There is no unique constraint on assessment_sessions, so this
--    block prevents duplicates by checking for the same course,
--    student, assessment type, and prompt.
-- ============================================================

WITH session_seed AS (
    SELECT *
    FROM (VALUES
        (
            'SUVP-ADS-501',
            'Summer',
            2026,
            'SYN-STU-001',
            'SYN-INST-001',
            'feedback_released',
            'written_reflection',
            'Synthetic seed prompt 001: Explain how a business analyst should validate AI-generated conclusions before using them in a decision.',
            'Students may use AI for drafting support but must explain concepts in their own words.',
            now() - interval '10 days',
            now() - interval '9 days'
        ),
        (
            'SUVP-ADS-501',
            'Summer',
            2026,
            'SYN-STU-002',
            'SYN-INST-001',
            'reviewed',
            'written_and_oral',
            'Synthetic seed prompt 002: Interpret a dashboard trend and explain which business action is justified by the evidence.',
            'Students may use AI for brainstorming but must defend the reasoning independently.',
            now() - interval '8 days',
            now() - interval '7 days'
        ),
        (
            'SUVP-ADS-501',
            'Summer',
            2026,
            'SYN-STU-003',
            'SYN-INST-001',
            'submitted',
            'adaptive_followup',
            'Synthetic seed prompt 003: Identify a weak assumption in a machine-generated recommendation and propose a follow-up question.',
            'AI use is allowed only for comparison after the student writes an initial answer.',
            now() - interval '5 days',
            now() - interval '4 days'
        ),
        (
            'SUVP-ADS-501',
            'Summer',
            2026,
            'SYN-STU-004',
            'SYN-INST-001',
            'in_progress',
            'written_reflection',
            'Synthetic seed prompt 004: Explain the difference between correlation and causation in a business analytics scenario.',
            'AI use must be disclosed by the student.',
            now() - interval '2 days',
            NULL::timestamptz
        ),
        (
            'SUVP-MGMT-310',
            'Summer',
            2026,
            'SYN-STU-005',
            'SYN-INST-002',
            'feedback_released',
            'oral_defense',
            'Synthetic seed prompt 005: Defend a management decision using trade-off analysis and stakeholder impact.',
            'Students may prepare notes but must answer oral defense questions live.',
            now() - interval '12 days',
            now() - interval '11 days'
        ),
        (
            'SUVP-MGMT-310',
            'Summer',
            2026,
            'SYN-STU-006',
            'SYN-INST-002',
            'cancelled',
            'written_reflection',
            'Synthetic seed prompt 006: Explain why the assigned case analysis was cancelled and how the session should be rescheduled.',
            'No AI use policy applied because the session was cancelled.',
            now() - interval '3 days',
            NULL::timestamptz
        ),
        (
            'SUVP-ECON-220',
            'Summer',
            2026,
            'SYN-STU-007',
            'SYN-INST-003',
            'reviewed',
            'written_reflection',
            'Synthetic seed prompt 007: Explain opportunity cost using a small business pricing decision.',
            'Students may use AI as a study aid but must provide their own example.',
            now() - interval '9 days',
            now() - interval '8 days'
        ),
        (
            'SUVP-ECON-220',
            'Summer',
            2026,
            'SYN-STU-008',
            'SYN-INST-003',
            'assigned',
            'written_reflection',
            'Synthetic seed prompt 008: Describe how supply and demand changes could affect a local market.',
            'AI use is not permitted for this assigned checkpoint.',
            now() - interval '1 day',
            NULL::timestamptz
        )
    ) AS v(
        course_code,
        term,
        academic_year,
        student_number,
        instructor_employee_number,
        session_status,
        assessment_type,
        assignment_prompt,
        ai_use_policy,
        assigned_at,
        submitted_at
    )
)
INSERT INTO app.assessment_sessions (
    course_id,
    student_id,
    assigned_by_instructor_id,
    session_status,
    assessment_type,
    assignment_prompt,
    ai_use_policy,
    assigned_at,
    submitted_at
)
SELECT
    c.course_id,
    s.student_id,
    i.instructor_id,
    seed.session_status,
    seed.assessment_type,
    seed.assignment_prompt,
    seed.ai_use_policy,
    seed.assigned_at,
    seed.submitted_at
FROM session_seed seed
JOIN app.courses c
    ON c.course_code = seed.course_code
   AND c.term = seed.term
   AND c.academic_year = seed.academic_year
JOIN app.students s
    ON s.student_number = seed.student_number
JOIN app.instructors i
    ON i.employee_number = seed.instructor_employee_number
WHERE NOT EXISTS (
    SELECT 1
    FROM app.assessment_sessions existing
    WHERE existing.course_id = c.course_id
      AND existing.student_id = s.student_id
      AND existing.assessment_type = seed.assessment_type
      AND existing.assignment_prompt = seed.assignment_prompt
);


-- ============================================================
-- 9. Synthetic student responses
-- ============================================================

WITH response_seed AS (
    SELECT *
    FROM (VALUES
        (
            'Synthetic seed prompt 001: Explain how a business analyst should validate AI-generated conclusions before using them in a decision.',
            'Synthetic seed response: A business analyst should verify the data source, compare the AI output against known business rules, test for bias, and explain the reasoning before using the conclusion in a decision.',
            NULL::text
        ),
        (
            'Synthetic seed prompt 002: Interpret a dashboard trend and explain which business action is justified by the evidence.',
            'Synthetic seed response: The dashboard trend should be compared with historical baselines and segmented by customer group before recommending action. A justified action is one tied directly to the evidence instead of a general assumption.',
            'Synthetic oral transcript: The student explained that a dashboard is not proof by itself and that the analyst should ask whether seasonality or sample size affected the trend.'
        ),
        (
            'Synthetic seed prompt 003: Identify a weak assumption in a machine-generated recommendation and propose a follow-up question.',
            'Synthetic seed response: One weak assumption is that past customer behavior will continue unchanged. A follow-up question should ask whether new competitors, pricing changes, or seasonality could change the recommendation.',
            NULL::text
        ),
        (
            'Synthetic seed prompt 005: Defend a management decision using trade-off analysis and stakeholder impact.',
            NULL::text,
            'Synthetic oral transcript: The student defended the decision by comparing operational cost, customer impact, and employee workload. The response showed partial reasoning but needed a clearer link to measurable outcomes.'
        ),
        (
            'Synthetic seed prompt 007: Explain opportunity cost using a small business pricing decision.',
            'Synthetic seed response: Opportunity cost is the value of the next best alternative. If a business lowers prices to gain customers, the opportunity cost may be the lost margin it could have earned at the original price.',
            NULL::text
        )
    ) AS v(assignment_prompt, written_response, oral_transcript)
)
INSERT INTO app.student_responses (
    session_id,
    written_response,
    oral_transcript
)
SELECT
    s.session_id,
    seed.written_response,
    seed.oral_transcript
FROM response_seed seed
JOIN app.assessment_sessions s
    ON s.assignment_prompt = seed.assignment_prompt
WHERE NOT EXISTS (
    SELECT 1
    FROM app.student_responses existing
    WHERE existing.session_id = s.session_id
      AND (
            existing.written_response LIKE 'Synthetic seed response:%'
         OR existing.oral_transcript LIKE 'Synthetic oral transcript:%'
      )
);


-- ============================================================
-- 10. Synthetic understanding reports
-- ============================================================

WITH report_seed AS (
    SELECT *
    FROM (VALUES
        (
            'Synthetic seed prompt 001: Explain how a business analyst should validate AI-generated conclusions before using them in a decision.',
            91.50,
            'strong',
            'Clearly identified validation, business rules, bias review, and explainability.',
            'Could provide a more detailed example of testing against a real dataset.',
            'Ask the student to demonstrate a quick validation checklist on a sample dashboard.',
            'synthetic_seed'
        ),
        (
            'Synthetic seed prompt 002: Interpret a dashboard trend and explain which business action is justified by the evidence.',
            84.00,
            'moderate',
            'Recognized the need for baselines, segmentation, and evidence-based decisions.',
            'Needs stronger explanation of causality limits and confidence in the trend.',
            'Ask a follow-up question about sample size, seasonality, and alternative explanations.',
            'synthetic_seed'
        ),
        (
            'Synthetic seed prompt 003: Identify a weak assumption in a machine-generated recommendation and propose a follow-up question.',
            76.25,
            'needs_review',
            'Identified a plausible weak assumption and proposed relevant follow-up areas.',
            'The reasoning is directionally correct but needs more precision and stronger domain vocabulary.',
            'Assign an adaptive follow-up asking the student to evaluate one competing explanation.',
            'synthetic_seed'
        ),
        (
            'Synthetic seed prompt 005: Defend a management decision using trade-off analysis and stakeholder impact.',
            68.00,
            'weak',
            'Mentioned multiple stakeholder groups and basic trade-offs.',
            'The answer lacks measurable criteria and does not clearly defend the final decision.',
            'Schedule an oral follow-up focused on measurable outcomes and stakeholder prioritization.',
            'synthetic_seed'
        ),
        (
            'Synthetic seed prompt 007: Explain opportunity cost using a small business pricing decision.',
            88.75,
            'strong',
            'Accurately explained opportunity cost and tied it to pricing and lost margin.',
            'Could expand by comparing short-term and long-term trade-offs.',
            'Ask the student to apply the concept to a second business scenario.',
            'synthetic_seed'
        )
    ) AS v(
        assignment_prompt,
        overall_score,
        understanding_level,
        strengths,
        gaps,
        recommended_follow_up,
        generated_by
    )
)
INSERT INTO app.understanding_reports (
    session_id,
    overall_score,
    understanding_level,
    strengths,
    gaps,
    recommended_follow_up,
    generated_by
)
SELECT
    s.session_id,
    seed.overall_score,
    seed.understanding_level,
    seed.strengths,
    seed.gaps,
    seed.recommended_follow_up,
    seed.generated_by
FROM report_seed seed
JOIN app.assessment_sessions s
    ON s.assignment_prompt = seed.assignment_prompt
ON CONFLICT (session_id) DO UPDATE
SET
    overall_score = EXCLUDED.overall_score,
    understanding_level = EXCLUDED.understanding_level,
    strengths = EXCLUDED.strengths,
    gaps = EXCLUDED.gaps,
    recommended_follow_up = EXCLUDED.recommended_follow_up,
    generated_by = EXCLUDED.generated_by;


-- ============================================================
-- 11. Synthetic user role assignments
--    There is no unique constraint on user_role_assignments, so
--    this block prevents duplicates with NOT EXISTS checks.
-- ============================================================

WITH instructor_role_seed AS (
    SELECT *
    FROM (VALUES
        ('SYN-INST-001', 'instructor', NULL::text),
        ('SYN-INST-002', 'instructor', 'SYN-INST-001'),
        ('SYN-INST-003', 'instructor', 'SYN-INST-001')
    ) AS v(employee_number, role_code, assigned_by_employee_number)
),
instructor_assignments AS (
    INSERT INTO security.user_role_assignments (
        app_role_id,
        instructor_id,
        assigned_by_instructor_id,
        assignment_reason
    )
    SELECT
        r.app_role_id,
        i.instructor_id,
        assigned_by.instructor_id,
        'Synthetic seed role assignment for DBA lab portfolio.'
    FROM instructor_role_seed seed
    JOIN security.app_roles r
        ON r.role_code = seed.role_code
    JOIN app.instructors i
        ON i.employee_number = seed.employee_number
    LEFT JOIN app.instructors assigned_by
        ON assigned_by.employee_number = seed.assigned_by_employee_number
    WHERE NOT EXISTS (
        SELECT 1
        FROM security.user_role_assignments existing
        WHERE existing.app_role_id = r.app_role_id
          AND existing.instructor_id = i.instructor_id
          AND existing.student_id IS NULL
          AND existing.revoked_at IS NULL
    )
    RETURNING user_role_assignment_id
),
student_role_seed AS (
    SELECT *
    FROM (VALUES
        ('SYN-STU-001', 'student', 'SYN-INST-001'),
        ('SYN-STU-002', 'student', 'SYN-INST-001'),
        ('SYN-STU-003', 'student', 'SYN-INST-001'),
        ('SYN-STU-004', 'student', 'SYN-INST-001'),
        ('SYN-STU-005', 'student', 'SYN-INST-002'),
        ('SYN-STU-006', 'student', 'SYN-INST-002'),
        ('SYN-STU-007', 'student', 'SYN-INST-003'),
        ('SYN-STU-008', 'student', 'SYN-INST-003')
    ) AS v(student_number, role_code, assigned_by_employee_number)
)
INSERT INTO security.user_role_assignments (
    app_role_id,
    student_id,
    assigned_by_instructor_id,
    assignment_reason
)
SELECT
    r.app_role_id,
    s.student_id,
    assigned_by.instructor_id,
    'Synthetic seed role assignment for DBA lab portfolio.'
FROM student_role_seed seed
JOIN security.app_roles r
    ON r.role_code = seed.role_code
JOIN app.students s
    ON s.student_number = seed.student_number
LEFT JOIN app.instructors assigned_by
    ON assigned_by.employee_number = seed.assigned_by_employee_number
WHERE NOT EXISTS (
    SELECT 1
    FROM security.user_role_assignments existing
    WHERE existing.app_role_id = r.app_role_id
      AND existing.student_id = s.student_id
      AND existing.instructor_id IS NULL
      AND existing.revoked_at IS NULL
);


-- ============================================================
-- 12. Synthetic audit events
-- ============================================================

WITH audit_seed AS (
    SELECT *
    FROM (VALUES
        (
            'synthetic_seed_started',
            'system',
            NULL::text,
            NULL::text,
            NULL::text,
            NULL::text,
            'Synthetic seed batch started for SUVP-compatible DBA lab data.',
            jsonb_build_object('seed_batch', 'SUVP_SYNTHETIC_SEED_2026_06_29', 'portfolio_section', 'schema_seed_data')
        ),
        (
            'assessment_assigned',
            'instructor',
            'SYN-INST-001',
            NULL::text,
            'SUVP-ADS-501',
            'Synthetic seed prompt 001: Explain how a business analyst should validate AI-generated conclusions before using them in a decision.',
            'Synthetic instructor assigned an understanding verification session.',
            jsonb_build_object('seed_batch', 'SUVP_SYNTHETIC_SEED_2026_06_29', 'assessment_type', 'written_reflection')
        ),
        (
            'assessment_submitted',
            'student',
            NULL::text,
            'SYN-STU-001',
            'SUVP-ADS-501',
            'Synthetic seed prompt 001: Explain how a business analyst should validate AI-generated conclusions before using them in a decision.',
            'Synthetic student submitted a written response.',
            jsonb_build_object('seed_batch', 'SUVP_SYNTHETIC_SEED_2026_06_29', 'submission_channel', 'pgadmin_seed')
        ),
        (
            'understanding_report_generated',
            'system',
            NULL::text,
            'SYN-STU-001',
            'SUVP-ADS-501',
            'Synthetic seed prompt 001: Explain how a business analyst should validate AI-generated conclusions before using them in a decision.',
            'Synthetic understanding report generated for portfolio dataset.',
            jsonb_build_object('seed_batch', 'SUVP_SYNTHETIC_SEED_2026_06_29', 'generated_by', 'synthetic_seed')
        ),
        (
            'feedback_released',
            'instructor',
            'SYN-INST-001',
            'SYN-STU-001',
            'SUVP-ADS-501',
            'Synthetic seed prompt 001: Explain how a business analyst should validate AI-generated conclusions before using them in a decision.',
            'Synthetic instructor released feedback to the student.',
            jsonb_build_object('seed_batch', 'SUVP_SYNTHETIC_SEED_2026_06_29', 'release_status', 'feedback_released')
        ),
        (
            'adaptive_followup_flagged',
            'reviewer',
            'SYN-INST-001',
            'SYN-STU-003',
            'SUVP-ADS-501',
            'Synthetic seed prompt 003: Identify a weak assumption in a machine-generated recommendation and propose a follow-up question.',
            'Synthetic assessment flagged for adaptive follow-up because understanding needs review.',
            jsonb_build_object('seed_batch', 'SUVP_SYNTHETIC_SEED_2026_06_29', 'understanding_level', 'needs_review')
        ),
        (
            'synthetic_seed_completed',
            'system',
            NULL::text,
            NULL::text,
            NULL::text,
            NULL::text,
            'Synthetic seed batch completed for SUVP-compatible DBA lab data.',
            jsonb_build_object('seed_batch', 'SUVP_SYNTHETIC_SEED_2026_06_29', 'portfolio_section', 'schema_seed_data')
        )
    ) AS v(
        event_type,
        actor_role,
        instructor_employee_number,
        student_number,
        course_code,
        assignment_prompt,
        event_summary,
        event_details
    )
)
INSERT INTO audit.audit_events (
    event_type,
    actor_role,
    actor_instructor_id,
    actor_student_id,
    course_id,
    session_id,
    event_summary,
    event_details,
    ip_address,
    user_agent
)
SELECT
    seed.event_type,
    seed.actor_role,
    i.instructor_id,
    st.student_id,
    c.course_id,
    sess.session_id,
    seed.event_summary,
    seed.event_details,
    '10.0.0.119'::inet,
    'pgAdmin synthetic seed script'
FROM audit_seed seed
LEFT JOIN app.instructors i
    ON i.employee_number = seed.instructor_employee_number
LEFT JOIN app.students st
    ON st.student_number = seed.student_number
LEFT JOIN app.courses c
    ON c.course_code = seed.course_code
   AND c.term = 'Summer'
   AND c.academic_year = 2026
LEFT JOIN app.assessment_sessions sess
    ON sess.assignment_prompt = seed.assignment_prompt
WHERE NOT EXISTS (
    SELECT 1
    FROM audit.audit_events existing
    WHERE existing.event_summary = seed.event_summary
      AND existing.event_details ->> 'seed_batch' = 'SUVP_SYNTHETIC_SEED_2026_06_29'
);


COMMIT;


-- ============================================================
-- 13. Post-seed summary
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
ORDER BY table_name;
