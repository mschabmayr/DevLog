
delete
  from dev_log_dyn_var
 where dyvname = 'IS_SID';

insert into dev_log_dyn_var(dyvsid, dyvname, dyvnvalue)
  values(dev_log_dyn_var_seq.nextval, 'IS_SID', 0);

delete
  from dev_log_dyn_query
 where dyqname = 'ImportShipmentQuery';

insert into dev_log_dyn_query(dyqsid, dyqname, dyqfield, dyqactive, dyqquery, dyqcreuser, dyqcredate)
  values(dev_log_dyn_query_seq.nextval, 'ImportShipmentQuery', 'text11', '0',
    '''sid/close: ''||CustImportShipment.find(<IS_SID>).getSid()'
    ||'||''/''||CustImportShipment.find(<IS_SID>).getBelKz()',
    user, sysdate);

delete
  from dev_log_dyn_var
 where dyvname = 'IK_SID';

insert into dev_log_dyn_var(dyvsid, dyvname, dyvnvalue)
  values(dev_log_dyn_var_seq.nextval, 'IK_SID', 0);

delete
  from dev_log_dyn_query
 where dyqname = 'ImportInvoiceQuery';

insert into dev_log_dyn_query(dyqsid, dyqname, dyqfield, dyqactive, dyqquery, dyqcreuser, dyqcredate)
  values(dev_log_dyn_query_seq.nextval, 'ImportInvoiceQuery', 'text12', '0',
    '''sid: ''||CustImportInvoice.find(<IK_SID>).getSid()',
    user, sysdate);

delete
  from dev_log_dyn_var
 where dyvname = 'IP_SID';

insert into dev_log_dyn_var(dyvsid, dyvname, dyvnvalue)
  values(dev_log_dyn_var_seq.nextval, 'IP_SID', 0);

delete
  from dev_log_dyn_query
 where dyqname = 'ImportLineQuery';

insert into dev_log_dyn_query(dyqsid, dyqname, dyqfield, dyqactive, dyqquery, dyqcreuser, dyqcredate)
  values(dev_log_dyn_query_seq.nextval, 'ImportLineQuery', 'text13', '0',
    '''sid: ''||CustImportLine.find(<IP_SID>).getSid()',
    user, sysdate);

delete
  from dev_log_dyn_var
 where dyvname = 'ES_SID';

insert into dev_log_dyn_var(dyvsid, dyvname, dyvnvalue)
  values(dev_log_dyn_var_seq.nextval, 'ES_SID', 0);

delete
  from dev_log_dyn_query
 where dyqname = 'ExportShipmentQuery';

insert into dev_log_dyn_query(dyqsid, dyqname, dyqfield, dyqactive, dyqquery, dyqcreuser, dyqcredate)
  values(dev_log_dyn_query_seq.nextval, 'ExportShipmentQuery', 'text14', '0',
    '''sid/close: ''||CustExportShipment.find(<ES_SID>).getSid()'
    ||'||''/''||CustExportShipment.find(<ES_SID>).getBelKz()',
    user, sysdate);

delete
  from dev_log_dyn_var
 where dyvname = 'EK_SID';

insert into dev_log_dyn_var(dyvsid, dyvname, dyvnvalue)
  values(dev_log_dyn_var_seq.nextval, 'EK_SID', 0);

delete
  from dev_log_dyn_query
 where dyqname = 'ExportInvoiceQuery';

insert into dev_log_dyn_query(dyqsid, dyqname, dyqfield, dyqactive, dyqquery, dyqcreuser, dyqcredate)
  values(dev_log_dyn_query_seq.nextval, 'ExportInvoiceQuery', 'text15', '0',
    '''sid: ''||CustExportInvoice.find(<EK_SID>).getSid()',
    user, sysdate);

delete
  from dev_log_dyn_var
 where dyvname = 'EP_SID';

insert into dev_log_dyn_var(dyvsid, dyvname, dyvnvalue)
  values(dev_log_dyn_var_seq.nextval, 'EP_SID', 0);

delete
  from dev_log_dyn_query
 where dyqname = 'ExportLineQuery';

insert into dev_log_dyn_query(dyqsid, dyqname, dyqfield, dyqactive, dyqquery, dyqcreuser, dyqcredate)
  values(dev_log_dyn_query_seq.nextval, 'ExportLineQuery', 'text16', '0',
    '''sid: ''||CustExportLine.find(<EP_SID>).getSid()',
    user, sysdate);
