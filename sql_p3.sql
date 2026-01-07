-- Active: 1764344437790@@127.0.0.1@3306@netflix_p3
create DATABASE netflix_p3


use netflix_p3

create table netflix(
                show_id      VARCHAR (10),
                type	    VARCHAR (10),
                title        VARCHAR(105),
                director     VARCHAR(250),
                cast	    VARCHAR(1000),
                country	    VARCHAR(150),
                date_added   VARCHAR(50),
                release_year int,
                rating       VARCHAR(10),
                duration     VARCHAR(15),
                listed_in    VARCHAR(25),
                description  VARCHAR(250)    

)





--1.Count the number of Movies vs TV Shows
select  
     type,
     count(*) as total_content 
     from netflix 
     GROUP BY type


-- 3. Find the most common rating for Movies and TV shows

 select type,rating
    from
    (select 
        type,
        rating,
        COUNT(*),
        rank() over(PARTITION BY type order BY count(*) desc) as ranking
 from netflix
 GROUP BY 1,2) as t1
 where ranking=1

-- 4. List all movies released in a specific year (e.g., 2020)

select * from netflix
where release_year='2020'
and type='Movie'



-- 5. Find the top 5 countries with the most content on Netflix
select country,
       COUNT(*) as total_content
       from netflix
GROUP BY country


-- 6. Identify the longest movie or TV show duration

select * from netflix
where 
     type ='Movie' and
     duration =(SELECT max(duration) from netflix)


-- 7. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE 
     STR_TO_DATE(date_added,'%M %d,%Y')>= CURRENT_DATE - INTERVAL 5 YEAR;


-- 8. Find all the movies/TV shows by director 'Rjiv Chilakas'
select * from netflix
WHERE
     director like '%Rajiv Chilaka%'


-- 9. List all TV shows with more than 5 seasons
SELECT *
FROM netflix
WHERE 
     type='Tv show' and 
     CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)>=5



-- 10. Count the number of content items in each genre
SELECT 
    CONCAT('[\"', REPLACE(listed_in, ',', '\",\"'), '\"]') AS json_array,
    count(show_id) as total_content
FROM netflix
GROUP BY 1;



-- 11. Find each year and the average number of content relese by india on netflix.
-- return top 5 years with highest avg content relese

select 
          year(STR_TO_DATE(date_added,'%M %d,%Y'))as year,
          count(*) as yearly_content,
          count(*)/(select count(*) from netflix where country='India') * 100 as avg_content

from netflix 
where  country ='India'
GROUP BY 1 


--12.Find all  the movies that are documentaries
select * from netflix 
where listed_in like 'Documentaries'


-- 13. Find all content without a director

SELECT * from netflix
where director is null


-- 14. Find how many movies actor 'Salman Khan' appeared in last 12 years! 

SELECT * from netflix 
WHERE
     cast like '%salman khan%' AND
     release_year>year( CURRENT_DATE)-12;



-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in 'India'
select 
     unnest(string_to_array(casts,',')) as actors,
     count(*)as Total_content
from netflix
     where country like '%india%'
     GROUP BY 1
     ORDER BY 2 desc 
     limit 10


-- 15.Categorize the content based on the presence of the keywords 'kill' 
--    and 'violence' in the description field. Label content containing these keywords
--    as 'Bad' and all other content as 'Good'. Count how many items fall into each category

select 
     (CASE 
          WHEN DESCRIPTION like '%kill%' or  
          DESCRIPTION like '%violence%' THEN  'Bad Content'
          ELSE  'Good content'
     END  )as category,
     count(*) as total_content
     from netflix
     GROUP BY category
