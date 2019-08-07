# DevLog
PL/SQL development logging tool

This tool can be used to quickly debug legacy code. Current values can be logged autonomously, while the stacktrace helps to understand the programs execution.

## Features
- log up to 20 variables / values with one line
- oracle program stacktrace is automatically available for each line
- log session / global variables are automatically for each line
- logging of variables can be extended for a specific environment
- view of the log lines can be extended for a specific use

## How to install it
- execute the script create_all.sql
- (don't copy the code or else the relative paths will not be found)


## How to use it
- include a logging line in PL/SQL code, like a script or a compiled package function/procedure, and execute it

```
begin
  -- start of example procedure
  ...
  DevLog.log('value1', 1234, sysdate, DevLog.toChar(true)); -- up to 20 parameters
  ...
  -- end of example procedure
end;
```

- this will write a logging output to the table dev_log
- select from the view DevLogView to see the latest output
```
-- clean, ordered view of the output
select * from DevLogView; 

-- base tables containing the data
select * from dev_log; 
select * from dev_log_meta;
select * from dev_log_val;
```
