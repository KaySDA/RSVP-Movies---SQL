USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT table_name, 
		table_rows
From information_schema.tables
Where table_schema = 'imdb';

/* director_mapping	3867
			genre	14662
			movie	8303
			names	22623
			ratings	8230
	    role_mapping 16029
*/

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

WITH null_info
	 AS (SELECT 'id' AS 'Column_Name', Count(*) AS Null_Values
         FROM   movie
         WHERE  id IS NULL
         UNION ALL
         SELECT 'title' AS 'Column_Name', Count(*) AS Null_Values
         FROM   movie
         WHERE  title IS NULL
         UNION ALL
         SELECT 'year' AS 'Column_Name', Count(*) AS Null_Values
         FROM   movie
         WHERE  year IS NULL
         UNION ALL
         SELECT 'date_published' AS 'Column_Name', Count(*) AS Null_Values
         FROM   movie
         WHERE  date_published IS NULL
         UNION ALL
         SELECT 'duration' AS 'Column_Name', Count(*) AS Null_Values
         FROM   movie
         WHERE  duration IS NULL
         UNION ALL
         SELECT 'country' AS 'Column_Name', Count(*) AS Null_Values
         FROM   movie
         WHERE  country IS NULL
         UNION ALL
         SELECT 'worlwide_gross_income' AS 'Column_Name', Count(*) AS Null_Values
         FROM   movie
         WHERE  worlwide_gross_income IS NULL
         UNION ALL
         SELECT 'languages' AS 'Column_Name', Count(*) AS Null_Values
         FROM   movie
         WHERE  languages IS NULL
         UNION ALL
         SELECT 'production_company' AS 'Column_Name', Count(*) AS Null_Values
         FROM   movie
         WHERE  production_company IS NULL)
SELECT column_name
FROM   null_info
WHERE Null_Values > 0
ORDER  BY null_values DESC;

-- worlwide_gross_income, production_company, languages and counntry have null values. 

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Total number of movies released each year
SELECT year, COUNT(id) AS number_of_movies
FROM movie
GROUP BY year;
/*
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	3052			|
|	2018		|	2944			|
|	2019		|	2001			|
+---------------+-------------------+
*/

-- Number of movies released per month
SELECT 
	MONTH(date_published) as month_rel,
	COUNT(id) as number_of_movies
FROM movie
GROUP BY 
	month_rel
ORDER BY 
	number_of_movies DESC;

-- Movies produced are highest in the month of March i.e. 824 movies. 

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT Count(id) AS movie_counts
FROM   movie
WHERE  country REGEXP 'USA|India'
       AND year = 2019;

-- USA and India produced 1059 movies in the year 2019.

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT genre
FROM genre
GROUP BY genre
ORDER BY genre;

/* Following are the genres. For better readability i have order by alphabets. 
Action
Adventure
Comedy
Crime
Drama
Family
Fantasy
Horror
Mystery
Others
Romance
Sci-Fi
Thriller
*/


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre, 
		COUNT(m.id) AS number_of_movies
From genre g
		INNER JOIN movie m
				ON g.movie_id=m.id
GROUP BY 
	genre
ORDER BY
	number_of_movies DESC LIMIT 1;

-- Drama genre has the highest number of movies produced i.e. 4285.
    

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

With single_genre
	AS (SELECT movie_id, 
				COUNT(DISTINCT genre) AS n_genre
		FROM
			genre
		GROUP BY
			movie_id
		HAVING n_genre = 1)
SELECT COUNT(*) 
	AS 'Number_of_movies_one_genre'
From
	single_genre;

-- 3289 movies are belongs to one genre. 

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH avg_dur 
AS 
(
SELECT 
    genre, 
    ROUND(AVG(duration), 2) AS avg_duration, 
    RANK() OVER(ORDER BY AVG(duration) DESC
) 
FROM 
    genre g 
    INNER JOIN movie m ON m.id = g.movie_id 
    
GROUP BY 
    genre
) 
SELECT 
  genre, 
  avg_duration 
