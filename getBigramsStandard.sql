#standardSQL

/*
Problem: Using bigquery, split text into bigram with a single query.

To solve this problem we use regex to replace every second space with another character ( in my case I use `|` character ). Second step is to split by that character. Thrid step is to filter out single words resulted.

text: "we want to split text into bigrams"
step1: regexreplace  => "we want|to split|text into|bigrams" + "|" + "we|want to|split text|into bigrams"
step2: split => ["we want", "to split", "text into", "bigrams", "we", "want to", "split text", "into bigrams"]
step3: filter bigrams without space =>  ["we want", "to split", "text into", "want to", "split text", "into bigrams"]
*/

WITH sentences AS (
  SELECT 'hello   world how are you ' AS sentence
)

SELECT CONCAT('-',bigrams,'-') FROM  
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
	FROM sentences -- Table name
)  t
CROSS JOIN UNNEST(t.bigram) as bigrams
WHERE REGEXP_CONTAINS(bigrams, r"[^\s]+\s+[^\s]+")
