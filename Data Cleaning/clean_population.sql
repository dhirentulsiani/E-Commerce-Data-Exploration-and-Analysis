DELETE FROM City_Populations
WHERE Population is NULL;

/*
Cenus data had some rows containing text explaining the table
*/

SELECT *
FROM City_Populations
WHERE Population glob "*[A-Z]*";

DELETE FROM City_Populations
WHERE Population glob "[A-Z]*";

/*
City Names are formatted like: "Rio de Contas (BA)"
I want remove the part in brackets.
This function counts the number of rows where the brackets have exactly 2 characters in them.
*/
SELECT COUNT(*)
FROM City_Populations
WHERE cities glob "* ([A-Z][A-Z])";

/*
From the previous code, we found that in all but one row there are exactly 2 characters inside the brackets.

Thus we can just delete 5 characters from the string in each row.

There is one row that does not contain any brackets, But we will not be using that role in further analysis.
*/

UPDATE City_Populations
SET Cities=substr(Cities, 1, LENGTH(Cities) - 5);

