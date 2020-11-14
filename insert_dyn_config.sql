
create or replace function getCnDecById(psId in varchar2)
return CnSinWinDecHead
is
  cursor curDecHead(sDecId varchar2) is
    select CnSinWinDecHead.find(cswsid)
      from mic_cn_sw_dechead
     where cswshipmentid = sDecId
     order by cswsid desc;

  vTypeDecHead CnSinWinDecHead;
begin
  open curDecHead(psId);
  fetch curDecHead into vTypeDecHead;
  close curDecHead;
  return vTypeDecHead;
end;
/

delete
  from dev_log_dyn_var
 where dyvname = 'IS_SID';

insert into dev_log_dyn_var(dyvsid, dyvname, dyvnvalue)
  values(dev_log_dyn_var_seq.nextval, 'IS_SID', 0);

delete
  from dev_log_dyn_var
 where dyvname = 'IS_ID';

insert into dev_log_dyn_var(dyvsid, dyvname, dyvsvalue)
  values(dev_log_dyn_var_seq.nextval, 'IS_ID', 'SHIP_ID');

delete
  from dev_log_dyn_query
 where dyqname = 'ImportShipmentQuery';

insert into dev_log_dyn_query(dyqsid, dyqname, dyqfield, dyqactive, dyqquery, dyqcreuser, dyqcredate)
  values(dev_log_dyn_query_seq.nextval, 'ImportShipmentQuery', 'text11', '0',
    '''sid/close/send/rec: ''||CustImportShipment.find(<IS_SID>).getSid()'
    ||'||''/''||CustImportShipment.find(<IS_SID>).getBelKz()'
    ||'||''/''||CustImportShipment.find(<IS_SID>).getMessSStatus()'
    ||'||''/''||CustImportShipment.find(<IS_SID>).getMessRStatus()',
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
  from dev_log_dyn_query
 where dyqname = 'ImportCnDeclaration';

insert into dev_log_dyn_query(dyqsid, dyqname, dyqfield, dyqactive, dyqquery, dyqcreuser, dyqcredate)
  values(dev_log_dyn_query_seq.nextval, 'ImportCnDeclaration', 'text14', '0',
    '''sid/close: ''||getCnDecById(<IS_ID>).getSid()'
    ||'||''/''||getCnDecById(<IS_ID>).getSid()'
    ||'||''/''||getCnDecById(<IS_ID>).getMessageStatusSend()'
    ||'||''/''||getCnDecById(<IS_ID>).getMessageStatusReceive()',
    user, sysdate);

delete
  from dev_log_dyn_var
 where dyvname = 'ES_SID';

insert into dev_log_dyn_var(dyvsid, dyvname, dyvnvalue)
  values(dev_log_dyn_var_seq.nextval, 'ES_SID', 0);

delete
  from dev_log_dyn_var
 where dyvname = 'ES_ID';

insert into dev_log_dyn_var(dyvsid, dyvname, dyvsvalue)
  values(dev_log_dyn_var_seq.nextval, 'ES_ID', 'SHIP_ID');

delete
  from dev_log_dyn_query
 where dyqname = 'ExportShipmentQuery';

insert into dev_log_dyn_query(dyqsid, dyqname, dyqfield, dyqactive, dyqquery, dyqcreuser, dyqcredate)
  values(dev_log_dyn_query_seq.nextval, 'ExportShipmentQuery', 'text15', '0',
    '''sid/close: ''||CustExportShipment.find(<ES_SID>).getSid()'
    ||'||''/''||CustExportShipment.find(<ES_SID>).getBelKz()'
    ||'||''/''||CustExportShipment.find(<ES_SID>).getMessSStatus()'
    ||'||''/''||CustExportShipment.find(<ES_SID>).getMessRStatus()',
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
  values(dev_log_dyn_query_seq.nextval, 'ExportInvoiceQuery', 'text16', '0',
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
  values(dev_log_dyn_query_seq.nextval, 'ExportLineQuery', 'text17', '0',
    '''sid: ''||CustExportLine.find(<EP_SID>).getSid()',
    user, sysdate);

delete
  from dev_log_dyn_query
 where dyqname = 'ExportCnDeclaration';

insert into dev_log_dyn_query(dyqsid, dyqname, dyqfield, dyqactive, dyqquery, dyqcreuser, dyqcredate)
  values(dev_log_dyn_query_seq.nextval, 'ExportCnDeclaration', 'text18', '0',
    '''sid/close: ''||getCnDecById(<ES_ID>).getSid()'
    ||'||''/''||getCnDecById(<ES_ID>).getSid()'
    ||'||''/''||getCnDecById(<ES_ID>).getMessageStatusSend()'
    ||'||''/''||getCnDecById(<ES_ID>).getMessageStatusReceive()',
    user, sysdate);

-- end