FROM 
  avg_dur;

 /* 
genre  		avg_dura
Action	 	112.88
Romance		109.53
Crime 		107.05
Drama		106.77
Fantasy		105.14
Comedy		102.62
Adventure	101.87
Mystery		101.80
Thriller	101.58
Family		100.97
Others		100.16
Sci-Fi		97.94
Horror		92.72
*/

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_information
	AS
(
SELECT genre, 
		COUNT(DISTINCT movie_id) AS movie_count, 
        RANK()
        OVER 
			(ORDER BY COUNT(movie_id) DESC)
				AS genre_rank
		FROM genre
        GROUP BY genre
)
SELECT *
FROM 
	genre_information
WHERE
	genre = 'THRILLER';

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT Min(avg_rating)    
			AS min_avg_rating,
       Max(avg_rating)    
			AS max_avg_rating,
       Min(total_votes)   
			AS min_total_votes,
       Max(total_votes)   
			AS max_total_votes,
       Min(median_rating) 
			AS min_median_rating,
       Max(median_rating) 
			AS max_median_rating
FROM   
ratings;
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH movie_rank
	AS 
(
SELECT 
    title, 
    avg_rating, 
    RANK() 
    OVER 
		(ORDER BY 
			avg_rating DESC) AS movie_rank 
  FROM 
    ratings as r
    INNER JOIN movie as m
		ON r.movie_id = m.id
) 
SELECT * 
FROM 
  movie_rank
WHERE 
  movie_rank <= 10;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
  median_rating, 
  COUNT(movie_id) AS movie_count 
FROM 
  ratings 
GROUP BY 
  median_rating 
ORDER BY 
  median_rating;	

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_ranking
	AS
(
SELECT production_company, 
		COUNT(movie_id)
			AS movie_count, 
		Rank()
			OVER(ORDER BY COUNT(movie_id) DESC)
				AS prod_company_rank
From
	ratings as r
		INNER JOIN movie as m
				ON r.movie_id=m.id
WHERE avg_rating > 8 
		AND production_company is not NULL
GROUP BY production_company)
SELECT *
FROM prod_ranking
WHERE prod_company_rank = 1;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
  genre, 
  Count(m.id) AS movie_count 
FROM 
  genre g 
  INNER JOIN movie AS m 
			ON g.movie_id = m.id 
  INNER JOIN ratings AS r 
			ON m.id = r.movie_id 
WHERE 
  Month(date_published) = 3 
  AND year = 2017 
  AND country = 'USA' 
  AND total_votes > 1000 
GROUP BY 
  genre 
ORDER BY 
  movie_count DESC;

/*
genre 	movie_count
Drama		16
Comedy		8
Crime		5
Horror		5
Action		4
Sci-Fi		4
Thriller	4
Romance		3
Fantasy		2
Mystery		2
Family		1
*/

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
  title, 
  avg_rating, 
  genre 
FROM 
  genre AS g
  INNER JOIN movie AS m 
			ON g.movie_id = m.id 
  INNER JOIN ratings AS r 
			ON m.id = r.movie_id 
WHERE title LIKE 'THE%'
		AND avg_rating > 8
ORDER BY 
		avg_rating DESC;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

SELECT 
  title, 
  avg_rating, 
  genre,
  median_rating
FROM 
  genre AS g
  INNER JOIN movie AS m 
			ON g.movie_id = m.id 
  INNER JOIN ratings AS r 
			ON m.id = r.movie_id 
WHERE title LIKE 'THE%'
		AND avg_rating > 8
ORDER BY 
        median_rating DESC;
        
        
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
  median_rating, 
  COUNT(movie_id) AS movie_count 
FROM 
  movie AS m 
  INNER JOIN ratings AS r ON m.id = r.movie_id 
WHERE 
  date_published between '2018-04-01' AND '2019-04-01'
  AND median_rating = 8;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Comparing total votes as country of origin
