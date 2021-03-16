-- project: DevLog
-- file: create_view_dev_log.sql
-- author: Martin Schabmayr

create or replace view DevLogValView as
  select *
    from (select dlvdlgsid, dlvkey, dlvvalue
            from dev_log_val)
   pivot (max(dlvvalue) for dlvkey in ('company' dlvcompany,
                                       'plant' dlvplant,
                                       'language' dlvlanguage,
                                       'system' dlvsystem,
                                       'user' dlvuser,
                                       'country' dlvcountry,
                                       'currency' dlvcurrency)
);

create or replace view DevLogView as
  select dlgsid,
         dev_log_meta.dlmcaller||':'||dev_log_meta.dlmcallerline caller,
         dev_log_meta.dlmprogram||':'||dev_log_meta.dlmprogramline program,
         dlgtext1, dlgtext2, dlgtext3, dlgtext4, dlgtext5,
         dlgtext6, dlgtext7, dlgtext8, dlgtext9, dlgtext10,
         dlgtext11, dlgtext12, dlgtext13, dlgtext14, dlgtext15,
         dlgtext16, dlgtext17, dlgtext18, dlgtext19, dlgtext20,
         dlvcompany, dlvplant, dlvlanguage, dlvsystem, dlvuser,
         dlvcountry, dlvcurrency,
         dlmcallstack
    from dev_log
    left outer join dev_log_meta on dlgsid = dlmdlgsid
    left outer join DevLogValView on dlgsid = dlvdlgsid
   order by dlgsid desc;
