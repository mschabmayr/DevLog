create or replace package body TestDevLog is
-- project: DevLog
-- file: TestDevLog.pkb
-- author: Martin Schabmayr
-- last change: 2020-03-21 10:00

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
  assertEqual(DevLog.thisPackage, csPackageName, $$plsql_line);
  assertEqual(DevLog.thisFunction, vsCurrentFunc, $$plsql_line);
  assertEqual(DevLog.thisProgram, csPackageName||'.'||vsCurrentFunc, $$plsql_line);
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
  assertEqual(DevLog.thisPackage, csPackageName, $$plsql_line);
  assertEqual(DevLog.thisFunction, vsCurrentFunc, $$plsql_line);
  assertEqual(DevLog.thisProgram, csPackageName||'.'||vsCurrentFunc, $$plsql_line);
  assertEqual(DevLog.thisLine, $$plsql_line, $$plsql_line);
  assertEqual(DevLog.thisLine, 46, 'lit_46');
  assertEqual(DevLog.callingPackage, csPackageName, $$plsql_line);
  assertEqual(DevLog.callingFunction, vsCallingFunc, $$plsql_line);
  assertEqual(DevLog.callingProgram, csPackageName||'.'||vsCallingFunc, $$plsql_line);
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
    DevLog.thisProgram, DevLog.thisPackage, DevLog.thisFunction,
    DevLog.callingProgram, DevLog.callingPackage, DevLog.callingFunction);
  assertEqual(DevLog.thisPackage, csPackageName, $$plsql_line);
  assertEqual(DevLog.thisFunction, vsCurrentFunc, $$plsql_line);
  assertEqual(DevLog.thisLine, $$plsql_line, $$plsql_line);
  assertEqual(DevLog.thisLine, 66, 'lit_66');
  assertEqual(DevLog.thisProgram, csPackageName||'.'||vsCurrentFunc, $$plsql_line);
  assertEqual(DevLog.callingPackage, csPackageName, $$plsql_line);
  assertEqual(DevLog.callingFunction, vsCallingFunc, $$plsql_line);
  assertEqual(DevLog.callingProgram, csPackageName||'.'||vsCallingFunc, $$plsql_line);
  DevLog.hi();
  DevLog.bye();
  DevLog.mark();
  DevLog.ex();
  DevLog.help();
  DevLog.impossible();
  DevLog.log('end of C');
end;

procedure assertLogExists(
  psText1 in varchar2,
  psProgram in varchar2 default null,
  psLine in varchar2 default null,
  psCaller in varchar2 default null,
  psCallerLine in varchar2 default null
)
is
  cursor curLog(sText1 in varchar2,
                sProgram in varchar2,
                sLine in varchar2,
                sCaller in varchar2,
                sCallerLine in varchar2) is
    select dlgsid
      from dev_log
     inner join dev_log_meta on dlgsid = dlmdlgsid
     where dlgtext1 = sText1
       and ((sProgram is null)    or dlmprogram = sProgram)
       and ((sLine is null)       or dlmprogramline = sLine)
       and ((sCaller is null)     or dlmcaller = sCaller)
       and ((sCallerLine is null) or dlmcallerline = sCallerLine);
  rowLog curLog%rowtype;
begin
  open curLog(psText1, psProgram, psLine, psCaller, psCallerLine);
  fetch curLog into rowLog;
  if curLog%notfound then
    DevLog.pl(DevLog.format('Test failed. Log not found: %s/%s/%s/%s/%s',
      psText1, psProgram, psLine, psCaller, psCallerLine));
  end if;
  close curLog;
end assertLogExists;

end TestDevLog;
/
