-- INT207 Lab 6
-- Transactions management
-- 1.	Create tables that keep track of an inventory of parts of a Doll and an assembled doll.
-- (use the user dbxxx)
-- Connect to DBMS server as DB32 via SQL DEVELOPER or command line interface.
-- ===========================================================================
   drop table Dolls;
   drop table DollParts;
   
   create table Dolls (
   name	varchar2(20) primary key,
   cnt	number
   );
   create table DollParts (
   name	varchar2(10) primary key,
   cnt number check (cnt >= 0),
   doll varchar2(20) references Dolls
   );

   insert into Dolls(name, cnt) values('Barbie', 0);
   insert into Dolls(name, cnt) values('Ken', 0);
   insert into DollParts(name, cnt) values('HEAD', 17);
   insert into DollParts(name, cnt) values('BODY', 17);
   insert into DollParts(name, cnt) values('ARM', 17);
   insert into DollParts(name, cnt) values('LEG', 17);
   commit;
-- ===========================================================================

-- 2.	Grant privilege to user Appxxx to allow select and update operation on both tables in 1.
-- ==========================================================================
   SELECT * FROM USER_SYS_PRIVS;
   GRANT SELECT, UPDATE ON Dolls TO APP32;
   GRANT SELECT, UPDATE ON DollParts TO APP32;

-- ==========================================================================
-- 3.	The transaction in which we are interested is to deduct from the inventory (DollParts) those parts that we need to make a doll and increment the count of that doll by 1.  The problem that we may get into is this: what if two users are doing this at the same time?
-- Now run the following SQL statements in the dbxxx and Appxxx windows accordingly
-- ==========================================================================
/* 
dbxxx:  select * from Dbxxx.DollParts; -- Use shared lock.
Appxxx:  select * from Dbxxx.DollParts; -- Use shared lock.
dbxxx:  update Dbxxx.DollParts set cnt=cnt-1 where name='HEAD'; -- Use exclusive lock. 
dbxxx:  update Dbxxx.DollParts set cnt=cnt-1 where name='BODY'; -- Use exclusive lock.
Appxxx:  select * from Dbxxx.DollParts; -- Got original data (Not yet committed).
dbxxx:  select * from Dbxxx.DollParts; -- Got new data (Same session).
dbxxx:  commit; -- Locks/Resources holds by the transactions released.
Appxxx:  select * from Dbxxx.DollParts; -- Got new data (Committed).
*/
select * from db32.DollParts; -- dbxxx:
select * from db32.DollParts; -- Appxxx:
update db32.DollParts set cnt=cnt-1 where name='HEAD'; -- dbxxx:   
update db32.DollParts set cnt=cnt-1 where name='BODY'; -- dbxxx:
select * from db32.DollParts; -- Appxxx:
select * from db32.DollParts; -- dbxxx:
commit; -- dbxxx:
select * from db32.DollParts; -- Appxxx:
-- 3.1 What are the ‘HEAD’ count and ‘BODY’ count from the second Appxxx query?
-- Both 'HEAD' AND 'BODY' has a CNT of value 17.
-- 3.2 What are the ‘HEAD’ count and ‘BODY’ count from the second dbxxx query?
-- Both 'HEAD' AND 'BODY' has a CNT of value 16.
-- 3.3 What are the ‘HEAD’ count and ‘BODY’ count from the third Appxxx query?
-- Both 'HEAD' AND 'BODY' has a CNT of value 16.
-- ==========================================================================

-- 4.	Run the following SQL statements in dbxxx and Appxxx accordingly.  Note that Appxxx will hang after the update statement.  See explanations below when it happens.
-- ==========================================================================
/*
dbxxx:  Update Dbxxx.DollParts set cnt=cnt-1 where name='HEAD'; -- Use exclusive lock.
dbxxx:  Update Dbxxx.DollParts set cnt=cnt-1 where name='BODY'; -- Use exclusive lock.
dbxxx:  Select * from Dbxxx.DollParts; -- Holding exclusive lock by previous statements.
Appxxx: Update Dbxxx.DollParts set cnt=cnt-1 where name='HEAD'; -- Wait for the lock on transaction1 to be released. There is a deadlock countermeasure.
*/
-- The above statements reflect a situation when two doll-builds start at the same time.
-- 4.1 What happen with user Appxxx?
-- Waiting for exclusive lock to be released on transaction started by DB32.
-- Notice that Appxxx has hung on its update statement.
-- 4.2 Why the situation in 4.1 happen ?
-- Transaction started by DB02 is holding exclusive lock which dominate both read and write accesses solely.
-- Appxxx will be suspended until dbxxx commits, at which point the LDW is released by dbxxx.
-- Now run the following statements in dbxxx to finish the transaction:
/*
dbxxx:  Update Dbxxx.DollParts set cnt=cnt-2 where name='ARM';
dbxxx:  Update Dbxxx.DollParts set cnt=cnt-2 where name='LEG';
dbxxx:  commit;
*/
-- Now complete the transaction in Appxxx by using commit.  Note that you can finish Appxxx successfully now.  
-- Connect to DBMS server as APP32 via SQL Developer or command line interface.
-- Execucute COMMIT statement which changes will be flushed to the database.
-- Appxxx:  commit;
-- ==========================================================================

-- 5.	Run the following statements in dbxxx and Appxxx accordingly:
/*
dbxxx:  select * from Dbxxx.Dolls where name='Barbie' for update;
Appxxx:  select cnt from Dbxxx.Dolls where name='Barbie';
Appxxx:  update Dbxxx.Dolls set cnt=cnt+1 where name='Barbie';
*/

-- 5.1 What happen with user Appxxx
-- Appxxx has hung.  
-- APP032 still being a user but its transaction is waiting for the exclusive lock holding by the transaction started by DB32 to be released.
-- 5.2 Why the situation in 5.1 happen ?
-- Exclusive lock was held by the transaction started by DB32.
-- Now finish the transactions in dbxxx and Appxxx:
-- Execute COMMIT statement on DB32's transaction to flush changes to the database and moving to new consistent state.
-- Execute COMMIT statement on APP32's transaction to flush changes to the database and moving to new consistent state.
-- Notice that APP32's transaction has been able to update because the exclusive lock was released on DB32's transaction and held to APP32's transaction then release on executing COMMIT statement.
-- dbxxx: commit;
-- Appxxx: commit;
