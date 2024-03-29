-- project: DevLog
-- file: create_table_dev_log.sql
-- author: Martin Schabmayr

create table dev_log (
  dlgsid     integer not null,
  dlgtext1   varchar2(4000),
  dlgtext2   varchar2(4000),
  dlgtext3   varchar2(4000),
  dlgtext4   varchar2(4000),
  dlgtext5   varchar2(4000),
  dlgtext6   varchar2(4000),
  dlgtext7   varchar2(4000),
  dlgtext8   varchar2(4000),
  dlgtext9   varchar2(4000),
  dlgtext10  varchar2(4000),
  dlgtext11  varchar2(4000),
  dlgtext12  varchar2(4000),
  dlgtext13  varchar2(4000),
  dlgtext14  varchar2(4000),
  dlgtext15  varchar2(4000),
  dlgtext16  varchar2(4000),
  dlgtext17  varchar2(4000),
  dlgtext18  varchar2(4000),
  dlgtext19  varchar2(4000),
  dlgtext20  varchar2(4000),
  dlgcreuser varchar2(4000),
  dlgcredate date,
  dlgmoduser varchar2(4000),
  dlgmoddate date,
  constraint pk_dev_log primary key(dlgsid)
);

create sequence dev_log_seq minvalue 1 maxvalue 999999999999999999999999999 increment by 1 start with 1 cache 20 noorder nocycle;

create table dev_log_val (
  dlvsid     integer not null,
  dlvdlgsid  integer,
  dlvkey     varchar2(4000),
  dlvvalue   varchar2(4000),
  dlvcreuser varchar2(4000),
  dlvcredate date,
  dlvmoduser varchar2(4000),
  dlvmoddate date,
  constraint pk_dev_log_val primary key(dlvsid),
  constraint fk1_dev_log_val foreign key (dlvdlgsid) references dev_log
    on delete cascade
);

create sequence dev_log_val_seq minvalue 1 maxvalue 999999999999999999999999999 increment by 1 start with 1 cache 20 noorder nocycle;

create table dev_log_meta (
  dlmsid         integer not null,
  dlmdlgsid      integer,
  dlmprogram     varchar2(4000),
  dlmprogramline integer,
  dlmcaller      varchar2(4000),
  dlmcallerline  integer,
  dlmcallstack   varchar2(4000),
  dlmcreuser     varchar2(4000),
  dlmcredate     date,
  dlmmoduser     varchar2(4000),
  dlmmoddate     date,
  constraint pk_dev_log_meta primary key(dlmsid),
  constraint fk1_dev_log_meta foreign key (dlmdlgsid) references dev_log
    on delete cascade
);

create sequence dev_log_meta_seq minvalue 1 maxvalue 999999999999999999999999999 increment by 1 start with 1 cache 20 noorder nocycle;

create table dev_log_dyn_query (
  dyqsid         integer not null,
  dyqname        varchar2(4000),
  dyqdescription varchar2(4000),
  dyqfield       varchar2(4000),
  dyqactive      varchar2(1),
  dyqquery       varchar2(4000),
  dyqcreuser     varchar2(4000),
  dyqcredate     date,
  dyqmoduser     varchar2(4000),
  dyqmoddate     date,
  constraint pk_dev_log_dyn_query primary key(dyqsid)
);

create sequence dev_log_dyn_query_seq minvalue 1 maxvalue 999999999999999999999999999 increment by 1 start with 1 cache 20 noorder nocycle;

create unique index i0_dev_log_dyn_query on dev_log_dyn_query(dyqname);

create table dev_log_dyn_var (
  dyvsid         integer not null,
  dyvname        varchar2(4000),
  dyvdescription varchar2(4000),
  dyvsvalue      varchar2(4000),
  dyvnvalue      number,
  dyvdvalue      date,
  dyvbvalue      varchar2(5),
  dyvcreuser     varchar2(4000),
  dyvcredate     date,
  dyvmoduser     varchar2(4000),
  dyvmoddate     date,
  constraint pk_dev_log_dyn_var primary key(dyvsid)
);

create sequence dev_log_dyn_var_seq minvalue 1 maxvalue 999999999999999999999999999 increment by 1 start with 1 cache 20 noorder nocycle;

create unique index i0_dev_log_dyn_var on dev_log_dyn_var(dyvname);