SELECT country, 
		SUM(total_votes) AS Total_Votes
FROM ratings AS r
		INNER JOIN movie AS m
				ON r.movie_id = m.id
WHERE country IN ('Germany', 'Italy')
GROUP BY 
	country;

-- Now, comparing total votes based on languages the movies are available

WITH german_movies
	AS 
(
SELECT 
	languages, 
    SUM(total_votes) AS Total_Votes
FROM ratings AS r
		INNER JOIN movie AS m
				ON r.movie_id = m.id
WHERE languages LIKE '%german%'
GROUP BY languages)
SELECT 
	'German' AS Language, 
    SUM(total_votes) AS Total_Votes
FROM german_movies

UNION

(WITH italian_movies
	AS 
(
SELECT 
	languages, 
    SUM(total_votes) AS Total_Votes
FROM ratings AS r
		INNER JOIN movie AS m
				ON r.movie_id = m.id
WHERE languages LIKE '%italian%'
GROUP BY languages)
SELECT 
	'Italian' AS Language, 
    SUM(total_votes) AS Total_Votes
FROM italian_movies
); 
	
-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
  COUNT(*) - COUNT(name) AS name_nulls, 
  COUNT(*) - COUNT(height) AS height_nulls, 
  COUNT(*) - COUNT(date_of_birth) AS date_of_birth_nulls, 
  COUNT(*) - COUNT(known_for_movies) AS known_for_movies_nulls 
FROM 
  names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_genre AS 
(
  SELECT 
    genre 
  FROM 
    genre AS g 
    INNER JOIN ratings AS r USING(movie_id) 
  WHERE 
    avg_rating > 8 
  GROUP BY 
    genre 
  ORDER BY 
    COUNT(movie_id) DESC 
  LIMIT 
    3
) 
SELECT 
  name AS director_name, 
  COUNT(dm.movie_id) As movie_count 
FROM 
  names AS n 
  INNER JOIN director_mapping AS dm ON n.id = dm.name_id 
  INNER JOIN genre AS g ON dm.movie_id = g.movie_id 
  INNER JOIN ratings AS r ON r.movie_id = g.movie_id 
WHERE 
  avg_rating > 8 
  AND genre IN (
    SELECT 
      * 
    FROM 
      top_genre
  ) 
GROUP BY 
  name 
ORDER BY 
  COUNT(dm.movie_id) DESC 
LIMIT 
  3;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
	n.name AS actor_name, 
    COUNT(r.movie_id) AS movie_count
FROM 
	names AS n
		INNER JOIN role_mapping AS rm
				ON n.id = rm.name_id
		INNER JOIN ratings AS r
				ON rm.movie_id = r.movie_id
WHERE
	median_rating >= 8
GROUP BY
	n.name
ORDER BY
	movie_count DESC
    LIMIT 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_prod AS 
(
  SELECT 
    production_company, 
    SUM(total_votes) AS vote_count, 
    RANK() OVER (
      ORDER BY 
        SUM(total_votes) DESC
    ) AS prod_comp_rank 
  FROM 
    ratings AS r
    INNER JOIN movie AS m 
			ON r.movie_id = m.id 
  GROUP BY 
    production_company
) 
SELECT 
  * 
FROM 
  top_prod 
WHERE 
  prod_comp_rank <= 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_rat_act
	AS 
(
  SELECT 
    name AS actor_name, 
    SUM(total_votes) AS total_votes, 
    COUNT(r.movie_id) AS movie_count, 
    ROUND(SUM(avg_rating * total_votes)/ SUM(total_votes), 2) 
				AS actor_avg_rating 
  FROM 
    movie AS m 
    INNER JOIN ratings AS r ON m.id = r.movie_id 
    INNER JOIN role_mapping AS rm ON rm.movie_id = m.id 
    INNER JOIN names AS n ON rm.name_id = n.id 
  WHERE 
    country REGEXP 'INDIA' 
    AND category = 'actor' 
  GROUP BY 
    name
  HAVING 
    movie_count >= 5
) 
SELECT *, 
  RANK() 
  OVER (ORDER BY 
      actor_avg_rating DESC, 
      total_votes DESC) 
			AS actor_rank 
