create or replace package TestDevLog authid current_user is
-- project: DevLog
-- file: TestDevLog.pks
-- author: Martin Schabmayr
-- last change: 2020-04-01 09:00

procedure testA;
procedure testB;
procedure testC;

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
);

end TestDevLog;
/
