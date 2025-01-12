# Netflix Movies and TV Shows Data Exploration using SQL  

![](https://github.com/nithin0310/Netflix_SQL_Project/blob/main/logo.png)

## Overview  
This project conducts an in-depth analysis of Netflix's Movies and TV Shows data using SQL. The objective is to uncover actionable insights and address various analytical questions based on the dataset. This README provides a detailed walkthrough of the project's goals, problems, solutions, and key findings.  

## Objectives  

- Understand the distribution of Movies and TV Shows on Netflix.  
- Analyze content ratings to identify the most frequent ones.  
- Investigate content trends based on release years, countries, and durations.  
- Explore and classify content based on specific criteria and keywords.  

## Dataset  

The dataset used in this project is available on Kaggle:  

- **Dataset Link:** [Netflix Movies and TV Shows Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)  

## Schema  

```sql
DROP TABLE IF EXISTS netflix;  
CREATE TABLE netflix  
(  
    show_id      VARCHAR(5),  
    type         VARCHAR(10),  
    title        VARCHAR(250),  
    director     VARCHAR(550),  
    casts        VARCHAR(1050),  
    country      VARCHAR(550),  
    date_added   VARCHAR(55),  
    release_year INT,  
    rating       VARCHAR(15),  
    duration     VARCHAR(15),  
    listed_in    VARCHAR(250),  
    description  VARCHAR(550)  
);

```
## Business Problems and Solutions

### 1. Determine the Distribution of Movies vs TV Shows
```sql
SELECT 
    type, 
    COUNT(*) AS content_count 
FROM netflix 
GROUP BY type;
```
**Objective:** Analyze the proportion of Movies and TV Shows available on Netflix.

### 2. Identify the Most Common Ratings for Movies and TV Shows

```sql

WITH RatingData AS (  
    SELECT 
        type, 
        rating, 
        COUNT(*) AS rating_total 
    FROM netflix 
    GROUP BY type, rating  
),  
RankedRatings AS (  
    SELECT 
        type, 
        rating, 
        rating_total, 
        RANK() OVER (PARTITION BY type ORDER BY rating_total DESC) AS ranking  
    FROM RatingData  
)  
SELECT 
    type, 
    rating AS common_rating  
FROM RankedRatings  
WHERE ranking = 1;
```
**Objective:** Determine the most frequent rating for each content type.

### 3. Retrieve All Movies Released in a Specific Year (e.g., 2020)

```sql

SELECT *  
FROM netflix  
WHERE release_year = 2020;
```
**Objective:** Get a list of all movies released in a specified year.

### 4. Identify the Top 5 Countries with the Most Content on Netflix

```sql

SELECT 
    country_name, 
    COUNT(*) AS total_content  
FROM (  
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country_name  
    FROM netflix  
) AS CountryList  
WHERE country_name IS NOT NULL  
GROUP BY country_name  
ORDER BY total_content DESC  
LIMIT 5;
```
**Objective:** Rank the top 5 countries based on the number of content items available.

### 5. Find the Longest Movie

```sql

SELECT 
    *  
FROM netflix  
WHERE type = 'Movie'  
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC  
LIMIT 1;
```
**Objective:** Retrieve the Movie with the longest duration.

### 6. Analyze Content Added in the Last 5 Years

```sql

SELECT *  
FROM netflix  
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```
**Objective:** Fetch content added to Netflix in the last five years.

### 7. Retrieve All Content Directed by 'Rajiv Chilaka'

```sql

SELECT *  
FROM (  
    SELECT 
        *, 
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name  
    FROM netflix  
) AS DirectorList  
WHERE director_name = 'Rajiv Chilaka';

**Objective:** List all Movies and TV Shows directed by 'Rajiv Chilaka'.
```
### 8. List All TV Shows with More Than 5 Seasons

```sql

SELECT *  
FROM netflix  
WHERE type = 'TV Show'  
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;

**Objective:** Identify TV Shows that have more than 5 seasons.
```
### 9. Count the Number of Content Items in Each Genre

```sql

SELECT 
    genre, 
    COUNT(*) AS genre_count  
FROM (  
    SELECT 
        UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre  
    FROM netflix  
) AS GenreList  
GROUP BY genre;
```
**Objective:** Analyze the number of content items within each genre.

### 10. Identify the Top 5 Years with the Highest Average Content Release in India

```sql

SELECT 
    release_year, 
    COUNT(show_id) AS total_releases,  
    ROUND(AVG(COUNT(show_id)) OVER(), 2) AS avg_release  
FROM netflix  
WHERE country ILIKE '%India%'  
GROUP BY release_year  
ORDER BY avg_release DESC  
LIMIT 5;
```
**Objective:** Analyze and rank the years by average content releases for India.

### 11. Retrieve All Movies Classified as Documentaries

```sql

SELECT *  
FROM netflix  
WHERE listed_in ILIKE '%Documentaries%';
```
**Objective:**: Get a list of all Movies categorized as documentaries.

### 12. Identify Content Without Assigned Directors

```sql

SELECT *  
FROM netflix  
WHERE director IS NULL;
```
**Objective:** Find content items with no directors listed.

### 13. Count the Number of Movies Featuring Salman Khan in the Last 10 Years

```sql

SELECT *  
FROM netflix  
WHERE casts ILIKE '%Salman Khan%'  
  AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```
**Objective:** Count Movies featuring 'Salman Khan' released in the last 10 years.

### 14. Determine the Top 10 Actors with the Most Appearances in Indian Movies

```sql

SELECT 
    actor_name, 
    COUNT(*) AS movie_count  
FROM (  
    SELECT 
        UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor_name  
    FROM netflix  
    WHERE country ILIKE '%India%'  
) AS ActorList  
GROUP BY actor_name  
ORDER BY movie_count DESC  
LIMIT 10;
```
**Objective:** Identify the top 10 actors who have appeared in the most Indian Movies.

### 15. Categorize Content Based on Keywords 'Kill' and 'Violence'

```sql

SELECT 
    category_label, 
    COUNT(*) AS content_total  
FROM (  
    SELECT 
        CASE  
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'  
            ELSE 'Good'  
        END AS category_label  
    FROM netflix  
) AS CategorizedContent  
GROUP BY category_label;
```
**Objective:** Classify content based on the presence of keywords 'kill' and 'violence' and count items in each category.

## Findings and Conclusion
**Content Distribution**: Netflix offers a wide variety of Movies and TV Shows, with distinct patterns in genres and ratings.
**Geographic Insights**: Key countries like India dominate content production, with a clear trend in average releases over the years.
**Categorization**: Content classification based on keywords provides insights into the themes prevalent in the dataset.
This analysis serves as a foundation for understanding Netflix's content trends and can inform strategic decision-making for content planning.
