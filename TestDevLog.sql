-- project: DevLog
-- file: TestDevLog.sql
-- author: Martin Schabmayr
-- last change: 2020-03-21 10:00

select * from dev_log order by dlgsid desc;
select * from dev_log_val;
select * from dev_log_meta;

--delete from dev_log;

select * from DevLogValView;
select * from DevLogView;
desc DevLogView;

-- end