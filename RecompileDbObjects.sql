set serveroutput on
begin
  DevLog.pl('Number of invalid objects: ' || DevLog.countInvalidDbObjects());
end;
/
begin
  DevLog.recompileDbObjects();
end;
/