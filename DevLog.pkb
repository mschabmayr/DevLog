create or replace package body DevLog is
-- project: DevLog
-- file: DevLog.pkb
-- author: Martin Schabmayr

-- TODO: rework package structure

function countInvalidDbObjects return integer
is
begin
  return getInvalidDbObjects().count;
end countInvalidDbObjects;

function getInvalidDbObjects return TTabDbObjects
is
  vTabDbObjects TTabDbObjects;
begin
  if curInvalidDbObjects%isopen then
    close curInvalidDbObjects;
  end if;

  open curInvalidDbObjects;
  fetch curInvalidDbObjects bulk collect into vTabDbObjects;
  close curInvalidDbObjects;
  return vTabDbObjects;
end getInvalidDbObjects;

function getCompileStatements return TTabStrings
is
  vTabStatements TTabStrings := TTabStrings();
begin
  for rowInvalidDbObject in curInvalidDbObjects loop
    vTabStatements.extend;
    vTabStatements(vTabStatements.count) := rowInvalidDbObject.compile_statement;
  end loop;
  return vTabStatements;
end getCompileStatements;

procedure recompileDbObjects
is
  vTabStatements TTabStrings;
  vnInvalidCount number;
  vnTryCount number := 3;
begin
  pl('start of recompileDbObjects');
  vTabStatements := getCompileStatements();
  vnInvalidCount := vTabStatements.count;
  pl('invalid count: '||vnInvalidCount);
  while vnInvalidCount > 0 and vnTryCount > 0 loop
    for i in 1..vTabStatements.count loop
      pl('recompiling '||i||'/'||vTabStatements.count||' '||vTabStatements(i));
      begin
        execute immediate vTabStatements(i);
      exception
        when others then
          -- catch ORA-24344: success with compilation error
          pl('exception caught: '||sqlerrm);
      end;
    end loop;
    vTabStatements := getCompileStatements();
    if vTabStatements.count = vnInvalidCount then
      vnTryCount := vnTryCount - 1;
      pl('remaining invalid: '||vnInvalidCount||', remaining tries: '||vnTryCount);
    end if;
    vnInvalidCount := vTabStatements.count;
  end loop;
  pl('end of compilation');
  for i in 1..vTabStatements.count loop
    pl(vTabStatements(i));
  end loop;
  pl(vTabStatements.count||' remaining invalid');
  pl('end of recompileDbObjects');
end;

procedure setCompileCount(pnCount in integer default 3)
is
  csTryCountPrefix constant varchar2(4) := 'TRY_';
begin
  update dev_log_dyn_var
     set dyvnvalue = pnCount,
         dyvmoduser = user,
         dyvmoddate = sysdate
   where dyvname like csTryCountPrefix||'%';
end setCompileCount;

procedure resetCompileCount
is
  csTryCountPrefix constant varchar2(4) := 'TRY_';
begin
  delete
    from dev_log_dyn_var
   where dyvname like csTryCountPrefix||'%';
end resetCompileCount;

procedure recompileAndLogDbObjects
is
  csTryCountPrefix constant varchar2(4) := 'TRY_';
  cnTryCount constant number := 3;
  vTabDbObjects TTabDbObjects;
  vTypeDbObject TTypeDbObject;
  vRecDynVar TRecDynVar;
  vsTryCountKey TString;
begin
  vTabDbObjects := getInvalidDbObjects();
  for i in 1 .. vTabDbObjects.count loop
    vTypeDbObject := vTabDbObjects(i);
    vsTryCountKey := csTryCountPrefix||vTypeDbObject.object_name
      ||'_'||vTypeDbObject.object_type;
    vRecDynVar := getDynVar(vsTryCountKey);
    if vRecDynVar.dyvsid is null then
      vRecDynVar.dyvname := vsTryCountKey;
      vRecDynVar.dyvnvalue := cnTryCount;
      insertDynVar(vRecDynVar);
    end if;
    --pl('invalid: '||vTabDbObjects.count
    --    ||' - compiling: '||vTypeDbObject.compile_statement);
    --pl('number of tries: '||vRecDynVar.dyvnvalue);
    if vRecDynVar.dyvnvalue > 0 then
      pl('invalid: '||vTabDbObjects.count
        ||' - compiling: '||vTypeDbObject.compile_statement);

      begin
        execute immediate vTypeDbObject.compile_statement;
      exception
        when others then
          pl('exception caught: '||sqlerrm);
      end;

      vRecDynVar.dyvnvalue := vRecDynVar.dyvnvalue - 1;
      updateDynVar(vRecDynVar);
      exit;
    end if;
  end loop;
