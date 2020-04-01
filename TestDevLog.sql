-- project: DevLog
-- file: TestDevLog.sql
-- author: Martin Schabmayr
-- last change: 2020-04-01 09:00

select * from dev_log order by dlgsid desc;
select * from dev_log_val;
select * from dev_log_meta;

--delete from dev_log;

select * from DevLogValView;
select * from DevLogView;
desc DevLogView;

select dlgsid, dlvlanguage, dlvuser
  from DevLogView
 where dlgtext1 = :sText1
   and ((:sProgram is null)  or program = :sProgram)
   and ((:sCaller is null)   or caller = :sCaller)
   and ((:sSystem is null)   or dlvsystem = :sSystem)
   and ((:sCompany is null)  or dlvcompany = :sCompany)
   and ((:sPlant is null)    or dlvplant = :sPlant)
   and ((:sLanguage is null) or dlvlanguage = :sLanguage)
   and ((:sUser is null)     or dlvuser = :sUser)
;
-- end