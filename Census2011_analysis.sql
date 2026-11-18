use census_db;
-- Q1. SELECT - Display state name, population and literacy of all states.
SELECT state_name, population, literacy
FROM state_summary;


-- Q2. DISTINCT - Display all unique literacy bands present in the data.
SELECT DISTINCT band
FROM state_summary;


-- Q3. FROM - Display state name and population from census_cleaned table.
SELECT state_name, population
FROM census_cleaned;


-- Q4. WHERE - Display states where literacy is more than 80%.
SELECT state_name, literacy
FROM state_summary
WHERE literacy > 80;


-- Q5. GROUP BY - Count the number of states in each literacy band.
SELECT band, COUNT(*) AS total_states
FROM state_summary
GROUP BY band;


-- Q6. ORDER BY - Display states in descending order of population.
SELECT state_name, population
FROM state_summary
ORDER BY population DESC;


-- Q7. HAVING - Display bands having more than 10 states.
SELECT band, COUNT(*) AS total
FROM state_summary
GROUP BY band
HAVING COUNT(*) > 10;


-- Q8. JOIN - Join both tables to compare population and literacy together.
SELECT c.state_name, c.population, s.literacy
FROM census_cleaned c
JOIN state_summary s
ON c.state_name = s.state_name;


-- Q9. LEFT JOIN - Display all states from census_cleaned with their band.
SELECT c.state_name, s.band
FROM census_cleaned c
LEFT JOIN state_summary s
ON c.state_name = s.state_name;


-- Q10. RIGHT JOIN - Display all states from state_summary with their census data.
SELECT c.state_name, s.literacy
FROM census_cleaned c
RIGHT JOIN state_summary s
ON c.state_name = s.state_name;


-- Q11. INNER JOIN - Display only those states which are present in both tables.
SELECT c.state_name, c.population, s.literacy
FROM census_cleaned c
INNER JOIN state_summary s
ON c.state_name = s.state_name;


-- Q12. FULL JOIN - Display all states from both tables.
SELECT c.state_name
FROM census_cleaned c
LEFT JOIN state_summary s
ON c.state_name = s.state_name

UNION

SELECT s.state_name
FROM census_cleaned c
RIGHT JOIN state_summary s
ON c.state_name = s.state_name;


-- Q13. CROSS JOIN - Display all possible combinations of states and bands.
SELECT s.state_name, b.band
FROM state_summary s
CROSS JOIN (
    SELECT DISTINCT band
    FROM state_summary
) b;


-- Q14. UNION - Display states with high literacy or high sex ratio without duplicates.
SELECT state_name
FROM state_summary
WHERE literacy > 85

UNION

SELECT state_name
FROM state_summary
WHERE sex_ratio > 1000;


-- Q15. UNION ALL - Display top 5 and bottom 5 populated states together.
(SELECT state_name
FROM state_summary
ORDER BY population DESC
LIMIT 5)

UNION ALL

(SELECT state_name
FROM state_summary
ORDER BY population ASC
LIMIT 5);


-- Q16. CASE WHEN - Categorise states as Developed, Developing or Needs Focus.
SELECT state_name, literacy,
CASE
    WHEN literacy >= 85 THEN 'Developed'
    WHEN literacy >= 70 THEN 'Developing'
    ELSE 'Needs Focus'
END AS category
FROM state_summary;


-- Q17. COALESCE - Display 0 in place of NULL values in literacy.
SELECT state_name, COALESCE(literacy, 0) AS literacy
FROM state_summary;


-- Q18. COUNT() - Count total number of states having population more than 1 crore.
SELECT COUNT(*) AS big_states
FROM state_summary
WHERE population > 10000000;


-- Q19. SUM() - Find total population of all states.
SELECT SUM(population) AS total_population
FROM state_summary;


-- Q20. AVG() - Find average literacy rate of India.
SELECT AVG(literacy) AS avg_literacy
FROM state_summary;


-- Q21. MIN() - Find state with minimum sex ratio.
SELECT state_name, sex_ratio
FROM state_summary
WHERE sex_ratio = (
    SELECT MIN(sex_ratio)
    FROM state_summary
);


-- Q22. MAX() - Find difference between maximum and minimum literacy.
SELECT MAX(literacy) - MIN(literacy) AS literacy_range
FROM state_summary;


-- Q23. BETWEEN - Display states having literacy between 70 and 80.
SELECT state_name, literacy
FROM state_summary
WHERE literacy BETWEEN 70 AND 80;


-- Q24. EXISTS - Display states which exist in both tables.
SELECT state_name
FROM census_cleaned c
WHERE EXISTS (
    SELECT 1
    FROM state_summary s
    WHERE s.state_name = c.state_name
);


-- Q25. IN - Display data of Kerala, Bihar and Uttar Pradesh.
SELECT *
FROM state_summary
WHERE state_name IN ('Kerala', 'Bihar', 'Uttar Pradesh');


-- Q26. CTE (WITH) - Display states having literacy above average literacy.
WITH AvgLit AS (
    SELECT AVG(literacy) AS avg_lit
    FROM state_summary
)
SELECT state_name, literacy
FROM state_summary, AvgLit
WHERE literacy > avg_lit;


-- Q27. ROW_NUMBER() - Assign unique rank to each state by population.
SELECT state_name, population,
ROW_NUMBER() OVER (ORDER BY population DESC) AS rank_no
FROM state_summary;


-- Q28. RANK() - Rank states by literacy, same literacy gets same rank.
SELECT state_name, literacy,
RANK() OVER (ORDER BY literacy DESC) AS rank_no
FROM state_summary;


-- Q29. DENSE_RANK() - Find state with second highest literacy.
SELECT state_name, literacy
FROM (
    SELECT state_name, literacy,
    DENSE_RANK() OVER (ORDER BY literacy DESC) AS dr
    FROM state_summary
) t
WHERE dr = 2;


-- Q30. LIMIT - Display top 5 states with highest population.
SELECT state_name, population
FROM state_summary
ORDER BY population DESC
LIMIT 5;

-- Q31. Which state has the highest gender gap, and what is the female percentage?
SELECT state_name, male, female,
(male - female) AS gender_gap,
ROUND(female * 100.0 / population, 2) AS female_percentage,
ROUND(male * 100.0 / population, 2) AS male_percentage
FROM state_summary
ORDER BY gender_gap DESC;