end recompileAndLogDbObjects;

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

procedure clearLog
is
begin
  delete from dev_log_meta;
  delete from dev_log_val;
  delete from dev_log;
end clearLog;

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
                psParam20 in varchar2 default null) return varchar2
is
begin
  return utl_lms.format_message(psPattern,
    psParam1,
    psParam2,
    psParam3,
    psParam4,
    psParam5,
    psParam6,
    psParam7,
    psParam8,
    psParam9,
    psParam10,
    psParam11,
    psParam12,
    psParam13,
    psParam14,
    psParam15,
    psParam16,
    psParam17,
    psParam18,
    psParam19,
    psParam20);
end format;

procedure pl(psLine in varchar2)
is
begin
  dbms_output.put_line(psLine);
end pl;

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

function tc(pbValue in boolean) return varchar2
is
begin
  return toChar(pbValue);
end tc;

function toChar(pbValue in boolean) return varchar2
is
  vsValue varchar2(5) := 'false';
begin
  if pbValue is null then
    vsValue := 'null';
  elsif pbValue then
    vsValue := 'true';
  end if;
  return vsValue;
end toChar;

function thisProgram(pnDepth in integer default null) return varchar2
is
begin
  return utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(nvl(pnDepth, cnProgramDepth)+1));
exception
  when others then
    return 'unknown';
end;

function thisPackage(pnDepth in integer default null) return varchar2
is
  vsSubprogram varchar2(100);
begin
  vsSubprogram := thisProgram(pnDepth=>nvl(pnDepth, cnProgramDepth)+1);
  if instr(vsSubprogram,'.') <> 0 then
    return substr(vsSubprogram, 0, instr(vsSubprogram,'.')-1);
  end if;
  return vsSubprogram;
end thisPackage;

function thisFunction(pnDepth in integer default null) return varchar2
is
  vsSubprogram varchar2(100);
begin
  vsSubprogram := thisProgram(pnDepth=>nvl(pnDepth, cnProgramDepth)+1);
  if instr(vsSubprogram,'.') <> 0 then
    return substr(vsSubprogram, instr(vsSubprogram,'.')+1);
  end if;
  return vsSubprogram;
end thisFunction;

function thisLine(pnDepth in integer default null) return integer
is
begin
  return utl_call_stack.unit_line(nvl(pnDepth, cnProgramDepth)+1);
exception
  when others then
    return null;
end thisLine;

function callingProgram return varchar2
is
begin
  return thisProgram(pnDepth=>cnNextCallerDepth);
end callingProgram;

function callingPackage return varchar2
is
begin
  return thisPackage(pnDepth=>cnNextCallerDepth);
end callingPackage;

function callingFunction return varchar2
is
begin
  return thisFunction(pnDepth=>cnNextCallerDepth);
end callingFunction;

function callingLine return integer
is
begin
  return thisLine(pnDepth=>cnNextCallerDepth);
end callingLine;

