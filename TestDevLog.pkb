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
  DevLog.log('end of C');
end;

end TestDevLog;
/
