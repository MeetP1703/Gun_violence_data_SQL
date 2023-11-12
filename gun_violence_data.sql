
use gun_violence_data;
SELECT * FROM gun_violence_data.participant;
SELECT * FROM gun_violence_data.incident;

-- THREE DATA CLEANING QUERIES:

-- 1. In incident table remove rows with blank cells

DELETE FROM incident WHERE incident_id > 0 AND (date IS NULL OR state IS NULL OR city_or_county IS NULL OR n_killed 
 IS NULL OR n_injured IS NULL OR n_unharmed_arrested IS NULL OR n_unharmed IS NULL OR congressional_district 
 IS NULL OR gun_type IS NULL OR latitude IS NULL OR longitude IS NULL OR location_description 
 IS NULL OR n_Stolen_guns_involved IS NULL);

-- 2. In participant table remove rows with blank cells
DELETE FROM participant WHERE incident_id > 0 AND (participant_age_group IS NULL OR participant_male 
IS NULL OR participant_female IS NULL OR participant_relationship IS NULL OR Victim IS NULL 
OR Subject_Suspect IS NULL OR state_house_district IS NULL);

-- 3. Remove duplicate entries/rows in the incident table
DELETE FROM incident
WHERE (incident_id, date) IN (
    SELECT incident_id, date
    FROM (
        SELECT incident_id, date, ROW_NUMBER() OVER (PARTITION BY incident_id ORDER BY date) AS row_num
        FROM incident) AS cte
    WHERE row_num > 1);

-- 4. To identify total of each column from the Both table
SELECT
	COUNT(DISTINCT incident.incident_id) AS unique_incident_id,
    COUNT(DISTINCT state) AS unique_states,
    COUNT(DISTINCT city_or_county) AS unique_cities_counties,
    COUNT(DISTINCT congressional_district) AS unique_congressional_districts,
    COUNT(DISTINCT participant_age_group) AS unique_participant_age_groups,
    COUNT(DISTINCT gun_type) AS unique_gun_types,
    SUM(n_killed) AS total_killed,
    SUM(n_injured) AS total_injured,
    SUM(n_Stolen_guns_involved) AS total_stolen_guns_involved,
    SUM(participant_male) AS total_participant_males,
    SUM(participant_female) AS total_participant_females,
    SUM(Victim) AS total_victims,
    SUM(Subject_Suspect) AS total_subject_suspects
FROM incident
JOIN participant ON incident.incident_id = participant.incident_id;

-- 5. Count incidents per year
SELECT EXTRACT(YEAR FROM STR_TO_DATE(incident.date, '%d-%b-%y'))
	AS year, COUNT(*) AS total_incidents 
    FROM incident 
    GROUP BY year
    ORDER BY year ASC;

-- 6. Count incidents per year and month:
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(incident.date, '%d-%b-%y')) as year,
    EXTRACT(MONTH FROM STR_TO_DATE(incident.date, '%d-%b-%y')) as month,
    COUNT(*) as total_incidents
FROM incident
GROUP BY year, month
ORDER BY year, month;

-- 7. The average number of participants in incidents:
SELECT AVG(participant_male + participant_female) AS avg_participants
FROM participant;

-- 8. The average number of killed and injured per incident:
SELECT AVG(n_killed) AS avg_killed, AVG(n_injured) AS avg_injured
FROM incident;

-- 9. The count of incidents per year and average values for various attributes, by joining the both tables:
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(incident.date, '%d-%b-%y')) AS year,
    COUNT(*) AS total_incidents,
    AVG(n_killed) AS avg_killed,
    AVG(n_injured) AS avg_injured,
    AVG(n_Stolen_guns_involved) AS avg_stolen_guns_involved,
    AVG(participant_male) AS avg_participant_males,
    AVG(participant_female) AS avg_participant_females,
    AVG(Victim) AS avg_victims,
    AVG(Subject_Suspect) AS avg_subject_suspects
FROM incident
JOIN participant ON incident.incident_id = participant.incident_id
GROUP BY year
ORDER BY total_incidents ASC;

-- 10. Calculate the total number of incidents in each congressional district:
SELECT congressional_district, COUNT(*) AS incident_count
FROM incident
GROUP BY congressional_district
ORDER BY incident_count DESC;

-- 11. The count of distinct incidents by state and the count of distinct location types for each state 
SELECT
    state,
    COUNT(DISTINCT incident_id) AS incidents_by_state,
    COUNT(DISTINCT location_description) AS incidents_by_location_type
FROM
    incident
GROUP BY
    state;
    
-- 12. Top states and cities with the highest number of incidents, combining both state and city level data. 
SELECT location, SUM(incident_count) AS total_incidents
FROM (
    SELECT state AS location, COUNT(*) AS incident_count FROM incident
    GROUP BY state
    ORDER BY incident_count DESC
    LIMIT 5
) AS states
GROUP BY location
UNION ALL
SELECT location, SUM(incident_count) AS total_incidents FROM (
    SELECT city_or_county AS location, COUNT(*) AS incident_count FROM incident
    GROUP BY city_or_county
    ORDER BY incident_count DESC
    LIMIT 5
) AS cities
GROUP BY location;

-- 13 get same output as per above with the use of left join
SELECT incident_participants.state, SUM(incident_participants.total_participants) as total_participants
FROM (
    SELECT incident.incident_id, incident.state, COUNT(*) as total_participants
    FROM incident
    LEFT JOIN participant ON incident.incident_id = participant.incident_id
    GROUP BY incident.incident_id, incident.state
) AS incident_participants
GROUP BY incident_participants.state
ORDER BY total_participants DESC
LIMIT 10;

