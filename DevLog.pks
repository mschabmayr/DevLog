create or replace package DevLog authid current_user is
-- project: DevLog
-- file: DevLog.pks
-- author: Martin Schabmayr
-- last change: 2020-03-21 10:00

-- line depth = 1: this line
-- line depth = 2: calling line
cnCallerDepth constant number := 2;

type TRecDevLog is record (
  dlgsid     dev_log.dlgsid%type,
  dlgtext1   dev_log.dlgtext1%type,
  dlgtext2   dev_log.dlgtext2%type,
  dlgtext3   dev_log.dlgtext3%type,
  dlgtext4   dev_log.dlgtext4%type,
  dlgtext5   dev_log.dlgtext5%type,
  dlgtext6   dev_log.dlgtext6%type,
  dlgtext7   dev_log.dlgtext7%type,
  dlgtext8   dev_log.dlgtext8%type,
  dlgtext9   dev_log.dlgtext9%type,
  dlgtext10  dev_log.dlgtext10%type,
  dlgtext11  dev_log.dlgtext11%type,
  dlgtext12  dev_log.dlgtext12%type,
  dlgtext13  dev_log.dlgtext13%type,
  dlgtext14  dev_log.dlgtext14%type,
  dlgtext15  dev_log.dlgtext15%type,
  dlgtext16  dev_log.dlgtext16%type,
  dlgtext17  dev_log.dlgtext17%type,
  dlgtext18  dev_log.dlgtext18%type,
  dlgtext19  dev_log.dlgtext19%type,
  dlgtext20  dev_log.dlgtext20%type,
  dlgcreuser dev_log.dlgcreuser%type,
  dlgcredate dev_log.dlgcredate%type
);

type TRecDevLogVal is record (
  dlvsid     dev_log_val.dlvsid%type,
  dlvdlgsid  dev_log_val.dlvdlgsid%type,
  dlvkey     dev_log_val.dlvkey%type,
  dlvvalue   dev_log_val.dlvvalue%type,
  dlvcreuser dev_log_val.dlvcreuser%type,
  dlvcredate dev_log_val.dlvcredate%type
);

type TRecDevLogMeta is record (
  dlmsid         dev_log_meta.dlmsid%type,
  dlmdlgsid      dev_log_meta.dlmdlgsid%type,
  dlmprogram     dev_log_meta.dlmprogram%type,
  dlmprogramline dev_log_meta.dlmprogramline%type,
  dlmcaller      dev_log_meta.dlmcaller%type,
  dlmcallerline  dev_log_meta.dlmcallerline%type,
  dlmcallstack   dev_log_meta.dlmcallstack%type,
  dlmcreuser     dev_log_meta.dlmcreuser%type,
  dlmcredate     dev_log_meta.dlmcredate%type
);

procedure concatIfNotNull(rsText in out varchar2, psText2 in varchar2);

function concatText(
  psText1  in varchar2,
  psText2  in varchar2 default null,
  psText3  in varchar2 default null,
  psText4  in varchar2 default null,
  psText5  in varchar2 default null,
  psText6  in varchar2 default null,
  psText7  in varchar2 default null,
  psText8  in varchar2 default null,
  psText9  in varchar2 default null,
  psText10 in varchar2 default null,
  psText11 in varchar2 default null,
  psText12 in varchar2 default null,
  psText13 in varchar2 default null,
  psText14 in varchar2 default null,
  psText15 in varchar2 default null,
  psText16 in varchar2 default null,
  psText17 in varchar2 default null,
  psText18 in varchar2 default null,
  psText19 in varchar2 default null,
  psText20 in varchar2 default null) return varchar2;

procedure clear;

function format(psPattern in varchar2,
                psParam1  in varchar2 default null,
                psParam2  in varchar2 default null,
                psParam3  in varchar2 default null,
                psParam4  in varchar2 default null,
                psParam5  in varchar2 default null,
                psParam6  in varchar2 default null,
                psParam7  in varchar2 default null,
                psParam8  in varchar2 default null,
                psParam9  in varchar2 default null,
                psParam10 in varchar2 default null) return varchar2;

procedure pl(psLine in varchar2);

procedure pl(
  psText1  in varchar2,
  psText2  in varchar2,
  psText3  in varchar2 default null,
  psText4  in varchar2 default null,
  psText5  in varchar2 default null,
  psText6  in varchar2 default null,
  psText7  in varchar2 default null,
  psText8  in varchar2 default null,
  psText9  in varchar2 default null,
  psText10 in varchar2 default null,
  psText11 in varchar2 default null,
  psText12 in varchar2 default null,
  psText13 in varchar2 default null,
  psText14 in varchar2 default null,
  psText15 in varchar2 default null,
  psText16 in varchar2 default null,
  psText17 in varchar2 default null,
  psText18 in varchar2 default null,
  psText19 in varchar2 default null,
  psText20 in varchar2 default null);

function tc(pbValue in boolean) return varchar2;
function toChar(pbValue in boolean) return varchar2;

function thisProgram(pnDepth in integer default 1) return varchar2;
function thisPackage(pnDepth in integer default 1) return varchar2;
function thisFunction(pnDepth in integer default 1) return varchar2;
function thisLine(pnDepth in integer default 1) return integer;
function callingProgram return varchar2;
function callingPackage return varchar2;
function callingFunction return varchar2;
function callingLine return integer;

procedure log(
  psText1  in varchar2 default null,
  psText2  in varchar2 default null,
  psText3  in varchar2 default null,
  psText4  in varchar2 default null,
  psText5  in varchar2 default null,
  psText6  in varchar2 default null,
  psText7  in varchar2 default null,
  psText8  in varchar2 default null,
  psText9  in varchar2 default null,
  psText10 in varchar2 default null,
  psText11 in varchar2 default null,
  psText12 in varchar2 default null,
  psText13 in varchar2 default null,
  psText14 in varchar2 default null,
  psText15 in varchar2 default null,
  psText16 in varchar2 default null,
  psText17 in varchar2 default null,
  psText18 in varchar2 default null,
  psText19 in varchar2 default null,
  psText20 in varchar2 default null,
  pnDepth  in number   default null
);

procedure bye;
procedure ex;
procedure help;
procedure hi;
procedure mark;

end DevLog;
/
