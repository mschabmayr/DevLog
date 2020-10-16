create or replace package DevLog authid current_user is
-- project: DevLog
-- file: DevLog.pks
-- author: Martin Schabmayr

-- line depth = 1: this line
-- line depth = 2: calling line
cnProgramDepth constant number := 1;
cnCallerDepth constant number := 2;
cnNextCallerDepth constant number := 3;

csTrue constant varchar2(4) := 'true';
csFalse constant varchar2(5) := 'false';
csNull constant varchar2(4) := 'null';
csTrueFlag constant varchar2(1) := '1';
csFalseFlag constant varchar2(1) := '0';

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

type TRecDynQuery is record (
  dyqsid         dev_log_dyn_query.dyqsid%type,
  dyqname        dev_log_dyn_query.dyqname%type,
  dyqdescription dev_log_dyn_query.dyqdescription%type,
  dyqfield       dev_log_dyn_query.dyqfield%type,
  dyqactive      dev_log_dyn_query.dyqactive%type,
  dyqquery       dev_log_dyn_query.dyqquery%type,
  dyqcreuser     dev_log_dyn_query.dyqcreuser%type,
  dyqcredate     dev_log_dyn_query.dyqcredate%type,
  dyqmoduser     dev_log_dyn_query.dyqmoduser%type,
  dyqmoddate     dev_log_dyn_query.dyqmoddate%type
);

type TRecDynVar is record (
  dyvsid         dev_log_dyn_var.dyvsid%type,
  dyvname        dev_log_dyn_var.dyvname%type,
  dyvdescription dev_log_dyn_var.dyvdescription%type,
  dyvsvalue      dev_log_dyn_var.dyvsvalue%type,
  dyvnvalue      dev_log_dyn_var.dyvnvalue%type,
  dyvdvalue      dev_log_dyn_var.dyvdvalue%type,
  dyvbvalue      dev_log_dyn_var.dyvbvalue%type,
  dyvcreuser     dev_log_dyn_var.dyvcredate%type,
  dyvcredate     dev_log_dyn_var.dyvcredate%type,
  dyvmoduser     dev_log_dyn_var.dyvmoduser%type,
  dyvmoddate     dev_log_dyn_var.dyvmoddate%type
);

function countInvalidDbObjects return integer;

procedure recompileDbObjects;

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
                psParam10 in varchar2 default null,
                psParam11 in varchar2 default null,
                psParam12 in varchar2 default null,
                psParam13 in varchar2 default null,
                psParam14 in varchar2 default null,
                psParam15 in varchar2 default null,
                psParam16 in varchar2 default null,
                psParam17 in varchar2 default null,
                psParam18 in varchar2 default null,
                psParam19 in varchar2 default null,
                psParam20 in varchar2 default null) return varchar2;

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

procedure insertDevLog(rRecDevLog in out TRecDevLog);
procedure insertDevLogVal(rRecDevLogVal in out TRecDevLogVal);
procedure insertDevLogMeta(rRecDevLogMeta in out TRecDevLogMeta);

procedure addValue(psLogSid in integer,
                   psKey in varchar2,
                   psValue in varchar2);

procedure logGlobals(psLogSid in integer);

function getDynQuery(pnSid in integer) return TRecDynQuery;
function getDynQuery(psName in varchar2) return TRecDynQuery;
function insertDynQuery(rRecDynQuery in out TRecDynQuery) return TRecDynQuery;
function updateDynQuery(rRecDynQuery in out TRecDynQuery) return TRecDynQuery;

function getDynVar(pnSid in integer) return TRecDynVar;
function getDynVar(psName in varchar2) return TRecDynVar;
function insertDynVar(rRecDynVar in out TRecDynVar) return TRecDynVar;
function updateDynVar(rRecDynVar in out TRecDynVar) return TRecDynVar;

function getDynQuerySid(psName in varchar2) return integer;
function getDynVarSid(psName in varchar2) return integer;

function thisProgram(pnDepth in integer default null) return varchar2;
function thisPackage(pnDepth in integer default null) return varchar2;
function thisFunction(pnDepth in integer default null) return varchar2;
function thisLine(pnDepth in integer default null) return integer;
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
procedure ending;
procedure ex;
procedure help;
procedure hi;
procedure impossible;
procedure mark;
procedure starting;

