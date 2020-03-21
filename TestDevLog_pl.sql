set serveroutput on
declare
-- project: DevLog
-- file: TestDevLog_pl.sql
-- author: Martin Schabmayr
-- last change: 2020-03-21 10:00
procedure pl(psLine in varchar2) is begin dbms_output.put_line(psLine); end pl;
begin
pl('start');
DevLog.clear;
MicAll.InitGlobals('C4', 'SW', 'ENG', 'MIC-CUST', 'TECHNICUS');
DevLog.log('testing', 'for', 'first', 'user', DevLog.toChar(true));
MicAll.InitGlobals('C5', 'SZ', 'END', 'MIC-CUS1', 'EECHNICUS');
DevLog.log('testing', 'for', 'second', 'user', DevLog.toChar(true));
TestDevLog.testA;
DevLog.log('Text1', 'Text2', 'Text3', 'Text4', 'Text5');
TestDevLog.assertLogExists('start of B', 'TESTDEVLOG.TESTB', 40, 'TESTDEVLOG.TESTA', 26);
TestDevLog.assertLogExists('start of C', 'TESTDEVLOG.TESTC', 58, 'TESTDEVLOG.TESTB', 41);
TestDevLog.assertLogExists('end of C', 'TESTDEVLOG.TESTC', 72, 'TESTDEVLOG.TESTB', 41);
TestDevLog.assertLogExists('end of B', 'TESTDEVLOG.TESTB', 50, 'TESTDEVLOG.TESTA', 26);
TestDevLog.assertLogExists('hi');
--pl(utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(1)));
/*
pl($$plsql_line||': '||DevLog.thisProgram);
pl($$plsql_line||': '||DevLog.thisPackage);
pl($$plsql_line||': '||DevLog.thisFunction);
pl($$plsql_line||': '||DevLog.thisLine);
pl($$plsql_line||': '||DevLog.callingProgram);
pl($$plsql_line||': '||DevLog.callingPackage);
pl($$plsql_line||': '||DevLog.callingFunction);
pl($$plsql_line||': '||DevLog.callingLine);
*/
pl('end');
--exception when others then pl('ex: '||sqlerrm);
end;
/