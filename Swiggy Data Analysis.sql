-- 1. HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?

SELECT COUNT(DISTINCT restaurant_name) AS no_of_restaurants_with_higher_rating
FROM swiggy
WHERE rating > 4.5;

-- 2. WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?

SELECT city, COUNT(DISTINCT restaurant_name) AS restaurant_count
FROM swiggy
GROUP BY city
ORDER BY restaurant_count DESC
LIMIT 1;

-- 3. What are the top-rated restaurants in Bangalore city?

SELECT distinct(restaurant_name), rating
FROM (
    SELECT restaurant_name, rating,
           DENSE_RANK() OVER (ORDER BY rating DESC) AS ranking
    FROM swiggy
    WHERE city = 'Bangalore'
) AS ranked_restaurants
WHERE ranking <= 5;

-- 4. What are the top-rated restaurants in Ahmedabad city?

SELECT distinct(restaurant_name), rating
FROM (
    SELECT restaurant_name, rating,
           DENSE_RANK() OVER (ORDER BY rating DESC) AS ranking
    FROM swiggy
    WHERE city = 'Ahmedabad'
) AS ranked_restaurants
WHERE ranking <= 5;

-- 5. Which cities have the highest average cost per person for dining?

SELECT city, ROUND(avg(cost_per_person),0) as Avg_cost_per_person
FROM swiggy 
GROUP BY city 
ORDER BY Avg_cost_per_person DESC;

-- 6. Are there any correlations between restaurant ratings and the cost per person?

SELECT
    (n * SUMXY - SUMX * SUMY) /
    SQRT((n * SUMX2 - SUMX * SUMX) * (n * SUMY2 - SUMY * SUMY)) AS correlation_coefficient
FROM (
    SELECT
        COUNT(*) AS n,
        SUM(rating * cost_per_person) AS SUMXY,
        SUM(rating) AS SUMX,
        SUM(cost_per_person) AS SUMY,
        SUM(rating * rating) AS SUMX2,
        SUM(cost_per_person * cost_per_person) AS SUMY2
    FROM swiggy
) AS calculations;

-- 7. Which restaurant has the most extensive menu?

select restaurant_name, count(menu_category) as No_of_items_in_menu
FROM swiggy
GROUP BY restaurant_name
ORDER BY No_of_items_in_menu DESC
LIMIT 15;

-- 8. What cuisines are most popular in Bangalore city?

SELECT 
    cuisine, COUNT(cuisine) AS count
FROM
    swiggy
WHERE
    city = 'Bangalore'
GROUP BY cuisine
ORDER BY count DESC
LIMIT 10;

-- 9. What cuisines are most popular in Ahmedabad city?

SELECT 
    cuisine, COUNT(cuisine) AS count
FROM
    swiggy
WHERE
    city = 'Ahmedabad'
GROUP BY cuisine
ORDER BY count DESC
LIMIT 10;

-- 10 . How does the cost per person vary across different menu categories

SELECT 
      menu_category,
      ROUND(avg(cost_per_person),0) as Avg_cost_per_person
      FROM swiggy
      GROUP BY menu_category
      ORDER BY Avg_cost_per_person DESC 
      LIMIT 10;
      
-- 11. What is the average price difference between vegetarian and non-vegetarian items?

WITH ItemAvgPrices AS (
    SELECT
        veg_or_nonveg,
        AVG(price) AS avg_price
    FROM
       swiggy
    GROUP BY
        veg_or_nonveg
)
SELECT
    ABS(V.avg_price - NV.avg_price) AS avg_price_difference
FROM
    ItemAvgPrices V
    CROSS JOIN ItemAvgPrices NV
WHERE
    V.veg_or_nonveg = 'Veg'
    AND NV.veg_or_nonveg = 'Non-veg';
    
-- 12 . How do customer ratings differ for veg and non-veg items?

SELECT 
      veg_or_nonveg, 
      ROUND(avg(RATING),1) AS rating 
      FROM  swiggy
      WHERE veg_or_nonveg IS NOT NULL
      GROUP BY veg_or_nonveg
      ORDER BY rating  DESC;


-- 13. WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU CATEGORY FOR EACH RESTAURANT?

SELECT DISTINCT restaurant_name, menu_category, MAX(price) AS highest_price
FROM swiggy
WHERE menu_category = 'Recommended'
GROUP BY restaurant_name, menu_category;

-- 14. FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE

SELECT DISTINCT restaurant_name, cost_per_person
FROM swiggy
WHERE cuisine <> 'Indian'
ORDER BY cost_per_person DESC
LIMIT 5;

-- 15. FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST HIGHER THAN THE TOTAL AVERAGE COST OF ALL RESTAURANTS TOGETHER.

SELECT DISTINCT restaurant_name, cost_per_person
FROM swiggy
WHERE cost_per_person > (SELECT AVG(cost_per_person) FROM swiggy);

-- 16. RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE LOCATED IN DIFFERENT CITIES.

SELECT DISTINCT t1.restaurant_name, t1.city, t2.city
FROM swiggy t1
JOIN swiggy t2 ON t1.restaurant_name = t2.restaurant_name AND t1.city <> t2.city;

-- 17. WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE' CATEGORY?

SELECT DISTINCT restaurant_name, menu_category, COUNT(item) AS no_of_items
FROM swiggy
WHERE menu_category = 'Main Course'
GROUP BY restaurant_name, menu_category
ORDER BY no_of_items DESC
LIMIT 1;

-- 18. LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGETARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME.

SELECT DISTINCT restaurant_name,
(SUM(CASE WHEN veg_or_nonveg = 'Veg' THEN 1 ELSE 0 END) * 100 / COUNT(*)) AS vegetarian_percentage
FROM swiggy
GROUP BY restaurant_name
HAVING vegetarian_percentage = 100.00
ORDER BY restaurant_name;

-- 19. WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?

SELECT DISTINCT restaurant_name, AVG(price) AS average_price
FROM swiggy
GROUP BY restaurant_name
ORDER BY average_price
LIMIT 1;

-- 20. WHICH TOP 5 RESTAURANTS OFFER THE HIGHEST NUMBER OF CATEGORIES?

SELECT DISTINCT restaurant_name, COUNT(DISTINCT menu_category) AS no_of_categories
FROM swiggy
GROUP BY restaurant_name
ORDER BY no_of_categories DESC
LIMIT 5;

-- 21. WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGETARIAN FOOD?

SELECT DISTINCT restaurant_name,
(COUNT(CASE WHEN veg_or_nonveg = 'Non-Veg' THEN 1 ELSE 0 END) * 100 / COUNT(*)) AS nonvegetarian_percentage
FROM swiggy
GROUP BY restaurant_name
ORDER BY nonvegetarian_percentage DESC
LIMIT 5;






