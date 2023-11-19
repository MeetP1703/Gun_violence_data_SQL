# Gun Violence Data SQL Project

## Overview

The Gun Violence Data SQL Project focuses on analyzing and extracting insights from U.S.A. gun violence incidents that occurred between January 2013 and March 2018. This project utilizes a MySQL database to store and query the dataset, providing a robust platform for comprehensive analysis.
# Table of Contents

1. [Introduction](#introduction)
2. [Features](#features)
3. [Dataset / Database Schema](#dataset--database-schema)
   - [Incident Table](#incident-table)
   - [Participant Table](#participant-table)
4. [Setup](#setup)
   - [Prerequisites](#prerequisites)
   - [Installation](#installation)
5. [Queries](#queries)
6. [Insights](#insights)
7. [Getting Started](#getting-started)
8. [Applications](#Applications)
9. [Contributing](#contributing)

## Introduction

Welcome to the U.S.A. Gun Violence Data Analysis project! This project explores and analyzes gun violence data in the United States from January 2013 to March 2018.
## Features:
- **Temporal Patterns:** The analysis revealed intriguing temporal patterns, uncovering the dynamics of incidents over the years.

- **Demographic Trends:** Understanding the demographics of victims and subjects/suspects provided insights into the human aspect of gun violence.

- **Database Schema:** The primary dataset, 'Gun_violence_data.xlsx,' is transformed into two structured tables: `incident` and `participant`.
  
- **SQL Queries:** A collection of SQL queries is available to facilitate exploration and extraction of meaningful patterns and insights from the dataset.

- **Geospatial Analysis:** Leveraging latitude and longitude data, the project offers geospatial insights into the distribution of gun violence incidents across the United States.

## 🛠️ Tools Used:

MySQL for data processing and querying.

Excel for initial data exploration and cleaning.

## Dataset / Database Schema

### Incident Table

- `incident_id`: Unique identifier for each incident.
- `date`: Date of the incident.
- `state`: U.S. state where the incident occurred.
- `city_or_county`: City or county where the incident occurred.
- `n_killed`: Number of individuals killed.
- `n_injured`: Number of individuals injured.
- `n_unharmed_arrested`: Number of individuals unharmed and arrested.
- `n_unharmed`: Number of individuals unharmed.
- `congressional_district`: Congressional district of the incident.
- `gun_type`: Type of gun(s) involved.
- `latitude`: Latitude coordinates of the incident.
- `location_description`: Description of the incident location.
- `longitude`: Longitude coordinates of the incident.
- `n_Stolen_guns_involved`: Number of stolen guns involved.

### Participant Table

- `incident_id`: Unique identifier linking participants to incidents.
- `participant_age_group`: Age group of the participant.
- `participant_male`: Binary value indicating male participation.
- `participant_female`: Binary value indicating female participation.
- `participant_relationship`: Relationship of the participant to the incident.
- `Victim`: Binary value indicating if the participant was a victim.
- `Subject_Suspect`: Binary value indicating if the participant was a subject/suspect.
- `state_house_district`: State house district of the participant.

## Setup

### Prerequisites

- MySQL installed on your local machine.
- The 'Gun_violence_data.xlsx' dataset available.

### Installation

1. Create a new MySQL database.
2. Import the dataset into the database using provided SQL scripts.

## Queries

This project includes a collection of Analysis to extract useful information from the dataset.  

SQL queries link :- https://github.com/MeetP1703/Gun_violence_data/blob/main/gun_violence_data.sql

## Insights

Key insights derived from the analysis, including trends, patterns, and correlations in U.S.A. gun violence incidents.
1. Count incidents per year

2. Count incidents per year and month:

3. The average number of participants in incidents:

4. The average number of killed and injured per incident:

5. The count of incidents per year and average values for various attributes, by joining the both tables:

6. I Calculate the total number of incidents in each congressional district:

7. The count of distinct incidents by state and the count of distinct location types for each state 
    
8. Top states and cities with the highest number of incidents, Join both state and city level data. 

9. Top states and cities with the highest number of incidents with the use of left join

10. Top 5 cities or counties with the highest number of gun violence incidents.

11. Find incidents with a high number of stolen guns involved:

12. Find the Incidents by Month, Age Group, Relationship Type:

13. Find the Highest Incidents by Month, Age Group, Relationship Type:

14. Find incidents with the highest number of victims by age group:

15. Identify incidents with a high number of participants and a high number of killed:

16. Calculate the percentage of incidents involving family relationships:

17. The count of unique incidents, categorized by participant relationships, and the corresponding percentage distribution among those relationships:
    
18. Incidents by Gun Type and Total Guns Involved:

19. I retrieve incident details (incident_id, date, state, city_or_county) where latitude is between 19.1127 and 71.3368, and longitude is between -165.5860 and -67.2711

## Getting Started

1. Clone the repository.
2. Follow the setup instructions to create and populate the MySQL database.
3. Dive into the queries to extract valuable information.
4. Explore the insights section for key findings.

## Applications

The U.S.A. Gun Violence Dataset can be utilized for various applications and analyses. Here are some potential use cases:

1. **Law Enforcement and Public Safety:** Explore patterns and trends in gun violence incidents to aid law enforcement agencies in developing effective strategies for public safety.

2. **Policy Making:** Analyze the dataset to derive insights that can inform policymakers about the impact of existing gun control measures and support evidence-based policy decisions.

3. **Community Awareness:** Raise awareness by visualizing and communicating data-driven insights about gun violence, promoting community engagement and discussion.

4. **Research Studies:** Researchers can leverage the dataset for academic studies and scientific research related to criminology, sociology, and public health.

5. **Data Journalism:** Journalists can use the dataset to create compelling narratives and visualizations, fostering public understanding of gun violence issues.

## Contributing

If you'd like to contribute to the project, please follow the guidelines outlined in the CONTRIBUTING.md file.

Feel free to reach out for any questions or collaborations.
