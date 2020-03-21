create or replace package TestDevLog authid current_user is
-- project: DevLog
-- file: TestDevLog.pks
-- author: Martin Schabmayr
-- last change: 2020-03-21 10:00

procedure testA;
procedure testB;
procedure testC;

procedure assertLogExists(
  psText1 in varchar2,
  psProgram in varchar2 default null,
  psLine in varchar2 default null,
  psCaller in varchar2 default null,
  psCallerLine in varchar2 default null
);

end TestDevLog;
/
