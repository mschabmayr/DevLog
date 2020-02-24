create or replace package body DevLog is
-- project: DevLog
-- file: DevLog.pkb
-- author: Martin Schabmayr
-- last change: 2020-02-21 17:00

procedure concatIfNotNull(rsText in out varchar2, psText2 in varchar2)
is
begin
  if psText2 is not null then rsText := rsText||', '||psText2; end if;
end concatIfNotNull;

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
  psText20 in varchar2 default null) return varchar2
is
  vsText varchar2(4000);
begin
  vsText := psText1;
  concatIfNotNull(vsText, psText2);
  concatIfNotNull(vsText, psText3);
  concatIfNotNull(vsText, psText4);
  concatIfNotNull(vsText, psText5);
  concatIfNotNull(vsText, psText6);
  concatIfNotNull(vsText, psText7);
  concatIfNotNull(vsText, psText8);
  concatIfNotNull(vsText, psText9);
  concatIfNotNull(vsText, psText10);
  concatIfNotNull(vsText, psText11);
  concatIfNotNull(vsText, psText12);
  concatIfNotNull(vsText, psText13);
  concatIfNotNull(vsText, psText14);
  concatIfNotNull(vsText, psText15);
  concatIfNotNull(vsText, psText16);
  concatIfNotNull(vsText, psText17);
  concatIfNotNull(vsText, psText18);
  concatIfNotNull(vsText, psText19);
  concatIfNotNull(vsText, psText20);
  return vsText;
end concatText;

procedure pl(psLine in varchar2) is begin dbms_output.put_line(psLine); end pl;

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
  psText20 in varchar2 default null)
is
begin
  dbms_output.put_line(concatText(
    psText1,
    psText2,
    psText3,
    psText4,
    psText5,
    psText6,
    psText7,
    psText8,
    psText9,
    psText10,
    psText11,
    psText12,
    psText13,
    psText14,
    psText15,
    psText16,
    psText17,
    psText18,
    psText19,
    psText20
  ));
end pl;

function toChar(pbValue in boolean) return varchar2
is
begin
  if pbValue is null then
    return 'null';
  elsif pbValue then
    return 'true';
  else
    return 'false';
  end if;
end toChar;

function thisProgram(pnDepth in integer default 1) return varchar2
is
begin
  return utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(pnDepth+1));
exception
  when others then
    return 'unknown';
end;

function thisPackage(pnDepth in integer default 1) return varchar2
is
  vsSubprogram varchar2(100);
begin
  vsSubprogram := thisProgram(pnDepth=>pnDepth+1);
  if instr(vsSubprogram,'.') <> 0 then
    return substr(vsSubprogram, 0, instr(vsSubprogram,'.')-1);
  end if;
  return vsSubprogram;
end thisPackage;

function thisFunction(pnDepth in integer default 1) return varchar2
is
  vsSubprogram varchar2(100);
begin
  vsSubprogram := thisProgram(pnDepth=>pnDepth+1);
  if instr(vsSubprogram,'.') <> 0 then
    return substr(vsSubprogram, instr(vsSubprogram,'.')+1);
  end if;
  return vsSubprogram;
end thisFunction;

function thisLine(pnDepth in integer default 1) return integer
is
begin
  return utl_call_stack.unit_line(pnDepth+1);
exception
  when others then
    return null;
end thisLine;

function callingProgram return varchar2
is
begin
  return thisProgram(pnDepth=>3);
end callingProgram;

function callingPackage return varchar2
is
begin
  return thisPackage(pnDepth=>3);
end callingPackage;

function callingFunction return varchar2
is
begin
  return thisFunction(pnDepth=>3);
end callingFunction;

function callingLine return integer
is
begin
  return thisLine(pnDepth=>3);
end callingLine;

procedure insertDevLog(rRecDevLog in out TRecDevLog)
is
begin
  rRecDevLog.dlgsid := dev_log_seq.nextval;
  insert into dev_log(dlgsid, dlgcreuser, dlgcredate,
    dlgtext1,  dlgtext2,  dlgtext3,  dlgtext4,
    dlgtext5,  dlgtext6,  dlgtext7,  dlgtext8,
    dlgtext9,  dlgtext10, dlgtext11, dlgtext12,
    dlgtext13, dlgtext14, dlgtext15, dlgtext16,
    dlgtext17, dlgtext18, dlgtext19, dlgtext20)
  values(rRecDevLog.dlgsid, user, sysdate,
    rRecDevLog.dlgtext1,  rRecDevLog.dlgtext2,  rRecDevLog.dlgtext3,  rRecDevLog.dlgtext4,
    rRecDevLog.dlgtext5,  rRecDevLog.dlgtext6,  rRecDevLog.dlgtext7,  rRecDevLog.dlgtext8,
    rRecDevLog.dlgtext9,  rRecDevLog.dlgtext10, rRecDevLog.dlgtext11, rRecDevLog.dlgtext12,
    rRecDevLog.dlgtext13, rRecDevLog.dlgtext14, rRecDevLog.dlgtext15, rRecDevLog.dlgtext16,
    rRecDevLog.dlgtext17, rRecDevLog.dlgtext18, rRecDevLog.dlgtext19, rRecDevLog.dlgtext20);
