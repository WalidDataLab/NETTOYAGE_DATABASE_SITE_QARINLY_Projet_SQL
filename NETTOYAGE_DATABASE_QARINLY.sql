


SELECT 
    id,
    name,
 			  TRIM(
                           	REGEXP_REPLACE(
                            REGEXP_REPLACE(
                            REGEXP_REPLACE(
                            REGEXP_REPLACE(    
                            REGEXP_REPLACE( 
                            REGEXP_REPLACE(  
                            REGEXP_REPLACE(
                          	REGEXP_REPLACE(
				        	REGEXP_REPLACE(
							REGEXP_REPLACE(name,
			'\\s+[0-9]+(GB|TB)\\b', ''),                                    -- delete storage size (e.g. 128GB, 1TB)
			'\\s+(NA|SA|VN|AU|NP|Duos|Top|PH|WiMAX 2+|Dual|ID|TR|TH|MY|EG|VN|PK|UA|BD|US|AE|KH|SG|PL|NZ|ZA|MN|AM|NE|BR|MEA)\\b',''), -- delete region/country codes
			'\\s+V(?![9]{1}\b)[0-8]{1}\\b',''),                            -- delete V1, V2, V6
			'\\s+V(?![9]{1}\b)[0-9]{3,9}\\b',''),                          -- delete V100, V2024, V9999
			'\\s+(D|E|P|V)[0-9]{3}\\b',''),                               -- delete model codes (e.g. D123, E456)
			'\\bApple\\b',''),                                           -- delete Google
			'\\s+version [A-Z0-9]{0,9}(?: [A-Z])*\\b',''),                 -- delete version text
			'[[:space:]]*/[[:space:]]*$', ''),                            -- delete trailing slash
			'[[:space:]]*/ /[[:space:]]*$', ''),                          -- delete invalid slash pattern
			'\\s*/+\\s*', ' ')                                            -- replace slash with space
    ) AS base_name
FROM devices
WHERE brand_id = 6;

								-- DO BACKUP IMPORTANAT --
CREATE TABLE devices_backup_ZENPHONE AS SELECT * FROM devices;

-- add new column
ALTER TABLE devices ADD COLUMN base_name VARCHAR(255);
update devices
set base_name =  
 			 TRIM(
                           	REGEXP_REPLACE(
                            REGEXP_REPLACE(
                            REGEXP_REPLACE(
                            REGEXP_REPLACE(    
                            REGEXP_REPLACE( 
                            REGEXP_REPLACE(  
                            REGEXP_REPLACE(
                          	REGEXP_REPLACE(
				        	REGEXP_REPLACE(
							REGEXP_REPLACE(name,
			'\\s+[0-9]+(GB|TB)\\b', ''),                                    -- delete storage size (e.g. 128GB, 1TB)
			'\\s+(NA|SA|VN|AU|NP|Duos|Top|PH|WiMAX 2+|Dual|ID|TR|TH|MY|EG|VN|PK|UA|BD|US|AE|KH|SG|PL|NZ|ZA|MN|AM|NE|BR|MEA)\\b',''), -- delete region/country codes
			'\\s+V(?![9]{1}\b)[0-8]{1}\\b',''),                            -- delete V1, V2, V6
			'\\s+V(?![9]{1}\b)[0-9]{3,9}\\b',''),                          -- delete V100, V2024, V9999
			'\\s+(D|E|P|V)[0-9]{3}\\b',''),                               -- delete model codes (e.g. D123, E456)
			'\\bApple\\b',''),                                           -- delete Google
			'\\s+version [A-Z0-9]{0,9}(?: [A-Z])*\\b',''),                 -- delete version text
			'[[:space:]]*/[[:space:]]*$', ''),                            -- delete trailing slash
			'[[:space:]]*/ /[[:space:]]*$', ''),                          -- delete invalid slash pattern
			'\\s*/+\\s*', ' ')  
)
WHERE brand_id = 6
ORDER BY base_name, id;

-- see the repetaed before delte
SELECT base_name, COUNT(*) AS total, MIN(id) AS keep_id
FROM devices
WHERE brand_id = 6
  AND base_name IS NOT NULL
GROUP BY base_name
HAVING COUNT(*) > 1
ORDER BY total DESC;

-- on attack delete the repeted phones
DELETE d FROM devices d
JOIN (
    SELECT base_name, MIN(id) AS keep_id
    FROM devices
    WHERE brand_id = 6
      AND base_name IS NOT NULL
    GROUP BY base_name
) k ON d.base_name = k.base_name
WHERE d.brand_id = 6
  AND d.base_name IS NOT NULL
  AND d.id <> k.keep_id;

-- change the name of devices to make it clean
  UPDATE devices
SET name = base_name
WHERE brand_id = 6
  AND base_name IS NOT NULL;
  
  -- delete the column 
  ALTER TABLE devices DROP COLUMN base_name;
  
  -- check every things
select 	
		devices.name as device_name,
		devices.id,
		devices.brand_id,
        brands.name as name_brand
 from devices
 join brands 
 ON brands.id = devices.brand_id
 where devices.brand_id = 6
 

 
 



 
 