procedure insertDevLog(rRecDevLog in out TRecDevLog)
is
begin
  rRecDevLog.dlgsid := dev_log_seq.nextval;
  rRecDevLog.dlgcreuser := user;
  rRecDevLog.dlgcredate := sysdate;

  insert into dev_log(dlgsid,
    dlgcreuser, dlgcredate,
    dlgmoduser, dlgmoddate,
    dlgtext1,   dlgtext2,   dlgtext3,  dlgtext4,
    dlgtext5,   dlgtext6,   dlgtext7,  dlgtext8,
    dlgtext9,   dlgtext10,  dlgtext11, dlgtext12,
    dlgtext13,  dlgtext14,  dlgtext15, dlgtext16,
    dlgtext17,  dlgtext18,  dlgtext19, dlgtext20)
  values(rRecDevLog.dlgsid,
    rRecDevLog.dlgcreuser, rRecDevLog.dlgcredate,
    rRecDevLog.dlgmoduser, rRecDevLog.dlgmoddate,
    rRecDevLog.dlgtext1,   rRecDevLog.dlgtext2,   rRecDevLog.dlgtext3,  rRecDevLog.dlgtext4,
    rRecDevLog.dlgtext5,   rRecDevLog.dlgtext6,   rRecDevLog.dlgtext7,  rRecDevLog.dlgtext8,
    rRecDevLog.dlgtext9,   rRecDevLog.dlgtext10,  rRecDevLog.dlgtext11, rRecDevLog.dlgtext12,
    rRecDevLog.dlgtext13,  rRecDevLog.dlgtext14,  rRecDevLog.dlgtext15, rRecDevLog.dlgtext16,
    rRecDevLog.dlgtext17,  rRecDevLog.dlgtext18,  rRecDevLog.dlgtext19, rRecDevLog.dlgtext20);
end insertDevLog;

function getDevLog(pnSid in integer) return TRecDevLog
is
  cursor curGet(nSid integer) is
    select dlgsid,
           dlgcreuser, dlgcredate,
           dlgmoduser, dlgmoddate,
           dlgtext1,   dlgtext2,   dlgtext3,  dlgtext4,
           dlgtext5,   dlgtext6,   dlgtext7,  dlgtext8,
           dlgtext9,   dlgtext10,  dlgtext11, dlgtext12,
           dlgtext13,  dlgtext14,  dlgtext15, dlgtext16,
           dlgtext17,  dlgtext18,  dlgtext19, dlgtext20
      from dev_log
     where dlgsid = nSid;
  vRecDevLog TRecDevLog;
begin
  open curGet(pnSid);
  fetch curGet into vRecDevLog;
  close curGet;
  return vRecDevLog;
end getDevLog;

procedure updateDevLog(rRecDevLog in out TRecDevLog)
is
begin
  rRecDevLog.dlgmoduser := user;
  rRecDevLog.dlgmoddate := sysdate;

  update dev_log set (
      dlgcreuser, dlgcredate,
      dlgmoduser, dlgmoddate,
      dlgtext1,   dlgtext2,   dlgtext3,  dlgtext4,
      dlgtext5,   dlgtext6,   dlgtext7,  dlgtext8,
      dlgtext9,   dlgtext10,  dlgtext11, dlgtext12,
      dlgtext13,  dlgtext14,  dlgtext15, dlgtext16,
      dlgtext17,  dlgtext18,  dlgtext19, dlgtext20
  ) = (
    select
      rRecDevLog.dlgcreuser, rRecDevLog.dlgcredate,
      rRecDevLog.dlgmoduser, rRecDevLog.dlgmoddate,
      rRecDevLog.dlgtext1,   rRecDevLog.dlgtext2,   rRecDevLog.dlgtext3,  rRecDevLog.dlgtext4,
      rRecDevLog.dlgtext5,   rRecDevLog.dlgtext6,   rRecDevLog.dlgtext7,  rRecDevLog.dlgtext8,
      rRecDevLog.dlgtext9,   rRecDevLog.dlgtext10,  rRecDevLog.dlgtext11, rRecDevLog.dlgtext12,
      rRecDevLog.dlgtext13,  rRecDevLog.dlgtext14,  rRecDevLog.dlgtext15, rRecDevLog.dlgtext16,
      rRecDevLog.dlgtext17,  rRecDevLog.dlgtext18,  rRecDevLog.dlgtext19, rRecDevLog.dlgtext20
    from dual
  )
  where dlgsid = rRecDevLog.dlgsid;
end updateDevLog;

