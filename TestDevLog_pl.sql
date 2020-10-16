set serveroutput on
declare
-- project: DevLog
-- file: TestDevLog_pl.sql
-- author: Martin Schabmayr
-- last change: 2020-04-01 09:00
vsNull varchar2(50);
vnNull number;
vdNull date;
vbNull boolean;
procedure pl(psLine in varchar2) is begin dbms_output.put_line(psLine); end pl;
begin
pl('start of DevLog tests');
DevLog.clearLog;
MicAll.initGlobals('C4', 'SW', 'DEU', 'MIC-CUST', 'TECHNICUS');
DevLog.log('testing', 'for', 'first', 'user', DevLog.toChar(true));
TestDevLog.assertLogExists(psText1 => 'testing',
                           psSystem => 'MIC-CUST',
                           psCompany => 'C4',
                           psPlant => 'SW',
                           psLanguage => 'DEU',
                           psUser => 'TECHNICUS');
MicAll.initGlobals('C5', 'SZ', 'ENG', 'MIC-CUS1', 'EECHNICUS');
DevLog.log('testing', 'for', 'second', 'user', DevLog.toChar(true));
TestDevLog.assertLogExists(psText1 => 'testing',
                           psSystem => 'MIC-CUS1',
                           psCompany => 'C5',
                           psPlant => 'SZ',
                           psLanguage => 'ENG',
                           psUser => 'EECHNICUS');
TestDevLog.testA;
DevLog.log('Text1', 'Text2', 'Text3', 'Text4', 'Text5');
TestDevLog.assertLogExists(psText1 => 'start of B', psProgram => 'TESTDEVLOG.TESTB', psLine => 40, psCaller => 'TESTDEVLOG.TESTA', psCallerLine => 26);
TestDevLog.assertLogExists(psText1 => 'end of B',   psProgram => 'TESTDEVLOG.TESTB', psLine => 50, psCaller => 'TESTDEVLOG.TESTA', psCallerLine => 26);
TestDevLog.assertLogExists(psText1 => 'start of C', psProgram => 'TESTDEVLOG.TESTC', psLine => 58, psCaller => 'TESTDEVLOG.TESTB', psCallerLine => 41);
TestDevLog.assertLogExists(psText1 => 'hi',         psProgram => 'TESTDEVLOG.TESTC', psLine => 71, psCaller => 'TESTDEVLOG.TESTB', psCallerLine => 41);
TestDevLog.assertLogExists(psText1 => 'bye',        psProgram => 'TESTDEVLOG.TESTC', psLine => 72, psCaller => 'TESTDEVLOG.TESTB', psCallerLine => 41);
TestDevLog.assertLogExists(psText1 => 'mark',       psProgram => 'TESTDEVLOG.TESTC', psLine => 73, psCaller => 'TESTDEVLOG.TESTB', psCallerLine => 41);
TestDevLog.assertLogExists(psText1 => 'ex',         psProgram => 'TESTDEVLOG.TESTC', psLine => 74, psCaller => 'TESTDEVLOG.TESTB', psCallerLine => 41);
TestDevLog.assertLogExists(psText1 => 'help',       psProgram => 'TESTDEVLOG.TESTC', psLine => 75, psCaller => 'TESTDEVLOG.TESTB', psCallerLine => 41);
TestDevLog.assertLogExists(psText1 => 'impossible', psProgram => 'TESTDEVLOG.TESTC', psLine => 76, psCaller => 'TESTDEVLOG.TESTB', psCallerLine => 41);
TestDevLog.assertLogExists(psText1 => 'end of C',   psProgram => 'TESTDEVLOG.TESTC', psLine => 77, psCaller => 'TESTDEVLOG.TESTB', psCallerLine => 41);
--pl(utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(1)));
DevLog.log(true, false, 'test', true, false, null);
TestDevLog.assertLogExists(psText1 => 'true',
                           psText2 => 'false',
                           psText3 => 'test',
                           psText4 => 'true',
                           psText5 => 'false');
DevLog.log(true, false, 'test', true, false);
DevLog.log(true, false, 'test', true);
DevLog.log(true, false, vbNull, true, false, vsNull);
DevLog.log(true, false, vbNull, true, false);
DevLog.log(true, false, vbNull, true);

DevLog.log('first', true, vbNull, 'second', false, null);
DevLog.log(vbNull, 'first', true, vbNull, 'second');
DevLog.log(false, vbNull, 'first', true, vbNull, 'second');

DevLog.log('HelloWorld', 42, true, to_date('1970-01-01', 'yyyy-mm-dd'), 'someStr');
DevLog.log('someStr', 'HelloWorld', 42, true, to_date('1970-01-01', 'yyyy-mm-dd'));
DevLog.log(to_date('1970-01-01', 'yyyy-mm-dd'), 'someStr', 'HelloWorld', 42, true);
DevLog.log(true, to_date('1970-01-01', 'yyyy-mm-dd'), 'someStr', 'HelloWorld', 42);
DevLog.log(42, true, to_date('1970-01-01', 'yyyy-mm-dd'), 'someStr', 'HelloWorld');

DevLog.log('HelloWorld', 42, true, to_date('1970-01-01', 'yyyy-mm-dd'), vbNull);
DevLog.log(vbNull, 'HelloWorld', 42, true, to_date('1970-01-01', 'yyyy-mm-dd'));
DevLog.log(to_date('1970-01-01', 'yyyy-mm-dd'), vbNull, 'HelloWorld', 42, true);
DevLog.log(true, to_date('1970-01-01', 'yyyy-mm-dd'), vbNull, 'HelloWorld', 42);
DevLog.log(42, true, to_date('1970-01-01', 'yyyy-mm-dd'), vbNull, 'HelloWorld');

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

pl('end of DevLog tests');
--exception when others then pl('ex: '||sqlerrm);
end;
/
