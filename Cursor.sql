DECLARE
    @SSRef			VARCHAR(MAX)
	, @Person		VARCHAR(MAX)
    , @LocalCursor	CURSOR;

SET @LocalCursor = CURSOR FAST_FORWARD FOR 
SELECT C.SSRef, P.Person
FROM dbo.T_Client C
JOIN dbo.T_Person P ON C.PersonID = P.PersonID;

OPEN @LocalCursor;  
FETCH NEXT FROM @LocalCursor INTO @SSRef, @Person;  

WHILE (@@FETCH_STATUS = 0)
BEGIN  
      PRINT @SSRef + '/' + @Person;

      FETCH NEXT FROM @LocalCursor INTO @SSRef, @Person;
END 

CLOSE @LocalCursor;
DEALLOCATE @LocalCursor;
