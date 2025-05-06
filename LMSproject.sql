    --------------------------------------------------------------------------
    --USER:lms
    --PASSWORD:root

































    --------------------------------------------------------------------------
    
    -- Creating USER table
    
    CREATE TABLE Users (
        user_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name           VARCHAR2(100) NOT NULL,
        email          VARCHAR2(100) UNIQUE NOT NULL,
        password       VARCHAR2(255) NOT NULL,
        role           VARCHAR2(10) CHECK (role IN ('INSTRUCTOR', 'STUDENT')),
        created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    ALTER TABLE users ADD reset_token VARCHAR2(255);
    ALTER TABLE users ADD reset_token_expiry TIMESTAMP NULL;
    -- Creating Courses table
    select * from users;
    CREATE TABLE Courses (
        course_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        instructor_id  NUMBER NOT NULL,
        title         VARCHAR2(255) NOT NULL,
        description   CLOB,
        created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        Constraint fk_users FOREIGN KEY (instructor_id) REFERENCES Users(user_id) ON DELETE CASCADE
    );
    alter table courses add is_active number(1) default 0 check (is_active in (0,1));
    
    -- Creating Course_Materials table
    
    CREATE TABLE Course_Materials (
        material_id   NUMBER GENERATED ALWAYS AS IDENTITY  PRIMARY KEY,
        course_id     NUMBER NOT NULL,
        file_name     VARCHAR2(255) NOT NULL,
        file_type     VARCHAR2(50) CHECK (file_type IN ('PDF', 'VIDEO')),
        file_path     VARCHAR2(500) NOT NULL,
        uploaded_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT fk_course FOREIGN KEY (course_id) 
        REFERENCES Courses(course_id) ON DELETE cascade
    );
    
    -- Creating Enrollments table
    
    CREATE TABLE Enrollments (
        enrollment_id  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        student_id     NUMBER NOT NULL,
        course_id      NUMBER NOT NULL,
        enrolled_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (student_id) REFERENCES Users(user_id) ON DELETE CASCADE,
        FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE 
    );
    
    -- Creating Progress table
    
    CREATE TABLE Progress (
        progress_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        student_id         NUMBER NOT NULL,
        course_id          NUMBER NOT NULL,
        completed_percentage NUMBER(3) CHECK (completed_percentage BETWEEN 0 AND 100),
        last_updated       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (student_id) REFERENCES Users(user_id) ON DELETE CASCADE,
        FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
    );
    
    -- Creating Feedback table
    
    CREATE TABLE Feedback (
        feedback_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        student_id     NUMBER NOT NULL,
        course_id      NUMBER NOT NULL,
        rating         NUMBER(1) CHECK (rating BETWEEN 1 AND 5),
        course_feedback CLOB,
        created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (student_id) REFERENCES Users(user_id) ON DELETE CASCADE,
        FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
    );
    
    --creating index for the fast retreival.
    CREATE INDEX idx_courses_title ON Courses(title);
    CREATE INDEX idx_enrollments_student ON Enrollments(student_id);
    
    CREATE TABLE MaterialProgress (
    progress_id   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id    NUMBER NOT NULL,
    material_id   NUMBER NOT NULL,
    is_completed  NUMBER(1) DEFAULT 0 CHECK (is_completed IN (0,1)),
    FOREIGN KEY (student_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (material_id) REFERENCES Course_Materials(material_id) ON DELETE CASCADE
);
CREATE OR REPLACE TRIGGER TRG_ACTIVATE_COURSE
AFTER INSERT ON Course_Materials
DECLARE
BEGIN
    UPDATE Courses 
    SET is_active = 1
    WHERE course_id IN (SELECT DISTINCT course_id FROM Course_Materials);
END;
/

CREATE OR REPLACE TRIGGER trg_insert_progress
AFTER INSERT ON Enrollments
FOR EACH ROW
BEGIN
    -- Insert a new progress entry for the student in the enrolled course
    INSERT INTO Progress (student_id, course_id, completed_percentage, last_updated)
    VALUES (:NEW.student_id, :NEW.course_id, 0, CURRENT_TIMESTAMP);
END;
/

UPDATE Courses 
SET is_active = 1 
WHERE course_id IN (SELECT DISTINCT course_id FROM Course_Materials);

SELECT u.user_id, u.name, u.email, e.enrolled_at 
FROM users u 
JOIN enrollments e ON u.user_id = e.student_id 
WHERE e.course_id = 66
ORDER BY u.name;

select * from courses;

select * from users;
CREATE GLOBAL TEMPORARY TABLE course_ids_temp (
    course_id NUMBER PRIMARY KEY
) ON COMMIT DELETE ROWS;

CREATE OR REPLACE TRIGGER trg_update_progress
FOR INSERT ON Course_Materials
COMPOUND TRIGGER

    -- BEFORE EACH ROW: Store affected course IDs
    BEFORE EACH ROW IS
    BEGIN
        INSERT INTO course_ids_temp (course_id)
        SELECT :NEW.course_id FROM DUAL
        WHERE NOT EXISTS (SELECT 1 FROM course_ids_temp WHERE course_id = :NEW.course_id);
    END BEFORE EACH ROW;

    -- AFTER STATEMENT: Update progress table
    AFTER STATEMENT IS
    BEGIN
        FOR rec IN (SELECT DISTINCT course_id FROM course_ids_temp) LOOP
            DECLARE
                total_materials NUMBER := 0;
            BEGIN
                -- Count total materials in the course
                SELECT COUNT(*) INTO total_materials
                FROM Course_Materials
                WHERE course_id = rec.course_id;
                
                IF total_materials > 0 THEN
                    -- Loop through students enrolled in the course
                    FOR student_rec IN (SELECT student_id FROM Progress WHERE course_id = rec.course_id) LOOP
                        DECLARE
                            completed_materials NUMBER := 0;
                        BEGIN
                            -- Count completed materials by student
                            SELECT COUNT(*) INTO completed_materials
                            FROM MaterialProgress mp
                            JOIN Course_Materials cm ON mp.material_id = cm.material_id
                            WHERE cm.course_id = rec.course_id 
                            AND mp.student_id = student_rec.student_id 
                            AND mp.is_completed = 1;

                            -- Update Progress table
                            UPDATE Progress
                            SET completed_percentage = (completed_materials * 100) / total_materials
                            WHERE student_id = student_rec.student_id AND course_id = rec.course_id;
                        END;
                    END LOOP;
                END IF;
            END;
        END LOOP;

        -- Cleanup temp table
        DELETE FROM course_ids_temp;
    END AFTER STATEMENT;

END trg_update_progress;
/
select * from courses;
rollback;
truncate table users;

-- Add is_active column to courses table (using is_active instead of active since active is reserved in Oracle)
ALTER TABLE courses ADD COLUMN is_active NUMBER(1);


select * from feedback; 
select * from users;
select * from progress;
select * from MaterialProgress;
desc progress;
desc feedback;
select  * from courses;
select * from course_materials;
select * from enrollments;
select c.title as "Course Title", count(e.enrollment_id) as "Number of enrolleed students" from courses c join enrollments e on c.course_id = e.course_id group by c.title;

truncate table users;
alter table courses drop column is_active;
desc courses;
rollback;

select course_feedback from feedback where course_id = 27;
alter table courses modify(is_active default 1);

