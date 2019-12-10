#standardSQL

/*
Problem: Using bigquery, split text into bigram with a single query.

To solve this problem we use regex to replace every second space with another character ( in my case I use `|` character ). Second step is to split by that character. Thrid step is to filter out single words resulted.

text: "we want to split text into bigrams"
step1: Sanitize text
		"hello #$%^&* ` ` `world (how) are you # $ 910 %9k" ====> "hello world how are you 910 9k"
		Trim special characters from all the words in the sentance
step2: regexreplace  => "we want|to split|text into|bigrams" + "|" + "we|want to|split text|into bigrams"
step3: split => ["we want", "to split", "text into", "bigrams", "we", "want to", "split text", "into bigrams"]
step4: filter bigrams without space =>  ["we want", "to split", "text into", "want to", "split text", "into bigrams"]
*/

WITH sentences AS (
            SELECT 'hello #$%^&* ` ` `world (how) are you # $ 910 %9k some.email@gmail.com incredible' AS sentence
  UNION ALL SELECT '~भारत माता की "जय"' AS sentence
)

SELECT bigrams FROM  
 (
	SELECT 
		SPLIT
		( 
      		CONCAT(
        		REGEXP_REPLACE(sentence , '([^\\s]+\\s+[^\\s]*)\\s+', '\\1|'),
        		'|',
        		REGEXP_REPLACE(sentence, '([^\\s]+)\\s+([^\\s]+\\s?)', '\\1|\\2')  
      		),  
			'|'
		) as bigram
	FROM (
		SELECT 
			-- Sanitize text
			REGEXP_REPLACE(sentence , r'[\[\]\\`,~!@#$%^&*()\-_=+}{\'";:/?.>,<\s]*(.*?)[\[\]\\`,~!@#$%^&*()\-_=+}{\'";:/?.>,<]*?(\s+?|$)', '\\1 ') as sentence
		FROM sentences
	)
)  t
CROSS JOIN UNNEST(t.bigram) as bigrams
WHERE REGEXP_CONTAINS(bigrams, r"[^\s]+\s+[^\s]+")