procedure insertDevLogVal(rRecDevLogVal in out TRecDevLogVal)
is
begin
  rRecDevLogVal.dlvsid := dev_log_val_seq.nextval;
  rRecDevLogVal.dlvcreuser := user;
  rRecDevLogVal.dlvcredate := sysdate;

  insert into dev_log_val(dlvsid,
    dlvcreuser, dlvcredate,
    dlvmoduser, dlvmoddate,
    dlvdlgsid,  dlvkey,     dlvvalue)
  values(rRecDevLogVal.dlvsid,
    rRecDevLogVal.dlvcreuser, rRecDevLogVal.dlvcredate,
    rRecDevLogVal.dlvmoduser, rRecDevLogVal.dlvmoddate,
    rRecDevLogVal.dlvdlgsid,  rRecDevLogVal.dlvkey,     rRecDevLogVal.dlvvalue);
end insertDevLogVal;

procedure insertDevLogMeta(rRecDevLogMeta in out TRecDevLogMeta)
is
begin
  rRecDevLogMeta.dlmsid := dev_log_meta_seq.nextval;
  rRecDevLogMeta.dlmcreuser := user;
  rRecDevLogMeta.dlmcredate := sysdate;

  insert into dev_log_meta(dlmsid,
    dlmcreuser, dlmcredate,
    dlmmoduser, dlmmoddate,
    dlmdlgsid,  dlmprogram,    dlmprogramline,
    dlmcaller,  dlmcallerline, dlmcallstack)
  values(rRecDevLogMeta.dlmsid,
    rRecDevLogMeta.dlmcreuser, rRecDevLogMeta.dlmcredate,
    rRecDevLogMeta.dlmmoduser, rRecDevLogMeta.dlmmoddate,
    rRecDevLogMeta.dlmdlgsid,  rRecDevLogMeta.dlmprogram,    rRecDevLogMeta.dlmprogramline,
    rRecDevLogMeta.dlmcaller,  rRecDevLogMeta.dlmcallerline, rRecDevLogMeta.dlmcallstack);
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
begin /*
  addValue(psLogSid, 'company',  MicAll.getCompany());
  addValue(psLogSid, 'plant',    MicAll.getPlant());
  addValue(psLogSid, 'language', MicAll.getSpr());
  addValue(psLogSid, 'system',   MicAll.getSystem());
  addValue(psLogSid, 'user',     MicAll.getDatabaseUser());
  addValue(psLogSid, 'country',  MicAll.getCountry());
  addValue(psLogSid, 'currency', MicAll.getCurrency()); */
  null;
end logGlobals;

procedure assignDynVars(rsQuery in out varchar2)
is
  csDynVarPattern constant varchar2(5) := '<.*?>';
  vRecDynVar TRecDynVar;
  vsDynVarName TString;
  vsReplacement TString;
begin
  -- get dyn var from pos. 1 and 1st occurence
  vsDynVarName := regexp_substr(rsQuery, csDynVarPattern, 1, 1);
  while vsDynVarName is not null loop
    -- cut enclosing brackets
    vRecDynVar := getDynVar(substr(vsDynVarName, 2, length(vsDynVarName) - 2));
    if vRecDynVar.dyvsid is null then -- not found
      vsReplacement := ''''||'DynVarNotFound'||'''';
    else
      if vRecDynVar.dyvsvalue is not null then
        vsReplacement := ''''||vRecDynVar.dyvsvalue||'''';
      elsif vRecDynVar.dyvnvalue is not null then
        vsReplacement := to_char(vRecDynVar.dyvnvalue);
      elsif vRecDynVar.dyvdvalue is not null then
        vsReplacement := ''''||vRecDynVar.dyvdvalue||''''; -- implicit to_char
      elsif vRecDynVar.dyvbvalue is not null then
        vsReplacement := vRecDynVar.dyvbvalue;
      end if;
    end if;

    rsQuery := replace(rsQuery, vsDynVarName, vsReplacement);
    vsDynVarName := regexp_substr(rsQuery, csDynVarPattern, 1, 1);
  end loop;
