    -- Practice:  Controlling User Access
-- As Username <DBxxx>:
-- *** Please change your password from <dba> to your new password ***
-- =============================================================================
ALTER USER DB32 IDENTIFIED BY DB32; -- Subtitute ${passwd} with your own.
-- =============================================================================

-- 1.	Create a table named PhoneList with two columns: Friend_Name and Phone_Number. Set the Friend_Name column as a Primary Key.  Add two new rows into the PhoneList table with the following command:
-- =============================================================================
CREATE TABLE PhoneList (
  Friend_Name varchar2(50) CONSTRAINT PhoneList_PK_Friend_Name PRIMARY KEY,
  Phone_Number varchar2(12)
);

INSERT INTO PhoneList (Friend_Name,Phone_Number) VALUES ('Bill Gates','088-000-1144') ;
INSERT INTO PhoneList (Friend_Name,Phone_Number) VALUES ('Steve Jobs','089-123-5555') ;
INSERT INTO PhoneList (Friend_Name,Phone_Number) VALUES ('Your Name','099-888-5555') ;
COMMIT;
-- =============================================================================

-- 2.	Create a new database user named <APPxxx> with password <int207>. After created, test the new user. Connect the database as user <APPxxx>. 
-- What happens?  If an error is returned, Please resolve it
-- =============================================================================
CREATE USER APP32 IDENTIFIED BY int207;
-- Now connect to dbms server with APP032
-- (Expected) Cannot connect to the server since CREATE SESSION was not granted to APP032.
-- One of the various ways to solve the issue is executing 'GRANT CREATE SESSION TO APP032'.
GRANT CREATE SESSION TO APP32;
-- =============================================================================

-- 3.	You (as DBxxx) want the user <APPxxx> can create view in his schema. Please grant the appropriate privilege to the user. 
-- =============================================================================
GRANT CREATE VIEW TO APP32;
-- =============================================================================

-- 4.	Grant only SELECT privilege on PhoneList table to the user <APPxxxx> with pass along privilege to other users on your table.
-- =============================================================================
GRANT SELECT ON PhoneList TO APP32 WITH GRANT OPTION;
-- Is this a system or an object privilege?
-- This is an object privilege.

-- View the granted privilege on the PhoneList table from SQL Developer. See GRANTS tab, the value of GRANTEE column should be <APPxxxx>.
SELECT * FROM USER_TAB_PRIVS_MADE
WHERE upper(TABLE_NAME)='PHONELIST';
-- =============================================================================

-- 5.	Switch to connect the database as username <APPxxxx>:
-- =============================================================================
-- Switch to APP032 via SQL Developer or command line interface;
-- 5.1)	Write a command to view all system privileges are granted to the <APPxxxx> user.
   SELECT * FROM USER_SYS_PRIVS;
-- 5.2)	Write a command to change password from <int207> to new password <dbms>.
   ALTER USER APP32 IDENTIFIED BY dbms;
-- 5.3)	Write and execute a command to retrieve the rows with Phone_Number ending with 5 from the PhoneList table of <DBxxxx> schema.
   SELECT * FROM DB32.PhoneList 
   WHERE Phone_Number LIKE '%5';
-- Can the user <APPxxxx> select data from the table? [Y | N]
-- YES it does.
-- Why?
--   SELECT privilege was granted for APP032 on DB032.PhoneList. 
-- 5.4)	Write a command to insert a new record with Mark Zuckerberg as friend’s name and 087-080-9898 as phone number into the PhoneList table of <DBxxxx> schema.
   INSERT INTO DB32.PhoneList(Friend_Name,Phone_Number) VALUES('Mark Zuckerberg','087-080-9898');
-- Can you insert the new record into the PhoneList table of <DBxxxx> schema?
-- No, INSERT privilege has never been granted for APP032 on DB032.PhoneList.
-- 5.5)	Write a command to delete the row with the friend name of Bill Gates from the PhoneList table of <DBxxxx> schema.
   DELETE FROM DB32.PhoneList
   WHERE Friend_Name='Bill Gates';
-- Can the user <APPxxxx> delete data from the table of DBxxxx? [Y | N]
-- NO it does not.
-- Why?
-- DELETE privilege has never been granted for APP032 on DB032.PhoneList.
-- 5.6)	In order to complete the tasks in 5.4 and 5.5.  What would you do? Write your commands:
-- Connect to DBMS server with the user holds right privileges for the tasks.
-- Execute this SQL statement.
   GRANT INSERT, DELETE ON DB32.PhoneList TO APP32;
-- 5.7)	Write a command to grant the SELECT privilege on the <DBxxxx>.PhoneList table to another friend.
   GRANT SELECT ON DB32.PhoneList TO APP130 -- Subtitute user with your own.
-- Can the user <APPxxxx> grant the privilege to another user? [Y | N]
-- Yes it does.
-- Why?
-- 'WITH GRANT OPTION' was emitted at the time of promoting APP032.
-- =============================================================================

-- 6.	Switch to connect the database as an original username <DBxxxx>.
-- =============================================================================
-- Connect to DBMS server via SQL Developer or command line interface.
-- 6.1)	Write a command to revoke the SELECT privilege on the PhoneList table from the <APPxxxx> user. 
   REVOKE SELECT ON PhoneList FROM APP32;
-- OR REVOKE SELECT from DB032 or its grantor.
-- 6.2)	After that, the SELECT privilege is revoked from <APPxxx> user. How about another friend that was granted by <APPxxx> (in question 5.7). 
-- Can another friend still select data from <DBxxxx>. PhoneList  table? [Y | N]
-- No, SELECT privilege was revoked from the grantor so does the grantee.
-- 6.3)	Create a new table named Users with five columns: ID, Fname, Lname, Username and PWD. Please set the constraint(s) that appropriate to the Users table. Add one row into the Users table (data created by your own) and then issue the COMMIT command.
   CREATE TABLE Users(
     ID NUMBER(6) CONSTRAINT Users_PK_ID PRIMARY KEY,
     Fname VARCHAR2(50),
     Lname VARCHAR2(50),
     USERNAME VARCHAR2(50) CONSTRAINT Users_NN_USERNAME NOT NULL,
     PWD VARCHAR2(50) CONSTRAINT Users_NN_PWD NOT NULL,
     CONSTRAINT Users_UNIQUE_USERNAME UNIQUE(USERNAME)
   );
   INSERT INTO Users(ID,Fname,Lname,USERNAME,PWD) VALUES(1,'Who?','?ohW','username','passwd');
   COMMIT;
-- What do you think about the security on the Users table?
-- The risk of exposing user credentials is high because password has been storing as a plain text (just like RockYou).
-- =============================================================================
