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

select * from netflix

1. Determine the Distribution of Movies vs TV Shows
```sql
SELECT 
    type, 
    COUNT(*) AS content_count 
FROM netflix 
GROUP BY type;
```

2. Identify the Most Common Ratings for Movies and TV Shows

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

3. Retrieve All Movies Released in a Specific Year (e.g., 2020)

```sql

SELECT *  
FROM netflix  
WHERE release_year = 2020;
```

4. Identify the Top 5 Countries with the Most Content on Netflix

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

5. Find the Longest Movie

```sql

SELECT 
    *  
FROM netflix  
WHERE type = 'Movie'  
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC  
LIMIT 1;
```

6. Analyze Content Added in the Last 5 Years

```sql

SELECT *  
FROM netflix  
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

7. Retrieve All Content Directed by 'Rajiv Chilaka'

```sql

SELECT *  
FROM (  
    SELECT 
        *, 
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name  
    FROM netflix  
) AS DirectorList  
WHERE director_name = 'Rajiv Chilaka';

```
8. List All TV Shows with More Than 5 Seasons

```sql

SELECT *  
FROM netflix  
WHERE type = 'TV Show'  
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;

```
9. Count the Number of Content Items in Each Genre

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

10. Identify the Top 5 Years with the Highest Average Content Release in India

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

11. Retrieve All Movies Classified as Documentaries

```sql

SELECT *  
FROM netflix  
WHERE listed_in ILIKE '%Documentaries%';
```

12. Identify Content Without Assigned Directors

```sql

SELECT *  
FROM netflix  
WHERE director IS NULL;
```

13. Count the Number of Movies Featuring Salman Khan in the Last 10 Years

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

15. Categorize Content Based on Keywords 'Kill' and 'Violence'

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