procedure log(
  psText1  in varchar2 default null,
  psText2  in varchar2 default null,
  psText3  in varchar2 default null,
  psText4  in varchar2 default null,
  pbText5  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  psText1  in varchar2 default null,
  psText2  in varchar2 default null,
  psText3  in varchar2 default null,
  pbText4  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  psText1  in varchar2 default null,
  psText2  in varchar2 default null,
  psText3  in varchar2 default null,
  pbText4  in boolean,
  pbText5  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  psText1  in varchar2 default null,
  psText2  in varchar2 default null,
  pbText3  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  psText1  in varchar2 default null,
  psText2  in varchar2 default null,
  pbText3  in boolean,
  psText4  in varchar2 default null,
  pbText5  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  psText1  in varchar2 default null,
  psText2  in varchar2 default null,
  pbText3  in boolean,
  pbText4  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  psText1  in varchar2 default null,
  psText2  in varchar2 default null,
  pbText3  in boolean,
  pbText4  in boolean,
  pbText5  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  psText1  in varchar2 default null,
  pbText2  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  psText1  in varchar2 default null,
  pbText2  in boolean,
  psText3  in varchar2 default null,
  psText4  in varchar2 default null,
  pbText5  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  psText1  in varchar2 default null,
  pbText2  in boolean,
  psText3  in varchar2 default null,
  pbText4  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  psText1  in varchar2 default null,
  pbText2  in boolean,
  psText3  in varchar2 default null,
  pbText4  in boolean,
  pbText5  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  psText1  in varchar2 default null,
  pbText2  in boolean,
  pbText3  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  psText1  in varchar2 default null,
  pbText2  in boolean,
  pbText3  in boolean,
  psText4  in varchar2 default null,
  pbText5  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  psText1  in varchar2 default null,
  pbText2  in boolean,
  pbText3  in boolean,
  pbText4  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  psText1  in varchar2 default null,
  pbText2  in boolean,
  pbText3  in boolean,
  pbText4  in boolean,
  pbText5  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  pbText1  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  pbText1  in boolean,
  psText2  in varchar2 default null,
  psText3  in varchar2 default null,
  psText4  in varchar2 default null,
  pbText5  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  pbText1  in boolean,
  psText2  in varchar2 default null,
  psText3  in varchar2 default null,
  pbText4  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  pbText1  in boolean,
  psText2  in varchar2 default null,
  psText3  in varchar2 default null,
  pbText4  in boolean,
  pbText5  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  pbText1  in boolean,
  psText2  in varchar2 default null,
  pbText3  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  pbText1  in boolean,
  psText2  in varchar2 default null,
  pbText3  in boolean,
  psText4  in varchar2 default null,
  pbText5  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  pbText1  in boolean,
  psText2  in varchar2 default null,
  pbText3  in boolean,
  pbText4  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  pbText1  in boolean,
  psText2  in varchar2 default null,
  pbText3  in boolean,
  pbText4  in boolean,
  pbText5  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  pbText1  in boolean,
  pbText2  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  pbText1  in boolean,
  pbText2  in boolean,
  psText3  in varchar2 default null,
  psText4  in varchar2 default null,
  pbText5  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  pbText1  in boolean,
  pbText2  in boolean,
  psText3  in varchar2 default null,
  pbText4  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  pbText1  in boolean,
  pbText2  in boolean,
  psText3  in varchar2 default null,
  pbText4  in boolean,
  pbText5  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  pbText1  in boolean,
  pbText2  in boolean,
  pbText3  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  pbText1  in boolean,
  pbText2  in boolean,
  pbText3  in boolean,
  psText4  in varchar2 default null,
  pbText5  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  pbText1  in boolean,
  pbText2  in boolean,
  pbText3  in boolean,
  pbText4  in boolean,
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
  pnDepth  in number   default null);

procedure log(
  pbText1  in boolean,
  pbText2  in boolean,
  pbText3  in boolean,
  pbText4  in boolean,
  pbText5  in boolean,
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
  pnDepth  in number   default null);

end DevLog;
/