end assignDynVars;

procedure assignText(psField in varchar2,
                     psValue  in varchar2,
                     rRecDevLog in out TRecDevLog)
is
  vsField TString;
begin
  vsField := lower(psField);
  if vsField like '%text1' then
    rRecDevLog.dlgtext1 := psValue;
  elsif vsField like '%text2' then
    rRecDevLog.dlgtext2 := psValue;
  elsif vsField like '%text3' then
    rRecDevLog.dlgtext3 := psValue;
  elsif vsField like '%text4' then
    rRecDevLog.dlgtext4 := psValue;
  elsif vsField like '%text5' then
    rRecDevLog.dlgtext5 := psValue;
  elsif vsField like '%text6' then
    rRecDevLog.dlgtext6 := psValue;
  elsif vsField like '%text7' then
    rRecDevLog.dlgtext7 := psValue;
  elsif vsField like '%text8' then
    rRecDevLog.dlgtext8 := psValue;
  elsif vsField like '%text9' then
    rRecDevLog.dlgtext9 := psValue;
  elsif vsField like '%text10' then
    rRecDevLog.dlgtext10 := psValue;
  elsif vsField like '%text11' then
    rRecDevLog.dlgtext11 := psValue;
  elsif vsField like '%text12' then
    rRecDevLog.dlgtext12 := psValue;
  elsif vsField like '%text13' then
    rRecDevLog.dlgtext13 := psValue;
  elsif vsField like '%text14' then
    rRecDevLog.dlgtext14 := psValue;
  elsif vsField like '%text15' then
    rRecDevLog.dlgtext15 := psValue;
  elsif vsField like '%text16' then
    rRecDevLog.dlgtext16 := psValue;
  elsif vsField like '%text17' then
    rRecDevLog.dlgtext17 := psValue;
  elsif vsField like '%text18' then
    rRecDevLog.dlgtext18 := psValue;
  elsif vsField like '%text19' then
    rRecDevLog.dlgtext19 := psValue;
  elsif vsField like '%text20' then
    rRecDevLog.dlgtext20 := psValue;
  end if;
end assignText;

procedure logDynVars(pnLogSid in integer)
is
  cursor curActiveDynQueries is
    select dyqsid
      from dev_log_dyn_query
     where dyqactive = csTrueFlag
       and dyqquery is not null
       and dyqfield is not null
     order by dyqname;
  vRecDevLog TRecDevLog;
  vRecDynQuery TRecDynQuery;
  vsQuery TString;
  vsQueryResult TString;
begin
  for rowActiveDynQuery in curActiveDynQueries() loop
    vRecDynQuery := getDynQuery(rowActiveDynQuery.dyqsid);
    vsQuery := vRecDynQuery.dyqquery;
    assignDynVars(vsQuery);

    begin
      execute immediate 'begin :result := '||vsQuery||'; end;'
        using out vsQueryResult;
    exception
      when others then
        vsQueryResult := 'Error: '||sqlerrm
          ||' Query: '||vsQuery;
    end;

    vRecDevLog := getDevLog(pnLogSid);
    assignText(psField => vRecDynQuery.dyqfield,
               psValue => vsQueryResult,
               rRecDevLog => vRecDevLog);
    updateDevLog(vRecDevLog);
  end loop;
end logDynVars;

function getDynQuery(pnSid in integer) return TRecDynQuery
is
  cursor curGet(nSid integer) is
    select dyqsid,
           dyqcreuser, dyqcredate,
           dyqmoduser, dyqmoddate,
           dyqname,    dyqdescription, dyqfield,
           dyqactive,  dyqquery
      from dev_log_dyn_query
     where dyqsid = nSid;
  vRecDynQuery TRecDynQuery;
begin
  open curGet(pnSid);
  fetch curGet into vRecDynQuery;
  close curGet;
  return vRecDynQuery;
end getDynQuery;

