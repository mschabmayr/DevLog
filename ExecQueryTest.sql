set serveroutput on
declare
  vTypeImportShipment CustImportShipment;
  vnSid number;
  vsFuncReturn varchar2(4000);
  vsQuery varchar2(4000);
  vnAppearance integer;
begin
  DevLog.pl('start');
  
  /*
  vTypeImportShipment := CustImportShipment.find(101);
  vnSid := 101;
  EXECUTE IMMEDIATE 'begin :param1 := CustImportShipment.find(:param2).getSid(); end;'
      USING    OUT vsFuncReturn,
            IN     vnSid;
  DevLog.pl('return: '||vsFuncReturn);
  
  vsQuery := 'CustImportShipment.find(<MyVar1>).getSid()||CustImportShipment.find(<MyVar2>).getSid()';
  -- ? is non-greedy match for <var1>someStr<var2>
  vnAppearance := 1;
  DevLog.pl(regexp_substr(vsQuery, '<.*?>', 1, vnAppearance));
  vnAppearance := 2;
  DevLog.pl(regexp_substr(vsQuery, '<.*?>', 1, vnAppearance));
  vnAppearance := 3;
  DevLog.pl(regexp_substr(vsQuery, '<.*?>', 1, vnAppearance));
  
  */
  
  vTypeImportShipment := CustImportShipment.find(101);
  vTypeImportShipment.setBelKz(null);
  vTypeImportShipment.persist();
  commit;

  DevLog.log('a');
  DevLog.log('bb');
  DevLog.log('ccc');

  vTypeImportShipment.setBelKz('A');
  vTypeImportShipment.persist();
  commit;

  DevLog.log('dddd');
  DevLog.log('eeeee');
end;
/
delete from dev_log;
select * from DevLogView;

delete from dev_log_dyn_var where dyvname = 'HW';
insert into dev_log_dyn_var(dyvsid, dyvname, dyvsvalue)
values(dev_log_dyn_var_seq.nextval, 'HW', 'HelloWorld');

delete from dev_log_dyn_var where dyvname = 'TODAY';
insert into dev_log_dyn_var(dyvsid, dyvname, dyvdvalue)
values(dev_log_dyn_var_seq.nextval, 'TODAY', sysdate);

delete from dev_log_dyn_var where dyvname = 'IS_SID';
insert into dev_log_dyn_var(dyvsid, dyvname, dyvnvalue)
values(dev_log_dyn_var_seq.nextval, 'IS_SID', 101);

delete from dev_log_dyn_query where dyqname = 'IS';
insert into dev_log_dyn_query(dyqsid, dyqname, dyqfield, dyqactive, dyqquery, dyqcreuser, dyqcredate)
values(dev_log_dyn_query_seq.nextval, 'IS', 'text1', '1',
  '''sid/close: ''||CustImportShipment.find(<IS_SID>).getSid()'
  ||'||''/''||CustImportShipment.find(<IS_SID>).getBelKz()'
  ||'||''/''||<HW>'
  ||'||''/''||<TODAY>',
  user, sysdate);

