set serveroutput on
declare
-- project: DevLog
-- file: TestDevLog_overloads_pl.sql
-- author: Martin Schabmayr
-- last change: 2020-04-01 09:00
vsNull varchar2(50);
vnNull number;
vdNull date;
vbNull boolean;
function tc(pbValue in boolean) return varchar2
is
begin
  if pbValue is null then
    return 'null';
  elsif pbValue then
    return 'true';
  end if;
  return 'false';
end tc;
procedure pl(psLine in varchar2) is begin dbms_output.put_line(psLine); end pl;
procedure pl(pbText in boolean)
is
begin
  pl(tc(pbText));
end pl;
begin
pl('start');
pl(true);
pl(vsNull);
pl(vnNull);
pl(vdNull);
pl(vbNull);
pl('end');
--exception when others then pl('ex: '||sqlerrm);
end;
/

