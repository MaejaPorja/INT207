GRANT SELECT ON EMPLOYEES TO APP32;
REVOKE SELECT ON EMPLOYEES FROM APP32;

-- No
-- 1
-- Transaction A (DBxxxx)
	SELECT SUM(SALARY) FROM EMPLOYEES;
-- 691416
-- Transaction B (APPxxxx)
    SELECT SUM(SALARY) FROM  DB32.EMPLOYEES;
-- No SELECT privilege on EMPLOYEES on SCHEMA DB32.

-- 2
-- Transaction A (DBxxxx)
    UPDATE EMPLOYEES 
    SET SALARY = 70000 
    WHERE FIRST_NAME = 'David';
-- 3 rows updated.
	
-- 3
-- Transaction A (DBxxxx)
	UPDATE EMPLOYEES 
	SET SALARY = 20000 
	WHERE FIRST_NAME = 'Susan';
-- 1 row updated.
	
-- 4
-- Transaction A (DBxxxx)
	SELECT SUM(SALARY)
	FROM EMPLOYEES;
-- 893816
-- Transaction B (APPxxxx)
    SELECT SUM(SALARY) 
    FROM  DB32.EMPLOYEES; 
-- No SELECT privilege on EMPLOYEES on SCHEMA DB32.

-- 5	Write SQL statement to mark an intermediate point called PointOne in the processing of the transaction.
    -- Transaction A (DBxxxx)
    SAVEPOINT PointOne;
-- Savepoint created.

-- 6
    -- Transaction A (DBxxxx)
    UPDATE EMPLOYEES 
	SET SALARY = 50000 
	WHERE FIRST_NAME = 'John';
-- 3 rows updated.
	
-- 7	
    -- Transaction A (DBxxxx)
	SELECT SUM(SALARY)
	FROM EMPLOYEES;
--  1018916
    -- Transaction B (APPxxxx)
    SELECT SUM(SALARY)
    FROM  DB32.EMPLOYEES;
--	No SELECT privilege on EMPLOYEES on SCHEMA DB32.


-- 8	Write SQL statement to mark an intermediate point called PointTwo in the processing of the transaction.
    -- Transaction A (DBxxxx)
    SAVEPOINT PointTwo;
-- Savepoint created.

-- 9
    -- Transaction A (DBxxxx)
	UPDATE EMPLOYEES 
    SET SALARY = 110000 
	WHERE FIRST_NAME = 'Mary';
-- 0 rows updated.
	
-- 10
    -- Transaction A (DBxxxx)
	SELECT SUM(SALARY)
	FROM EMPLOYEES;         
--  1018916
    -- Transaction B (APPxxxx)
    SELECT SUM(SALARY)
    FROM  DB32.EMPLOYEES;
--	No SELECT privilege on EMPLOYEES on SCHEMA DB32.

-- 11	Write SQL statement to discard the most recent UPDATE operation (NO. 9) without discarding the earlier INSERT or UPDATE operations.
    -- Transaction A (DBxxxx)
	ROLLBACK TO SAVEPOINT PointTwo;
-- Rollback complete.

-- 12
    -- Transaction B (APPxxxx)
    UPDATE DB32.EMPLOYEES
	SET DEPARTMENT_ID = 'B005'
	WHERE FIRST_NAME = 'Mary';
-- 0 rows updated.

-- 13
    -- Transaction A (DBxxxx)
	COMMIT;
-- Commite complete.
    -- Transaction B (APPxxxx)
	ROLLBACK;
-- Rollback complete.

-- 14	
    -- Transaction A (DBxxxx)
	SELECT SUM(SALARY)
	FROM EMPLOYEES; 	
-- 1018916
    -- Transaction B (APPxxxx)
    SELECT SUM(SALARY)
    FROM DB32.EMPLYOEES;
--	No SELECT privilege on EMPLOYEES on SCHEMA DB32.
