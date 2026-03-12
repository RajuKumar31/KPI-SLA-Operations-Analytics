-- Dataset overview
SELECT COUNT(*) AS total_records
FROM kpi_sla_data;


-- Total tickets assigned and completed
SELECT
SUM(tickets_assigned) AS total_assigned,
SUM(tickets_completed) AS total_completed
FROM kpi_sla_data;


-- Total backlog tickets
SELECT
SUM(tickets_assigned) - SUM(tickets_completed) AS backlog
FROM kpi_sla_data;


-- SLA compliance percentage
SELECT
ROUND(
COUNT(*) FILTER (WHERE sla_met = 'Yes') * 100.0 / COUNT(*),
2
) AS sla_compliance_percentage
FROM kpi_sla_data;


-- SLA breaches by team
SELECT
team,
COUNT(*) AS sla_breach_count
FROM kpi_sla_data
WHERE sla_met = 'No'
GROUP BY team
ORDER BY sla_breach_count DESC;


-- Average resolution time per process
SELECT
process,
ROUND(AVG(actual_resolution_hours),2) AS avg_resolution_time
FROM kpi_sla_data
GROUP BY process
ORDER BY avg_resolution_time DESC;


-- Top 10 employees by completed tickets
SELECT
employee,
SUM(tickets_completed) AS total_completed
FROM kpi_sla_data
GROUP BY employee
ORDER BY total_completed DESC
LIMIT 10;


-- Monthly ticket trend
SELECT
DATE_TRUNC('month', date) AS month,
SUM(tickets_assigned) AS tickets_assigned,
SUM(tickets_completed) AS tickets_completed
FROM kpi_sla_data
GROUP BY month
ORDER BY month;


-- Average customer rating by team
SELECT
team,
ROUND(AVG(customer_rating),2) AS avg_customer_rating
FROM kpi_sla_data
GROUP BY team
ORDER BY avg_customer_rating DESC;


-- Total workload by process
SELECT
process,
SUM(tickets_assigned) AS total_tickets
FROM kpi_sla_data
GROUP BY process
ORDER BY total_tickets DESC;


-- SLA breach rate by process
SELECT
process,
COUNT(*) FILTER (WHERE sla_met = 'No') AS breach_count,
COUNT(*) AS total_tickets,
ROUND(
COUNT(*) FILTER (WHERE sla_met = 'No') * 100.0 / COUNT(*),
2
) AS breach_rate_percentage
FROM kpi_sla_data
GROUP BY process
ORDER BY breach_rate_percentage DESC;


-- Employee productivity score
SELECT
employee,
SUM(tickets_completed) AS completed,
SUM(tickets_assigned) AS assigned,
ROUND(
SUM(tickets_completed) * 100.0 / SUM(tickets_assigned),
2
) AS productivity_percentage
FROM kpi_sla_data
GROUP BY employee
ORDER BY productivity_percentage DESC;


-- Team productivity ranking
SELECT
team,
SUM(tickets_completed) AS completed,
SUM(tickets_assigned) AS assigned,
ROUND(
SUM(tickets_completed) * 100.0 / SUM(tickets_assigned),
2
) AS productivity_percentage
FROM kpi_sla_data
GROUP BY team
ORDER BY productivity_percentage DESC;


-- Rank employees by completed tickets
SELECT
employee,
SUM(tickets_completed) AS total_completed,
RANK() OVER (
ORDER BY SUM(tickets_completed) DESC
) AS productivity_rank
FROM kpi_sla_data
GROUP BY employee;


-- Resolution time analysis
SELECT
process,
MIN(actual_resolution_hours) AS fastest_resolution,
MAX(actual_resolution_hours) AS slowest_resolution,
ROUND(AVG(actual_resolution_hours),2) AS avg_resolution
FROM kpi_sla_data
GROUP BY process
ORDER BY avg_resolution DESC;


-- Monthly SLA performance
SELECT
DATE_TRUNC('month', date) AS month,
COUNT(*) FILTER (WHERE sla_met = 'Yes') AS sla_met,
COUNT(*) FILTER (WHERE sla_met = 'No') AS sla_breached
FROM kpi_sla_data
GROUP BY month
ORDER BY month;