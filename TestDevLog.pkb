create or replace package body TestDevLog is
-- project: DevLog
-- file: TestDevLog.pkb
-- author: Martin Schabmayr
-- last change: 2020-04-01 09:00

csPackageName varchar2(10) := 'TESTDEVLOG';

procedure assertEqual(psActual in varchar2,
  psExpected in varchar2,
  psErrorLine in varchar2)
is
begin
  if nvl(psActual != psExpected, true) then
    DevLog.pl('Test failed in line: '||psErrorLine||' - psActual: '||psActual||' - psExpected: '||psExpected);
  end if;
end assertEqual;



procedure testA
is
  vsCurrentFunc varchar2(5) := 'TESTA';
begin
  DevLog.log('start of A');
  testB;
  assertEqual(DevLog.thisUnit, csPackageName, $$plsql_line);
  assertEqual(DevLog.thisSubprogram, vsCurrentFunc, $$plsql_line);
  assertEqual(DevLog.thisUnitSubprogram, csPackageName||'.'||vsCurrentFunc, $$plsql_line);
  assertEqual(DevLog.thisLine, $$plsql_line, $$plsql_line);
  assertEqual(DevLog.thisLine, 31, 'lit_31');
  DevLog.log('end of A');
end;

procedure testB
is
  vsCurrentFunc varchar2(5) := 'TESTB';
  vsCallingFunc varchar2(5) := 'TESTA';
begin
  DevLog.log('start of B');
  testC;
  assertEqual(DevLog.thisUnit, csPackageName, $$plsql_line);
  assertEqual(DevLog.thisSubprogram, vsCurrentFunc, $$plsql_line);
  assertEqual(DevLog.thisUnitSubprogram, csPackageName||'.'||vsCurrentFunc, $$plsql_line);
  assertEqual(DevLog.thisLine, $$plsql_line, $$plsql_line);
  assertEqual(DevLog.thisLine, 46, 'lit_46');
  assertEqual(DevLog.callingUnit, csPackageName, $$plsql_line);
  assertEqual(DevLog.callingSubprogram, vsCallingFunc, $$plsql_line);
  assertEqual(DevLog.callingUnitSubprogram, csPackageName||'.'||vsCallingFunc, $$plsql_line);
  DevLog.log('end of B');
end;

procedure testC
is
  vsCurrentFunc varchar2(5) := 'TESTC';
  vsCallingFunc varchar2(5) := 'TESTB';
begin
  DevLog.log('start of C');
  null;
  DevLog.log('testing in C, this/calling',
    DevLog.thisUnitSubprogram, DevLog.thisUnit, DevLog.thisSubprogram,
    DevLog.callingUnitSubprogram, DevLog.callingUnit, DevLog.callingSubprogram);
  assertEqual(DevLog.thisUnit, csPackageName, $$plsql_line);
  assertEqual(DevLog.thisSubprogram, vsCurrentFunc, $$plsql_line);
  assertEqual(DevLog.thisLine, $$plsql_line, $$plsql_line);
  assertEqual(DevLog.thisLine, 66, 'lit_66');
  assertEqual(DevLog.thisUnitSubprogram, csPackageName||'.'||vsCurrentFunc, $$plsql_line);
  assertEqual(DevLog.callingUnit, csPackageName, $$plsql_line);
  assertEqual(DevLog.callingSubprogram, vsCallingFunc, $$plsql_line);
  assertEqual(DevLog.callingUnitSubprogram, csPackageName||'.'||vsCallingFunc, $$plsql_line);
  DevLog.hi();
  DevLog.bye();
  DevLog.mark();
  DevLog.ex();
  DevLog.help();
  DevLog.impossible();
  DevLog.log('end of C');
end;

procedure assertLogExists(
  psText1      in varchar2,
  psText2      in varchar2 default null,
  psText3      in varchar2 default null,
  psText4      in varchar2 default null,
  psText5      in varchar2 default null,
  psProgram    in varchar2 default null,
  psLine       in varchar2 default null,
  psCaller     in varchar2 default null,
  psCallerLine in varchar2 default null,
  psSystem     in varchar2 default null,
  psCompany    in varchar2 default null,
  psPlant      in varchar2 default null,
  psLanguage   in varchar2 default null,
  psUser       in varchar2 default null
)
is
  cursor curLog(sText1 in varchar2,
                sText2 in varchar2,
                sText3 in varchar2,
                sText4 in varchar2,
                sText5 in varchar2,
                sProgram in varchar2,
                sCaller in varchar2,
                sSystem in varchar2,
                sCompany in varchar2,
                sPlant in varchar2,
                sLanguage in varchar2,
                sUser in varchar2) is
    select dlgsid
      from DevLogView
     where dlgtext1 = sText1
       and ((sText2 is null)    or dlgtext2 = sText2)
       and ((sText3 is null)    or dlgtext3 = sText3)
       and ((sText4 is null)    or dlgtext4 = sText4)
       and ((sText5 is null)    or dlgtext5 = sText5)
       and ((sProgram is null)  or program = sProgram)
       and ((sCaller is null)   or caller = sCaller)
       and ((sSystem is null)   or dlvsystem = sSystem)
       and ((sCompany is null)  or dlvcompany = sCompany)
       and ((sPlant is null)    or dlvplant = sPlant)
       and ((sLanguage is null) or dlvlanguage = sLanguage)
       and ((sUser is null)     or dlvuser = sUser)
       ;
  rowLog curLog%rowtype;

  vsProgram varchar2(100);
  vsCaller varchar2(100);
begin
  if psProgram is not null or psLine is not null then
    vsProgram := psProgram || ':' || psLine;
  end if;
  if psCaller is not null or psCallerLine is not null then
    vsCaller := psCaller || ':' || psCallerLine;
  end if;
  --DevLog.pl(DevLog.format('Opening cursor with: %s/%s/%s/%s/%s, %s/%s, %s/%s/%s/%s/%s',
  --  psText1, psText2, psText3, psText4, psText5,
  --  vsProgram, vsCaller,
  --  psSystem, psCompany, psPlant, psLanguage, psUser));
  open curLog(psText1, psText2, psText3, psText4, psText5,
              vsProgram, vsCaller,
              psSystem, psCompany, psPlant, psLanguage, psUser);
  fetch curLog into rowLog;
  if curLog%notfound then
    DevLog.pl(DevLog.format('Test failed. Log not found: %s/%s/%s/%s/%s, %s/%s/%s/%s, %s/%s/%s/%s/%s',
      psText1, psText2, psText3, psText4, psText5,
      psProgram, psLine, psCaller, psCallerLine,
      psSystem, psCompany, psPlant, psLanguage, psUser));
  end if;
  close curLog;
end assertLogExists;

end TestDevLog;
/
