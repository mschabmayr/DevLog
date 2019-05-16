-- project: DevLog
-- file: create_all.sql
-- author: Martin Schabmayr
-- last change: 2019-05-16 07:00

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
