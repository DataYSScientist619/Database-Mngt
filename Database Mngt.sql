
/*
Data set Airbnb.csv
Exploring Airbnb rise.
*/


SELECT * FROM airbnb;

/*Back up */

CREATE TABLE airbnb_backup AS SELECT * FROM airbnb;

/*Duplicate column*/

SELECT *, property_id AS property_id_duplicate FROM airbnb; 


/*SELECT DISTINCT(property_id) FROM airbnb
WHERE minimum_nights < '0'; */

SELECT * FROM airbnb
ORDER BY minimum_nights ASC;

UPDATE airbnb
SET minimum_nights = ABS(minimum_nights)
WHERE minimum_nights < '0';

SELECT property_id, minimum_nights FROM airbnb
WHERE property_id IN ('24444262', '24474086', '24495073', '39523709', 
	'1244900', '1098541', '1233854', '51410309', '51457807', '1195746', '1291294',
	'1265335', '1221151');

/*
By updating the minimum_nights column where the absolute value of all the rows is taken all the negative
values will be updated to a positive value. The minimum nights column was updated because negtive 
values do not make sense and if left as they were, these values would cause inaccurate calculations 
when aggregated.
*/


SELECT * FROM airbnb
WHERE last_review IS NOT NULL
ORDER BY last_review DESC;

UPDATE airbnb
SET last_review = NULL
WHERE last_review > '2024-10-10';

SELECT property_id, last_review FROM airbnb
WHERE property_id IN ('1142173', '1268097', '1176967', '1106825');

/*
It would be best to update the data by turning the inaccurate dates to null, since there is no
way of correcting the values to their true dates. The where statement was based on todays date
because in theory it could contain dates from the point up until I extracted this data. 
*/


SELECT DISTINCT neighbourhood_group FROM airbnb;

UPDATE airbnb
SET neighbourhood_group = 'Brooklyn'
WHERE neighbourhood_group = 'brookln';

SELECT neighbourhood_group FROM airbnb
WHERE neighbourhood_group = 'brookln';

/*
When checking the different neighborhoods noted in the column it revealed that some of the 
boroughs were spelled differently despite them referring to the same borough. The data was updated for 
the misspelled 'Brookyln' inputs.
*/

SELECT property_id, COUNT(*) AS count
FROM airbnb
GROUP BY property_id
HAVING COUNT(*) > 1;


WITH AirbnbProperties AS ( SELECT *, ROW_NUMBER() OVER (PARTITION BY property_id ORDER BY property_id)
	AS rm
	FROM airbnb
)
DELETE FROM airbnb
WHERE property_id IN (SELECT property_id FROM AirbnbProperties WHERE rm > 1);


SELECT a.property_id FROM airbnb a
WHERE a.property_id IN (
	SELECT b.property_id 
	FROM airbnb_backup b 
	GROUP BY b.property_id
	HAVING COUNT(*) > 1
);



/*
Using common table expression I was able to remove true duplicates in the data.  By 
removing the duplicates improved the accuracy of the calculations performed.
*/