-- 14. top 5 cities or counties with the highest number of gun violence incidents.
SELECT
	city_or_county,
	COUNT(*) AS total_incidents,
	SUM(n_killed) AS total_killed,
	SUM(n_injured) AS total_injured,
	SUM(n_killed + n_injured) AS total_victims
FROM incident
WHERE city_or_county IS NOT NULL
GROUP BY city_or_county
ORDER BY
    total_incidents DESC,
    total_killed DESC,
    total_injured DESC,
    total_victims DESC
LIMIT 5;	

-- 15. Find incidents with a high number of stolen guns involved:
SELECT *
FROM incident
WHERE n_Stolen_guns_involved > 10;

-- 16. Find the Incidents by Month, Age Group, Relationship Type:
SELECT SUBSTRING(i.date, 4, 2) AS month, p.participant_age_group, p.participant_relationship, 
 COUNT(*) AS incident_count 
 FROM incident i
 JOIN participant p ON i.incident_id = p.incident_id
 GROUP BY month, p.participant_age_group, p.participant_relationship 
 ORDER BY month, incident_count DESC;

-- 17. Find the Highest Incidents by Month, Age Group, Relationship Type:
SELECT 
    SUBSTRING(i.date, 4, 2) AS month, p.participant_age_group, p.participant_relationship, 
    COUNT(*) AS incident_count 
FROM incident i
JOIN participant p ON i.incident_id = p.incident_id
GROUP BY month, p.participant_age_group, p.participant_relationship 
ORDER BY incident_count DESC
LIMIT 5;

-- 18. Find incidents with the highest number of victims by age group:
SELECT p.participant_age_group, MAX(i.n_killed + i.n_injured) AS max_victims
FROM incident i
JOIN participant p ON i.incident_id = p.incident_id
GROUP BY p.participant_age_group;

-- 19. Identify incidents with a high number of participants and a high number of killed:
SELECT i.*, p.*
FROM incident i
JOIN participant p ON i.incident_id = p.incident_id
WHERE (p.participant_male + p.participant_female) > 5 AND i.n_killed > 2;

-- 20. Calculate the percentage of incidents involving family relationships:
SELECT (COUNT(*) / (SELECT COUNT(*) FROM participant)) * 100 AS percentage_family_incidents
FROM participant
WHERE participant_relationship LIKE '%Family%';

-- 21. the count of unique incidents, categorized by participant relationships, and the corresponding percentage distribution among those relationships:
SELECT 
    CASE 
        WHEN participant_relationship LIKE '%Significant others - current or former%' THEN 'Significant others_current_or former'
        WHEN participant_relationship LIKE '%Family%' THEN 'Family'
        WHEN participant_relationship LIKE '%Armed Robbery%' THEN 'Armed Robbery'
        WHEN participant_relationship LIKE '%Friends%' THEN 'Friends'
        WHEN participant_relationship LIKE '%Aquaintance%' THEN 'Aquaintance'
        WHEN participant_relationship LIKE '%Neighbor%' THEN 'Neighbor'
        WHEN participant_relationship LIKE '%Home Invasion - Perp Does Not Know Victim%' THEN 'Home Invasion - Perp Does Not_Know Victim'
        WHEN participant_relationship LIKE '%Co-worker%' THEN 'Co-worker'
        ELSE 'Other'
    END AS participant_relationship,
    COUNT(DISTINCT incident_id) AS incident_count,
    ROUND((COUNT(DISTINCT incident_id) / (SELECT COUNT(DISTINCT incident_id) 
    FROM participant WHERE participant_relationship IS NOT NULL)) * 100, 2) AS percentage
FROM 
    participant
WHERE
    participant_relationship IS NOT NULL
GROUP BY 
    participant_relationship
ORDER BY 
    incident_count DESC;
    
-- 22. Incidents by Gun Type and Total Guns Involved:
SELECT gun_type, COUNT(*) AS incident_count, SUM(n_stolen_guns_involved) AS total_stolen_guns FROM incident WHERE gun_type IS NOT NULL GROUP BY gun_type
UNION ALL
SELECT 'Total' AS gun_type, COUNT(*), SUM(n_stolen_guns_involved) FROM incident WHERE gun_type IS NOT NULL;

-- 23. Incidents Involving killed, injured, Unknown,and Unharmed Participants:
SELECT 'Killed' AS participant_status, COUNT(*) AS incident_count FROM incident WHERE n_killed > 0
UNION ALL
SELECT 'Injured' AS participant_status, COUNT(*) AS incident_count FROM incident WHERE n_injured > 0
UNION ALL
SELECT 'Unknown' AS participant_status, COUNT(*) AS incident_count FROM incident WHERE n_unharmed_arrested > 0
UNION ALL
SELECT 'Unharmed' AS participant_status, COUNT(*) AS incident_count FROM incident WHERE n_unharmed_arrested > 0 OR n_unharmed > 0;

-- 24.
-- I retrieve incident details (incident_id, date, state, city_or_county) where 
-- latitude is between 19.1127 and 71.3368, and longitude is between -165.5860 and -67.2711
SELECT incident_id, date, state, city_or_county
FROM incident
WHERE latitude BETWEEN 19.1127 AND 71.3368
  AND longitude BETWEEN -165.5860 AND -67.2711;

