/*
Question: What are the most optimal skills to learn(aka it'sin high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analysts roles
- Concentrates on remote positions with specified salaries
- Why? Targets skilss that offer job security (High demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analysis
*/

WITH average_salary AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(facts.salary_year_avg), 0) AS avg_salary
    FROM
        skills_dim
        INNER JOIN skills_job_dim AS skills ON skills.skill_id = skills_dim.skill_id
        INNER JOIN job_postings_fact AS facts ON facts.job_id =  skills.job_id
    WHERE
        facts.job_title_short = 'Data Analyst' AND
        facts.salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
), skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim) AS demand_count
    FROM
        job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst' AND
        job_postings_fact.salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
)

SELECT
    skills_demand.skills,
    skills_demand.demand_count,
    average_salary.avg_salary
FROM
    average_salary
    INNER JOIN skills_demand ON average_salary.skill_id = skills_demand.skill_id
ORDER BY
    skills_demand.demand_count DESC,
    average_salary.avg_salary DESC
LIMIT
    25;