FROM 
  top_rat_act;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH ind_actress
     AS (SELECT n.NAME AS actress_name,
		 Sum(total_votes) AS total_votes,
		 Count(r.movie_id) AS movie_count,
		 Round(Sum(total_votes * avg_rating) / Sum(total_votes), 2) AS actor_avg_rating,
                Rank() OVER(ORDER BY Round(Sum(total_votes * avg_rating)/Sum(total_votes), 2) DESC,
					Sum(total_votes) DESC) AS actress_rank
FROM names AS n
		INNER JOIN role_mapping rm
				ON n.id = rm.name_id
		INNER JOIN movie m
				ON rm.movie_id = m.id
		INNER JOIN ratings r
				ON rm.movie_id = r.movie_id
WHERE  country = 'India'
		AND category = 'actress'
		AND languages = 'Hindi'
GROUP  BY n.NAME
HAVING movie_count >= 3)
SELECT *
FROM 
	ind_actress
WHERE  
	actress_rank <= 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
	title AS movie_title,
    avg_rating,
    CASE
		WHEN avg_rating > 8 THEN 'Superhit movie'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movie'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'ONE-time-watch movie'
        ELSE 'Flop movie'
			END Movie_type
FROM 
	genre AS g
    INNER JOIN movie  AS m
			ON g.movie_id = m.id
	INNER JOIN ratings AS r
			ON m.id = r.movie_id
WHERE
	g.genre = 'Thriller'
ORDER BY
	avg_rating DESC;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
  genre, 
  ROUND(
    AVG(duration), 
    2
  ) AS avg_duration, 
  ROUND(
    SUM(
      AVG(duration)
    ) OVER (
      ORDER BY 
        genre ROWS UNBOUNDED PRECEDING
    ), 
    2
  ) AS running_total_duration, 
  ROUND(
    AVG(
      AVG(duration)
    ) OVER (
      ORDER BY 
        genre ROWS UNBOUNDED PRECEDING
    ), 
    2
  ) AS moving_avg_duration 
FROM 
  movie AS m 
  INNER JOIN genre AS g ON m.id = g.movie_id 
GROUP BY 
  genre;

-- This can be done using below method and code also. 

SELECT 
	genre, 
    ROUND(AVG(duration)) AS avg_duration,
    ROUND(SUM(AVG(duration)) OVER w1, 1) AS running_total_duration,
	ROUND(AVG(AVG(duration)) OVER w2, 2) AS moving_avg_duration
FROM
	genre as g
		INNER JOIN movie as m
				ON g.movie_id = m.id
GROUP BY
	genre
WINDOW 
	w1 AS (ORDER BY genre ROWS unbounded preceding),
    w2 AS (ORDER BY genre ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING);
    

-- Round is good to have and not a must have; Same thing applies to sorting
-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- Checking data types 
SELECT column_name,
       data_type
FROM   information_schema.columns
WHERE  table_schema = 'imdb'
       AND table_name = 'movie'
       AND column_name = 'worldwide_gross_income';

-- Data type is Varchar which needs to be changed to numeric in order to get correct results