function getDynQuery(psName in varchar2) return TRecDynQuery
is
  cursor curSid(sName integer) is
    select dyqsid
      from dev_log_dyn_query
     where dyqname = sName;
  rowSid curSid%rowtype;
begin
  open curSid(psName);
  fetch curSid into rowSid;
  close curSid;
  return getDynQuery(rowSid.dyqsid);
end getDynQuery;

procedure insertDynQuery(rRecDynQuery in out TRecDynQuery)
is
begin
  rRecDynQuery.dyqsid := dev_log_dyn_query_seq.nextval;
  rRecDynQuery.dyqcreuser := user;
  rRecDynQuery.dyqcredate := sysdate;

  insert into dev_log_dyn_query(dyqsid,
    dyqcreuser, dyqcredate,
    dyqmoduser, dyqmoddate,
    dyqname,    dyqdescription, dyqfield,
    dyqactive,  dyqquery)
  values(rRecDynQuery.dyqsid,
    rRecDynQuery.dyqcreuser, rRecDynQuery.dyqcredate,
    rRecDynQuery.dyqmoduser, rRecDynQuery.dyqmoddate,
    rRecDynQuery.dyqname,    rRecDynQuery.dyqdescription, rRecDynQuery.dyqfield,
    rRecDynQuery.dyqactive,  rRecDynQuery.dyqquery);
end insertDynQuery;

procedure updateDynQuery(rRecDynQuery in out TRecDynQuery)
is
begin
  rRecDynQuery.dyqmoduser := user;
  rRecDynQuery.dyqmoddate := sysdate;

  update dev_log_dyn_query set (
    dyqcreuser, dyqcredate,
    dyqmoduser, dyqmoddate,
    dyqname,    dyqdescription, dyqfield,
    dyqactive,  dyqquery
  ) = (
    select
      rRecDynQuery.dyqcreuser, rRecDynQuery.dyqcredate,
      rRecDynQuery.dyqmoduser, rRecDynQuery.dyqmoddate,
      rRecDynQuery.dyqname,    rRecDynQuery.dyqdescription, rRecDynQuery.dyqfield,
      rRecDynQuery.dyqactive,  rRecDynQuery.dyqquery
    from dual
  )
  where dyqsid = rRecDynQuery.dyqsid;
end updateDynQuery;

function getDynVar(pnSid in integer) return TRecDynVar
is
  cursor curGet(nSid integer) is
    select dyvsid,
           dyvcreuser, dyvcredate,
           dyvmoduser, dyvmoddate,
           dyvname,    dyvdescription, dyvsvalue,
           dyvnvalue,  dyvdvalue,  dyvbvalue
      from dev_log_dyn_var
     where dyvsid = nSid;
  vRecDynVar TRecDynVar;
begin
  open curGet(pnSid);
  fetch curGet into vRecDynVar;
  close curGet;
  return vRecDynVar;
end getDynVar;

function getDynVar(psName in varchar2) return TRecDynVar
is
  cursor curSid(sName varchar2) is
    select dyvsid
      from dev_log_dyn_var
     where dyvname = sName;
  rowSid curSid%rowtype;
begin
  open curSid(psName);
  fetch curSid into rowSid;
  close curSid;
  return getDynVar(rowSid.dyvsid);
end getDynVar;

procedure insertDynVar(rRecDynVar in out TRecDynVar)
is
begin
  rRecDynVar.dyvsid := dev_log_dyn_var_seq.nextval;
  rRecDynVar.dyvcreuser := user;
  rRecDynVar.dyvcredate := sysdate;

  insert into dev_log_dyn_var(dyvsid,
    dyvcreuser, dyvcredate,
    dyvmoduser, dyvmoddate,
    dyvname,    dyvdescription, dyvsvalue,
    dyvnvalue,  dyvdvalue,      dyvbvalue)
  values(rRecDynVar.dyvsid,
    rRecDynVar.dyvcreuser, rRecDynVar.dyvcredate,
    rRecDynVar.dyvmoduser, rRecDynVar.dyvmoddate,
    rRecDynVar.dyvname,    rRecDynVar.dyvdescription, rRecDynVar.dyvsvalue,
    rRecDynVar.dyvnvalue,  rRecDynVar.dyvdvalue,      rRecDynVar.dyvbvalue);
