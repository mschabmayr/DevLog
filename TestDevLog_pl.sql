set serveroutput on
declare
-- project: DevLog
-- file: TestDevLog_pl.sql
-- author: Martin Schabmayr
-- last change: 2019-05-16 07:00
procedure pl(psLine in varchar2) is begin dbms_output.put_line(psLine); end pl;
begin
pl('start');
MicAll.InitGlobals('C4', 'SW', 'ENG', 'MIC-CUST', 'TECHNICUS');
DevLog.log('testing', 'for', 'first', 'user', DevLog.toChar(true));
MicAll.InitGlobals('C5', 'SZ', 'END', 'MIC-CUS1', 'EECHNICUS');
DevLog.log('testing', 'for', 'second', 'user', DevLog.toChar(true));
TestDevLog.testA;
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