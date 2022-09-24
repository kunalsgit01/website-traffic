-- Analyzing website traffic of a website

-- website session that drive the most traffic

SELECT 
	utm_content,
	COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
	WHERE website_session_id between 1000 and 2000
GROUP BY 1
ORDER BY 2 DESC;

-- website sessions that drive the most traffic with orders and conversion rate

SELECT 
	utm_content,
	COUNT(DISTINCT w.website_session_id) AS sessions,
	COUNT(DISTINCT o.order_id) AS orders,
	COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id) AS conversion_rate
FROM website_sessions AS w
	LEFT JOIN orders AS o
	ON w.website_session_id = o.website_session_id
WHERE w.website_session_id between 1000 and 2000
GROUP BY 1
ORDER BY 2 DESC;


-- conversion rate with resepect to sources 

SELECT 
	w.utm_source, 
    w.utm_campaign, 
    w.http_referer,
	COUNT(DISTINCT w.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id) AS conversion_rate 
FROM website_sessions AS w
	LEFT JOIN orders as o
	ON w.website_session_id = o.website_session_id
WHERE w.created_at < '2012-04-12'AND
		w.utm_source = 'gsearch' AND
        w.utm_campaign = 'nonbrand'
GROUP BY 
	w.utm_source, 
    w.utm_campaign, 
    w.http_referer
ORDER BY 4 DESC;

-- Counting weekly total sessions
SELECT 
	MIN(DATE(w.created_at)) AS week_date,
	COUNT(DISTINCT w.website_session_id) AS sessions
	
FROM website_sessions as w
	
WHERE w.created_at < '2012-05-10'
GROUP BY
	year(w.created_at),
    week(w.created_at)
ORDER BY 2 DESC;

-- Calculating number of items purchased with each product
SELECT 
    primary_product_id,
    COUNT(CASE WHEN items_purchased = 1 THEN order_id ELSE null END) AS Single_item_order,
    COUNT(CASE WHEN items_purchased = 2 THEN order_id ELSE null END) AS Double_item_order
FROM orders
WHERE order_id between 31000 AND 32000
GROUP BY 1
ORDER BY 1;


-- Analyzing data on the basis of year and weeks
-- Analysis with week and years
SELECT 
    year(created_at) AS Year,
    Week(created_at) AS Week,
    MIN(DATE(created_at)) AS week_date,
    COUNT(DISTINCT website_session_id) AS Session
FROM website_sessions
WHERE website_session_id between 100000 AND 115000
GROUP BY 1,2;


--  Analyzing data  by device type

SELECT 
	w.device_type,
	COUNT(DISTINCT w.website_session_id) AS sessions,
	COUNT(DISTINCT o.order_id) AS orders,
	COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id) AS conversion_rate
FROM website_sessions AS w
	LEFT JOIN orders AS o
	ON w.website_session_id = o.website_session_id
WHERE w.created_at < "2012-05-11" AND
				w.utm_source='gsearch' AND
				w.utm_campaign='nonbrand'
GROUP BY 1
ORDER BY 2 DESC;


-- Analyzing data with device type on weekly basis
SELECT 
        MIN(date(w.created_at)) AS Week_date,
		COUNT(CASE WHEN device_type='desktop' THEN w.website_session_id ELSE null END) AS Conversion_rate_desktop,
		COUNT(CASE WHEN device_type='mobile' THEN w.website_session_id ELSE null END) AS Conversion_rate_mobile,
		COUNT(DISTINCT w.website_session_id) AS  total_session
FROM website_sessions AS w
	LEFT JOIN orders AS o
	ON w.website_session_id = o.website_session_id
WHERE w.created_at < "2012-06-15" AND
		w.created_at > "2012-04-15" AND
		w.utm_source='gsearch' AND
        w.utm_campaign='nonbrand'
GROUP BY 
	year(w.created_at),
	week(w.created_at);