end insertDynVar;

procedure updateDynVar(rRecDynVar in out TRecDynVar)
is
begin
  rRecDynVar.dyvmoduser := user;
  rRecDynVar.dyvmoddate := sysdate;

  update dev_log_dyn_var set (
    dyvcreuser, dyvcredate,
    dyvmoduser, dyvmoddate,
    dyvname,    dyvdescription, dyvsvalue,
    dyvnvalue,  dyvdvalue,      dyvbvalue
  ) = (
    select
      rRecDynVar.dyvcreuser, rRecDynVar.dyvcredate,
      rRecDynVar.dyvmoduser, rRecDynVar.dyvmoddate,
      rRecDynVar.dyvname,    rRecDynVar.dyvdescription, rRecDynVar.dyvsvalue,
      rRecDynVar.dyvnvalue,  rRecDynVar.dyvdvalue,      rRecDynVar.dyvbvalue
    from dual
  )
  where dyvsid = rRecDynVar.dyvsid;
end updateDynVar;

function getDynQuerySid(psName in varchar2) return integer
is
  cursor curDynQuery(sName varchar2) is
    select dyqsid
      from dev_log_dyn_query
     where dyqname = sName
     order by dyqname;
  rowDynQuery curDynQuery%rowtype;
begin
  open curDynQuery(psName);
  fetch curDynQuery into rowDynQuery;
  close curDynQuery;
  return rowDynQuery.dyqsid;
end getDynQuerySid;

function getDynVarSid(psName in varchar2) return integer
is
  cursor curDynVar(sName varchar2) is
    select dyvsid
      from dev_log_dyn_var
     where dyvname = sName
     order by dyvname;
  rowDynVar curDynVar%rowtype;
begin
  open curDynVar(psName);
  fetch curDynVar into rowDynVar;
  close curDynVar;
  return rowDynVar.dyvsid;
end getDynVarSid;

function getSValue(pnSid in integer) return varchar2
is
  cursor curDynVar(nSid varchar2) is
    select dyvsvalue
      from dev_log_dyn_var
     where dyvsid = nSid;
  rowDynVar curDynVar%rowtype;
begin
  open curDynVar(pnSid);
  fetch curDynVar into rowDynVar;
  close curDynVar;
  return rowDynVar.dyvsvalue;
end getSValue;

function getSValue(psName in varchar2) return varchar2
is
begin
  return getSValue(getDynVarSid(psName));
end getSValue;

procedure setSValue(pnSid in integer, psValue in varchar2)
is
begin
  update dev_log_dyn_var
     set dyvsvalue = psValue,
         dyvmoduser = user,
         dyvmoddate = sysdate
   where dyvsid = pnSid;
end setSValue;

procedure setSValue(psName in varchar2, psValue in varchar2)
is
begin
  setSValue(getDynVarSid(psName), psValue);
end setSValue;

/*
function getSValue(pnSid in integer) return varchar2;
function getSValue(psName in varchar2) return varchar2;
procedure setSValue(pnSid in integer, psValue in varchar2);
procedure setSValue(pnName in varchar2, psValue in varchar2);

function getNValue(pnSid in integer) return number;
function getNValue(psName in varchar2) return number;
procedure setNValue(pnSid in integer, pnValue in number);
procedure setNValue(pnName in varchar2, pnValue in number);

function getDValue(pnSid in integer) return date;
function getDValue(psName in varchar2) return date;
procedure setDValue(pnSid in integer, pdValue in date);
procedure setDValue(pnName in varchar2, pdValue in date);

function getBValue(pnSid in integer) return boolean;
function getBValue(psName in varchar2) return boolean;
procedure setBValue(pnSid in integer, pbValue in boolean);
procedure setBValue(pnName in varchar2, pbValue in boolean);
*/

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
  pnDepth  in number   default null) -- filled, if called from other log functions (to be skipped)
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
  logDynVars(vRecDevLog.dlgsid);
  commit;