WITH top_gen AS
(
SELECT
	genre
FROM 
	genre AS g
		INNER JOIN ratings as r
				ON g.movie_id=r.movie_id
WHERE
	avg_rating > 8
GROUP BY
	genre
ORDER BY
	COUNT(r.movie_id) DESC 
    LIMIT 3
),
movie_inc AS
(
SELECT
	g.genre, 
    year, 
    title AS movie_name,
CASE
	WHEN worlwide_gross_income LIKE 'INR%' 
				THEN Cast(Replace(worlwide_gross_income, 'INR', '') AS DECIMAL(12))
			 WHEN worlwide_gross_income LIKE '$%' 
				THEN Cast(Replace(worlwide_gross_income, '$', '') AS DECIMAL(12))
			 ELSE Cast(worlwide_gross_income AS DECIMAL(12))
		   END worldwide_gross_income
FROM
	genre AS g
		INNER JOIN movie AS M
				ON g.movie_id = m.id,
		top_gen
WHERE 
	g.genre IN (top_gen.genre)
GROUP BY movie_name
ORDER BY year
),
top_movies AS
(
SELECT *, 
	DENSE_RANK() OVER(PARTITION BY year
		ORDER BY worldwide_gross_income DESC) AS movie_rank
FROM 
	movie_inc
)
SELECT *
FROM top_movies
WHERE movie_rank <= 5;


	

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH multiling_prod_com AS 
(
  SELECT 
    production_company, 
    COUNT(r.movie_id) AS movie_count, 
    RANK() OVER (
      ORDER BY 
        COUNT(r.movie_id) DESC
    ) AS prod_comp_rank 
  FROM 
    movie AS m 
    INNER JOIN ratings AS r ON m.id = r.movie_id 
  WHERE 
    median_rating >= 8 
    AND POSITION(',' IN languages) <> 0 
    AND production_company IS NOT NULL 
  GROUP BY 
    production_company
) 
SELECT * 
FROM 
  multiling_prod_com 
WHERE 
  prod_comp_rank <= 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_drama_actrs AS 
(
  SELECT 
    name AS actress_name, 
    SUM(total_votes) AS total_votes, 
    COUNT(r.movie_id) AS movie_count, 
    AVG(avg_rating) AS actress_avg_rating, 
    ROW_NUMBER() OVER (
      ORDER BY 
        COUNT(r.movie_id) DESC
    ) AS actress_rank 
  FROM 
    movie AS m 
    INNER JOIN ratings AS r ON r.movie_id = m.id 
    INNER JOIN role_mapping AS rm ON rm.movie_id = m.id 
    INNER JOIN names AS n ON rm.name_id = n.id 
    INNER JOIN genre AS g ON g.movie_id = m.id 
  WHERE 
    genre = 'Drama' 
    AND avg_rating > 8 
    AND category = 'actress' 
  GROUP BY 
    name
) 
SELECT 
  * 
FROM 
  top_drama_actrs 
WHERE 
  actress_rank <= 3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH director_info
     AS (SELECT dm.name_id,
                n.name,
                dm.movie_id,
                r.avg_rating,
                r.total_votes,
                m.duration,
                date_published,
                Lag(date_published, 1) OVER(PARTITION BY dm.name_id
ORDER BY date_published) AS previous_date_published
         FROM   names n
                INNER JOIN director_mapping dm
                        ON n.id = dm.name_id
                INNER JOIN movie m
                        ON dm.movie_id = m.id
                INNER JOIN ratings r
                        ON m.id = r.movie_id),
     top_directors
     AS (SELECT name_id AS director_id,
                NAME AS director_name,
                Count(movie_id) AS number_of_movies,
                Round(Avg(Datediff(date_published, previous_date_published))) AS avg_inter_movie_days,
                Round(sum(avg_rating*total_votes)/sum(total_votes), 2) AS avg_rating,
                Sum(total_votes) AS total_votes,
                Round(Min(avg_rating), 1) AS min_rating,
                Round(Max(avg_rating), 1) AS max_rating,
                Sum(duration) AS total_duration,
                Rank() OVER(ORDER BY Count(movie_id) DESC) AS director_rank
         FROM   director_info
         GROUP  BY director_id)
SELECT director_id,
       director_name,
       number_of_movies,
       avg_inter_movie_days,
       avg_rating,
       total_votes,
       min_rating,
       max_rating,
       total_duration
FROM   top_directors
WHERE  director_rank <= 9;





