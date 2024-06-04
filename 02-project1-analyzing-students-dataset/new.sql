-- Test Query 1
SELECT * 
FROM student_health.student_details 
LIMIT 20;

-- Query 2: count the number of international students
SELECT COUNT(inter_dom) as stay
FROM student_health.student_details
WHERE inter_dom = 'Inter';

-- Query 3: summary statistics for each diagnostic test using aggregate functions
SELECT 
    ROUND(AVG(todep), 2) AS average_phq
FROM student_health.student_details


--
SELECT stay,
    COUNT(*) AS count_int
FROM student_health.student_details
WHERE stay IS NOT NULL
GROUP BY stay
ORDER BY stay DESC;


-- Find the number of international students and their average scores by length of stay, in descending order of length of stay
SELECT stay, 
       COUNT(*) AS count_int,
       ROUND(AVG(todep), 2) AS average_phq, 
       ROUND(AVG(tosc), 2) AS average_scs, 
       ROUND(AVG(toas), 2) AS average_as
FROM student_health.student_details
WHERE inter_dom = 'Inter'
GROUP BY stay
ORDER BY stay DESC;