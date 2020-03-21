-- project: DevLog
-- file: TestDevLog.sql
-- author: Martin Schabmayr
-- last change: 2019-05-16 07:00

select * from dev_log order by dlgsid desc;
select * from dev_log_val;
select * from dev_log_meta;

select * from DevLogValView;
select * from DevLogView;
desc DevLogView;

-- end