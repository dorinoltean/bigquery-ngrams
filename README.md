# bigquery-ngrams
Use bigqeruy to split text into ngrams


## Bigrams:

*Problem: Using bigquery, split text into bigram with a single query.*

To solve this problem we use regex to replace every second space with another character ( in my case I use `|` character ). Second step is to split by that character. Thrid step is to filter out single words resulted.

text: "we want to split text into bigrams"
step1: regexreplace  => "we want|to split|text into|bigrams" + "|" + "we|want to|split text|into bigrams"
step2: split => ["we want", "to split", "text into", "bigrams", "we", "want to", "split text", "into bigrams"]
step3: filter bigrams without space =>  ["we want", "to split", "text into", "want to", "split text", "into bigrams"]

*file: [getbigrams.sql](/blob/master/getbigrams.sql)"