end log;

procedure bye        is begin log(psText1=>'bye',        pnDepth=>cnCallerDepth); end;
procedure ending     is begin log(psText1=>'ending',     pnDepth=>cnCallerDepth); end;
procedure ex         is begin log(psText1=>'ex',         pnDepth=>cnCallerDepth); end;
procedure help       is begin log(psText1=>'help',       pnDepth=>cnCallerDepth); end;
procedure hi         is begin log(psText1=>'hi',         pnDepth=>cnCallerDepth); end;
procedure impossible is begin log(psText1=>'impossible', pnDepth=>cnCallerDepth); end;
procedure mark       is begin log(psText1=>'mark',       pnDepth=>cnCallerDepth); end;
procedure starting   is begin log(psText1=>'starting',   pnDepth=>cnCallerDepth); end;

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
  pnDepth  in number   default null)
is
begin
  log(psText1,  psText2,  psText3,  psText4,  tc(pbText5),
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(psText1,  psText2,  psText3,  tc(pbText4), psText5,
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(psText1,  psText2,  psText3,  tc(pbText4), tc(pbText5),
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(psText1,  psText2,  tc(pbText3), psText4,  psText5,
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(psText1,  psText2,  tc(pbText3), psText4,  tc(pbText5),
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(psText1,  psText2,  tc(pbText3), tc(pbText4), psText5,
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(psText1,  psText2,  tc(pbText3), tc(pbText4), tc(pbText5),
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(psText1,  tc(pbText2), psText3,  psText4,  psText5,
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(psText1,  tc(pbText2), psText3,  psText4,  tc(pbText5),
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(psText1,  tc(pbText2), psText3,  tc(pbText4), psText5,
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(psText1,  tc(pbText2), psText3,  tc(pbText4), tc(pbText5),
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(psText1,  tc(pbText2), tc(pbText3), psText4,  psText5,
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(psText1,  tc(pbText2), tc(pbText3), psText4,  tc(pbText5),
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(psText1,  tc(pbText2), tc(pbText3), tc(pbText4), psText5,
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(psText1,  tc(pbText2), tc(pbText3), tc(pbText4), tc(pbText5),
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(tc(pbText1), psText2,  psText3,  psText4,  psText5,
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(tc(pbText1), psText2,  psText3,  psText4,  tc(pbText5),
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(tc(pbText1), psText2,  psText3,  tc(pbText4), psText5,
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(tc(pbText1), psText2,  psText3,  tc(pbText4), tc(pbText5),
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(tc(pbText1), psText2,  tc(pbText3), psText4,  psText5,
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(tc(pbText1), psText2,  tc(pbText3), psText4,  tc(pbText5),
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(tc(pbText1), psText2,  tc(pbText3), tc(pbText4), psText5,
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(tc(pbText1), psText2,  tc(pbText3), tc(pbText4), tc(pbText5),
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(tc(pbText1), tc(pbText2), psText3,  psText4,  psText5,
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(tc(pbText1), tc(pbText2), psText3,  psText4,  tc(pbText5),
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(tc(pbText1), tc(pbText2), psText3,  tc(pbText4), psText5,
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(tc(pbText1), tc(pbText2), psText3,  tc(pbText4), tc(pbText5),
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(tc(pbText1), tc(pbText2), tc(pbText3), psText4,  psText5,
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(tc(pbText1), tc(pbText2), tc(pbText3), psText4,  tc(pbText5),
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(tc(pbText1), tc(pbText2), tc(pbText3), tc(pbText4), psText5,
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

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
  pnDepth  in number   default null)
is
begin
  log(tc(pbText1), tc(pbText2), tc(pbText3), tc(pbText4), tc(pbText5),
      psText6,  psText7,  psText8,  psText9,  psText10,
      psText11, psText12, psText13, psText14, psText15,
      psText16, psText17, psText18, psText19, psText20,
      nvl(pnDepth, cnCallerDepth));
end;

end DevLog;
/
