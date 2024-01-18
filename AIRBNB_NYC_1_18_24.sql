USE nyc_airbnb

SELECT *
FROM nyc_airbnb2


-- Average price for each airbnb 
SELECT 
	id, 
	name,
	host_name, 
	neighbourhood_group,
	neighbourhood,
	AVG(price) AS average_price
FROM nyc_airbnb2
GROUP BY 
	id, 
	name,
	host_name, 
	neighbourhood_group,
	neighbourhood
ORDER BY average_price DESC

-- NEIGHBOURHOOD
--- Average neighbourhood lisitng price 
WITH ranking 
AS( 
	SELECT
		neighbourhood_group,
		neighbourhood,
		AVG(price) OVER (PARTITION BY neighbourhood ORDER BY neighbourhood_group) AS avg_price_per_neighbourhood,
		ROW_NUMBER() OVER (PARTITION BY neighbourhood ORDER BY neighbourhood_group) AS row_num
		FROM nyc_airbnb2
		)
SELECT 
neighbourhood_group,
neighbourhood,
avg_price_per_neighbourhood
FROM ranking
WHERE row_num = 1

--- min neighbourhood lisitng price 
WITH ranking2 
AS( 
	SELECT
		neighbourhood_group,
		neighbourhood,
		MIN(price) OVER (PARTITION BY neighbourhood ORDER BY neighbourhood_group) AS min_price_per_neighbourhood,
		ROW_NUMBER() OVER (PARTITION BY neighbourhood ORDER BY neighbourhood_group) AS row_num
		FROM nyc_airbnb2
		)
SELECT 
neighbourhood_group,
neighbourhood,
min_price_per_neighbourhood
FROM ranking2
WHERE row_num = 1


--- max neighbourhood lisitng price 
WITH ranking3 
AS( 
	SELECT
		neighbourhood_group,
		neighbourhood,
		MAX(price) OVER (PARTITION BY neighbourhood ORDER BY neighbourhood_group) AS max_price_per_neighbourhood,
		ROW_NUMBER() OVER (PARTITION BY neighbourhood ORDER BY neighbourhood_group) AS row_num
		FROM nyc_airbnb2
		)
SELECT 
neighbourhood_group,
neighbourhood,
max_price_per_neighbourhood
FROM ranking3
WHERE row_num = 1

-- NEIGHBOURHOOD_GROUP
--- Average neighbourhood_group lisitng price 
WITH ranking_group 
AS( 
	SELECT
		neighbourhood_group,
		neighbourhood,
		ROUND(AVG(price) OVER (ORDER BY neighbourhood_group ),2) AS avg_price_per_neighbourhood_group,
		ROW_NUMBER() OVER (PARTITION BY neighbourhood_group ORDER BY neighbourhood_group) AS row_num1
		FROM nyc_airbnb2
		)
SELECT 
neighbourhood_group,
neighbourhood,
avg_price_per_neighbourhood_group
FROM ranking_group
WHERE row_num1 = 1
ORDER BY avg_price_per_neighbourhood_group DESC

--- min neighbourhood_group lisitng price 
WITH ranking2 
AS( 
	SELECT
		neighbourhood_group,
		neighbourhood,
		MIN(price) OVER (ORDER BY neighbourhood_group) AS min_price_per_neighbourhood_group,
		ROW_NUMBER() OVER (PARTITION BY neighbourhood_group ORDER BY neighbourhood_group) AS row_num
		FROM nyc_airbnb2
		)
SELECT 
neighbourhood_group,
neighbourhood,
min_price_per_neighbourhood_group
FROM ranking2
WHERE row_num = 1

-- max neighbourhood lisitng price
WITH ranking3 
AS( 
	SELECT
		neighbourhood_group,
		neighbourhood,
		MAX(price) OVER (ORDER BY neighbourhood_group) AS max_price_per_neighbourhood_group,
		ROW_NUMBER() OVER (PARTITION BY neighbourhood_group ORDER BY neighbourhood_group) AS row_num
		FROM nyc_airbnb2
		)
SELECT 
neighbourhood_group,
neighbourhood,
max_price_per_neighbourhood_group
FROM ranking3
WHERE row_num = 1

-- Delta per listing in neighourhood
SELECT
		id,
		name,
		neighbourhood_group,
		neighbourhood,
		AVG(price) OVER (PARTITION BY neighbourhood ORDER BY neighbourhood_group) AS avg_price_per_neighbourhood,
		ROUND(price - AVG(price) OVER(PARTITION BY neighbourhood ORDER BY neighbourhood_group),2) AS delta_neighourhood
		FROM nyc_airbnb2


-- Top 3 neighbourhood_groups with most expensive properties

WITH rank_by_group
AS(
	SELECT 
		neighbourhood_group,
		MAX(price) OVER (ORDER BY neighbourhood_group) AS max_price_per_neighbourhood_group,
		ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY neighbourhood_group) AS ranking
	FROM nyc_airbnb2
) 

SELECT 
	neighbourhood_group,
	max_price_per_neighbourhood_group
FROM rank_by_group
WHERE ranking = 1
ORDER BY max_price_per_neighbourhood_group DESC

	
-- price from most recent review

SELECT 
	id,
	name,
	price,
	last_review,
	LAG(price) OVER(PARTITION BY last_review ORDER BY last_review) AS price_during_last_review
FROM nyc_airbnb2








