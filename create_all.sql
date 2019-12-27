
-- project: DevLog
-- file: create_all.sql
-- author: Martin Schabmayr
-- last change: 2019-07-08 16:30

/*
NOTE: Pull this file into sqldeveloper and execute all (hit F5)
Don't copy the statements to some other file, because the paths are relative in: start "<path>"
*/


drop package TestDevLog;
drop package DevLog;
drop view DevLogView;
drop view DevLogValView;
drop table dev_log;
drop sequence dev_log_seq;
drop table dev_log_val;
drop sequence dev_log_val_seq;
drop table dev_log_meta;
drop sequence dev_log_meta_seq;

start "create_table_dev_log.sql"
start "create_view_dev_log.sql"
start "DevLog.pks"
start "DevLog.pkb"
start "TestDevLog.pks"
start "TestDevLog.pkb"

/*
How to log messages:
DevLog.log('Text1', 'Text2', 'Text3', 'Text4', 'Text5');

How to select logs:
select * from DevLogView;
*/
