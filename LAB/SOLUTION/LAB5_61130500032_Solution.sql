-- Question: Give at least 3 system privileges and 3 object privileges.
-- ================================================================
--  CREATE ROLE TestRole;
--  GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO TestRole;
--  GRANT ALTER, SELECT, INSERT ON SCHEMA.Object TO TestRole;
-- ================================================================

-- Task 1:  Using Roles
-- Connect  the database as user <DBxxxx>
-- ================================================================
-- Connect to DBMS server as DB32 via SQL Developer or command line interface.
-- 1.	Revoke all object privileges on PHONELIST from the user <APPxxxx> .
   REVOKE ALL PRIVILEGES ON PHONELIST FROM APP32;
-- 2.	Create a role named R_DEVxxxx and grant the SELECT and UPDATE privileges on the PHONELIST table to the R_DEVxxxx role.
   CREATE ROLE R_DEV32;
   GRANT SELECT,UPDATE ON PHONELIST TO R_DEV32;
-- 3.	Create a role named R_MGRxxxx and grant the INSERT and DELETE privileges on the PHONELIST table to the R_MGRxxxx role.
   CREATE ROLE R_MGR32;
   GRANT INSERT,DELETE ON PHONELIST TO R_MGR32;
-- 4.	Grant the role R_DEVxxxx to the R_MGRxxxx role.
   GRANT R_DEV32 TO R_MGR32;
-- 5.	Grant the R_DEVxxxx role to user <APPxxxx> that can be passed the granted role to other users and roles. 
   GRANT R_DEV32 TO APP32 WITH ADMIN OPTION;
-- ================================================================

-- Connect the database as user <APPxxxx>
-- Note: If you do Lab 3 completely, the password of a user <APPxxxx> will be <dbms>.
-- Connect to DBMS server as APP32 via SQL Developer or command line interface.
-- ================================================================
-- 6.	Verify the granted role by checking data from data dictionary views.
   SELECT * FROM USER_ROLE_PRIVS;
   SELECT * FROM ROLE_TAB_PRIVS ORDER BY ROLE;
-- 7.	Now, Can user <APPxxxx> select all columns of DBxxxx.PHONELIST table? [Y|N]
--   Yes, it does. Because SELECT privilege has been granted to ROLE R_DEV32 which APP32 was added.
-- ================================================================

-- Connect the database as user <DBxxxx>
-- Connect to DBMS server as DB32 via SQL Developer or command line interface.
-- ================================================================
-- 8.	Revoke the R_DEVxxxx role from user <APPxxxx> and grant the R_MGRxxxx role to user <APPxxxx>.
   REVOKE R_DEV32 FROM APP32;
   GRANT R_MGR32 TO APP32;
-- ================================================================

-- Connect the database as user <APPxxxx>
-- Connect to DBMS server as APP32 via SQL Developer or command line interface.
-- ================================================================
-- 9.	Verify the granted role by checking data from data dictionary view.
   SELECT * FROM USER_ROLE_PRIVS;
   SELECT * FROM ROLE_TAB_PRIVS ORDER BY ROLE;
-- 10.	Now, Can user <APPxxxx> delete a row of DBxxxx.PHONELIST table? [Y|N]
-- Hint: If you can delete it, please rollback the deletion.
-- Yes, It does. Because INSERT and DELETE privilege has been granted to ROLE R_MGR032 which APP032 was added.
-- Execute ROLLBACK statement to rollback the deletetion which was the easiest method in this situation.
-- ================================================================

-- Connect the database as user <DBxxxx>
-- Connect to DBMS server as DB32 via SQL Developer or command line interface.
-- ================================================================
-- 11.	Revoke ONLY the UPDATE privilege from the R_DEVxxxx role.
   REVOKE UPDATE ON PHONELIST FROM R_DEV32;
-- How does this revoke effects to the user <APPxxxx>? Please verify
-- APP02 UPDATE privilege was revoked which resulted as not being able to UPDATE ON DB32.PHONELIST on later session.
-- 12.	User <DBxxxx> wants to limit the role R_DEVxxxx to update data ONLY column PHONE_NUMBER of the DBxxxx.PHONELIST table. 
   GRANT UPDATE(PHONE_NUMBER) ON PHONELIST TO R_DEV32;
-- How does user <DBxxxx> do for supporting the requirement? Please do it.
-- GRANT UPDATE privilege on column PHONE_NUMBER to ROLE R_DEV32;
-- 13.	Remove the R_MGRxxxx role
   DROP ROLE R_MGR32;
-- 14.	Verify that the role R_MGRxxxx is removed.
-- Only works with right privilege.
   SELECT * FROM DBA_ROLES
   WHERE ROLE='R_MGR32';
-- Alternative but not reliable.
-- Connect to DBMS server as APP32 or DB32 via SQL Developer or command line interface. 
   SELECT * FROM USER_ROLE_PRIVS
   WHERE GRANTED_ROLE='R_MGR32';
-- ================================================================