end insertDevLog;

procedure insertDevLogVal(rRecDevLogVal in out TRecDevLogVal)
is
begin
  rRecDevLogVal.dlvsid := dev_log_val_seq.nextval;
  insert into dev_log_val(dlvsid, dlvcreuser, dlvcredate,
    dlvdlgsid, dlvkey, dlvvalue)
  values(rRecDevLogVal.dlvsid, user, sysdate,
    rRecDevLogVal.dlvdlgsid, rRecDevLogVal.dlvkey, rRecDevLogVal.dlvvalue);
end insertDevLogVal;

procedure insertDevLogMeta(rRecDevLogMeta in out TRecDevLogMeta)
is
begin
  rRecDevLogMeta.dlmsid := dev_log_meta_seq.nextval;
  insert into dev_log_meta(dlmsid, dlmcreuser, dlmcredate,
    dlmdlgsid, dlmprogram, dlmprogramline, dlmcaller,
    dlmcallerline, dlmcallstack)
  values(rRecDevLogMeta.dlmsid, user, sysdate,
    rRecDevLogMeta.dlmdlgsid, rRecDevLogMeta.dlmprogram, rRecDevLogMeta.dlmprogramline, rRecDevLogMeta.dlmcaller,
    rRecDevLogMeta.dlmcallerline, rRecDevLogMeta.dlmcallstack);
end insertDevLogMeta;

procedure addValue(psLogSid in integer,
  psKey in varchar2,
  psValue in varchar2)
is
  vRecDevLogVal TRecDevLogVal;
begin
  if psValue is null then
    return;
  end if;
  vRecDevLogVal.dlvdlgsid := psLogSid;
  vRecDevLogVal.dlvkey    := psKey;
  vRecDevLogVal.dlvvalue  := psValue;
  insertDevLogVal(vRecDevLogVal);
end addValue;

procedure logGlobals(psLogSid in integer)
is
begin
  addValue(psLogSid, 'company',  MicAll.getCompany);
  addValue(psLogSid, 'plant',    MicAll.getPlant);
  addValue(psLogSid, 'language', MicAll.getSpr);
  addValue(psLogSid, 'system',   MicAll.getSystem);
  addValue(psLogSid, 'user',     MicAll.getDatabaseUser);
  addValue(psLogSid, 'country',  MicAll.getCountry);
  addValue(psLogSid, 'currency', MicAll.getCurrency);
end logGlobals;

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
  pnDepth  in number   default cnCallerDepth)
is
  pragma autonomous_transaction;
  vRecDevLog TRecDevLog;
  vRecDevLogMeta TRecDevLogMeta;
begin
  vRecDevLog.dlgtext1  := psText1;
  vRecDevLog.dlgtext2  := psText2;
  vRecDevLog.dlgtext3  := psText3;
  vRecDevLog.dlgtext4  := psText4;
  vRecDevLog.dlgtext5  := psText5;
  vRecDevLog.dlgtext6  := psText6;
  vRecDevLog.dlgtext7  := psText7;
  vRecDevLog.dlgtext8  := psText8;
  vRecDevLog.dlgtext9  := psText9;
  vRecDevLog.dlgtext10 := psText10;
  vRecDevLog.dlgtext11 := psText11;
  vRecDevLog.dlgtext12 := psText12;
  vRecDevLog.dlgtext13 := psText13;
  vRecDevLog.dlgtext14 := psText14;
  vRecDevLog.dlgtext15 := psText15;
  vRecDevLog.dlgtext16 := psText16;
  vRecDevLog.dlgtext17 := psText17;
  vRecDevLog.dlgtext18 := psText18;
  vRecDevLog.dlgtext19 := psText19; 
  vRecDevLog.dlgtext20 := psText20;
  insertDevLog(vRecDevLog);
  vRecDevLogMeta.dlmdlgsid      := vRecDevLog.dlgsid;
  vRecDevLogMeta.dlmprogram     := thisProgram(pnDepth => nvl(pnDepth+1, cnCallerDepth)); -- skip log function
  vRecDevLogMeta.dlmprogramline := thisLine(   pnDepth => nvl(pnDepth+1, cnCallerDepth));
  vRecDevLogMeta.dlmcaller      := thisProgram(pnDepth => nvl(pnDepth+2, cnCallerDepth+1));
  vRecDevLogMeta.dlmcallerline  := thisLine(   pnDepth => nvl(pnDepth+2, cnCallerDepth+1));
  vRecDevLogMeta.dlmcallstack   := dbms_utility.format_call_stack;
  insertDevLogMeta(vRecDevLogMeta);
  logGlobals(vRecDevLog.dlgsid);
  commit;
end log;

procedure hi
is
begin
  log('hi', cnCallerDepth);
end hi;

end DevLog;
/