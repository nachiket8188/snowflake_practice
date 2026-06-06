/* STAGING LAYER VERSION - All columns are VARCHAR to prevent data type incompatibility errors during ingestion.
   Type enforcement should be applied when moving data from staging to the next layer using TRY_CAST.

   This file was generated from: SnowConvert AI (AdventureWorks) Related.sql
*/

/* This command is used to enable functioning of SnowConvert AI. */
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US';

create
or replace database ADVENTUREWORKS COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

USE DATABASE ADVENTUREWORKS;

create
or replace schema ADVENTUREWORKS.DBO COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.DBO.AWBUILDVERSION (
    SYSTEMINFORMATIONID VARCHAR,
    "Database Version" VARCHAR,
    VERSIONDATE VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.DBO.DATABASELOG (
    DATABASELOGID VARCHAR,
    POSTTIME VARCHAR,
    DATABASEUSER VARCHAR,
    EVENT VARCHAR,
    "Schema" VARCHAR,
    OBJECT VARCHAR,
    TSQL VARCHAR,
    XMLEVENT VARCHAR
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.DBO.ERRORLOG (
    ERRORLOGID VARCHAR,
    ERRORTIME VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR),
    USERNAME VARCHAR,
    ERRORNUMBER VARCHAR,
    ERRORSEVERITY VARCHAR,
    ERRORSTATE VARCHAR,
    ERRORPROCEDURE VARCHAR,
    ERRORLINE VARCHAR,
    ERRORMESSAGE VARCHAR
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace schema ADVENTUREWORKS.HUMANRESOURCES COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.HUMANRESOURCES.DEPARTMENT (
    DEPARTMENTID VARCHAR,
    NAME VARCHAR,
    GROUPNAME VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.HUMANRESOURCES.EMPLOYEE (
    BUSINESSENTITYID VARCHAR,
    NATIONALIDNUMBER VARCHAR,
    LOGINID VARCHAR,
    ORGANIZATIONNODE VARCHAR,
    ORGANIZATIONLEVEL VARCHAR,
    JOBTITLE VARCHAR,
    BIRTHDATE VARCHAR,
    MARITALSTATUS VARCHAR,
    GENDER VARCHAR,
    HIREDATE VARCHAR,
    SALARIEDFLAG VARCHAR DEFAULT 'TRUE',
    VACATIONHOURS VARCHAR DEFAULT '0',
    SICKLEAVEHOURS VARCHAR DEFAULT '0',
    CURRENTFLAG VARCHAR DEFAULT 'TRUE',
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.HUMANRESOURCES.EMPLOYEEDEPARTMENTHISTORY (
    BUSINESSENTITYID VARCHAR,
    DEPARTMENTID VARCHAR,
    SHIFTID VARCHAR,
    STARTDATE VARCHAR,
    ENDDATE VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.HUMANRESOURCES.EMPLOYEEPAYHISTORY (
    BUSINESSENTITYID VARCHAR,
    RATECHANGEDATE VARCHAR,
    RATE VARCHAR,
    PAYFREQUENCY VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.HUMANRESOURCES.JOBCANDIDATE (
    JOBCANDIDATEID VARCHAR,
    BUSINESSENTITYID VARCHAR,
    RESUME VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.HUMANRESOURCES.SHIFT (
    SHIFTID VARCHAR,
    NAME VARCHAR,
    STARTTIME VARCHAR,
    ENDTIME VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace schema ADVENTUREWORKS.PERSON COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PERSON.ADDRESS (
    ADDRESSID VARCHAR,
    ADDRESSLINE1 VARCHAR,
    ADDRESSLINE2 VARCHAR,
    CITY VARCHAR,
    STATEPROVINCEID VARCHAR,
    POSTALCODE VARCHAR,
    SPATIALLOCATION VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PERSON.ADDRESSTYPE (
    ADDRESSTYPEID VARCHAR,
    NAME VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PERSON.BUSINESSENTITY (
    BUSINESSENTITYID VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PERSON.BUSINESSENTITYADDRESS (
    BUSINESSENTITYID VARCHAR,
    ADDRESSID VARCHAR,
    ADDRESSTYPEID VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PERSON.BUSINESSENTITYCONTACT (
    BUSINESSENTITYID VARCHAR,
    PERSONID VARCHAR,
    CONTACTTYPEID VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PERSON.CONTACTTYPE (
    CONTACTTYPEID VARCHAR,
    NAME VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PERSON.COUNTRYREGION (
    COUNTRYREGIONCODE VARCHAR,
    NAME VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PERSON.EMAILADDRESS (
    BUSINESSENTITYID VARCHAR,
    EMAILADDRESSID VARCHAR,
    EMAILADDRESS VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PERSON.PASSWORD (
    BUSINESSENTITYID VARCHAR,
    PASSWORDHASH VARCHAR,
    PASSWORDSALT VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PERSON.PERSON (
    BUSINESSENTITYID VARCHAR,
    PERSONTYPE VARCHAR,
    NAMESTYLE VARCHAR DEFAULT '0',
    TITLE VARCHAR,
    FIRSTNAME VARCHAR,
    MIDDLENAME VARCHAR,
    LASTNAME VARCHAR,
    SUFFIX VARCHAR,
    EMAILPROMOTION VARCHAR DEFAULT '0',
    ADDITIONALCONTACTINFO VARCHAR,
    DEMOGRAPHICS VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PERSON.PERSONPHONE (
    BUSINESSENTITYID VARCHAR,
    PHONENUMBER VARCHAR,
    PHONENUMBERTYPEID VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PERSON.PHONENUMBERTYPE (
    PHONENUMBERTYPEID VARCHAR,
    NAME VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PERSON.STATEPROVINCE (
    STATEPROVINCEID VARCHAR,
    STATEPROVINCECODE VARCHAR,
    COUNTRYREGIONCODE VARCHAR,
    ISONLYSTATEPROVINCEFLAG VARCHAR DEFAULT 'TRUE',
    NAME VARCHAR,
    TERRITORYID VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace schema ADVENTUREWORKS.PRODUCTION COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.BILLOFMATERIALS (
    BILLOFMATERIALSID VARCHAR,
    PRODUCTASSEMBLYID VARCHAR,
    COMPONENTID VARCHAR,
    STARTDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR),
    ENDDATE VARCHAR,
    UNITMEASURECODE VARCHAR,
    BOMLEVEL VARCHAR,
    PERASSEMBLYQTY VARCHAR DEFAULT '1',
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.CULTURE (
    CULTUREID VARCHAR,
    NAME VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.DOCUMENT (
    DOCUMENTNODE VARCHAR,
    DOCUMENTLEVEL VARCHAR,
    TITLE VARCHAR,
    OWNER VARCHAR,
    FOLDERFLAG VARCHAR DEFAULT 'FALSE',
    FILENAME VARCHAR,
    FILEEXTENSION VARCHAR,
    REVISION VARCHAR,
    CHANGENUMBER VARCHAR DEFAULT '0',
    STATUS VARCHAR,
    DOCUMENTSUMMARY VARCHAR,
    DOCUMENT VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.ILLUSTRATION (
    ILLUSTRATIONID VARCHAR,
    DIAGRAM VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.LOCATION (
    LOCATIONID VARCHAR,
    NAME VARCHAR,
    COSTRATE VARCHAR DEFAULT '0',
    AVAILABILITY VARCHAR DEFAULT '0',
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCT (
    PRODUCTID VARCHAR,
    NAME VARCHAR,
    PRODUCTNUMBER VARCHAR,
    MAKEFLAG VARCHAR DEFAULT 'TRUE',
    FINISHEDGOODSFLAG VARCHAR DEFAULT 'TRUE',
    COLOR VARCHAR,
    SAFETYSTOCKLEVEL VARCHAR,
    REORDERPOINT VARCHAR,
    STANDARDCOST VARCHAR,
    LISTPRICE VARCHAR,
    SIZE VARCHAR,
    SIZEUNITMEASURECODE VARCHAR,
    WEIGHTUNITMEASURECODE VARCHAR,
    WEIGHT VARCHAR,
    DAYSTOMANUFACTURE VARCHAR,
    PRODUCTLINE VARCHAR,
    CLASS VARCHAR,
    STYLE VARCHAR,
    PRODUCTSUBCATEGORYID VARCHAR,
    PRODUCTMODELID VARCHAR,
    SELLSTARTDATE VARCHAR,
    SELLENDDATE VARCHAR,
    DISCONTINUEDDATE VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTCATEGORY (
    PRODUCTCATEGORYID VARCHAR,
    NAME VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTCOSTHISTORY (
    PRODUCTID VARCHAR,
    STARTDATE VARCHAR,
    ENDDATE VARCHAR,
    STANDARDCOST VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTDESCRIPTION (
    PRODUCTDESCRIPTIONID VARCHAR,
    DESCRIPTION VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTDOCUMENT (
    PRODUCTID VARCHAR,
    DOCUMENTNODE VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTINVENTORY (
    PRODUCTID VARCHAR,
    LOCATIONID VARCHAR,
    SHELF VARCHAR,
    BIN VARCHAR,
    QUANTITY VARCHAR DEFAULT '0',
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTLISTPRICEHISTORY (
    PRODUCTID VARCHAR,
    STARTDATE VARCHAR,
    ENDDATE VARCHAR,
    LISTPRICE VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTMODEL (
    PRODUCTMODELID VARCHAR,
    NAME VARCHAR,
    CATALOGDESCRIPTION VARCHAR,
    INSTRUCTIONS VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTMODELILLUSTRATION (
    PRODUCTMODELID VARCHAR,
    ILLUSTRATIONID VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTMODELPRODUCTDESCRIPTIONCULTURE (
    PRODUCTMODELID VARCHAR,
    PRODUCTDESCRIPTIONID VARCHAR,
    CULTUREID VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTPHOTO (
    PRODUCTPHOTOID VARCHAR,
    THUMBNAILPHOTO VARCHAR,
    THUMBNAILPHOTOFILENAME VARCHAR,
    LARGEPHOTO VARCHAR,
    LARGEPHOTOFILENAME VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTPRODUCTPHOTO (
    PRODUCTID VARCHAR,
    PRODUCTPHOTOID VARCHAR,
    "PRIMARY" VARCHAR DEFAULT '1',
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTREVIEW (
    PRODUCTREVIEWID VARCHAR,
    PRODUCTID VARCHAR,
    REVIEWERNAME VARCHAR,
    REVIEWDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR),
    EMAILADDRESS VARCHAR,
    RATING VARCHAR,
    COMMENTS VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTSUBCATEGORY (
    PRODUCTSUBCATEGORYID VARCHAR,
    PRODUCTCATEGORYID VARCHAR,
    NAME VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.SCRAPREASON (
    SCRAPREASONID VARCHAR,
    NAME VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.TRANSACTIONHISTORY (
    TRANSACTIONID VARCHAR,
    PRODUCTID VARCHAR,
    REFERENCEORDERID VARCHAR,
    REFERENCEORDERLINEID VARCHAR DEFAULT '0',
    TRANSACTIONDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR),
    TRANSACTIONTYPE VARCHAR,
    QUANTITY VARCHAR,
    ACTUALCOST VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.TRANSACTIONHISTORYARCHIVE (
    TRANSACTIONID VARCHAR,
    PRODUCTID VARCHAR,
    REFERENCEORDERID VARCHAR,
    REFERENCEORDERLINEID VARCHAR DEFAULT '0',
    TRANSACTIONDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR),
    TRANSACTIONTYPE VARCHAR,
    QUANTITY VARCHAR,
    ACTUALCOST VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.UNITMEASURE (
    UNITMEASURECODE VARCHAR,
    NAME VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.WORKORDER (
    WORKORDERID VARCHAR,
    PRODUCTID VARCHAR,
    ORDERQTY VARCHAR,
    STOCKEDQTY VARCHAR,
    SCRAPPEDQTY VARCHAR,
    STARTDATE VARCHAR,
    ENDDATE VARCHAR,
    DUEDATE VARCHAR,
    SCRAPREASONID VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PRODUCTION.WORKORDERROUTING (
    WORKORDERID VARCHAR,
    PRODUCTID VARCHAR,
    OPERATIONSEQUENCE VARCHAR,
    LOCATIONID VARCHAR,
    SCHEDULEDSTARTDATE VARCHAR,
    SCHEDULEDENDDATE VARCHAR,
    ACTUALSTARTDATE VARCHAR,
    ACTUALENDDATE VARCHAR,
    ACTUALRESOURCEHRS VARCHAR,
    PLANNEDCOST VARCHAR,
    ACTUALCOST VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace schema ADVENTUREWORKS.PUBLIC;

create
or replace schema ADVENTUREWORKS.PURCHASING COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PURCHASING.PRODUCTVENDOR (
    PRODUCTID VARCHAR,
    BUSINESSENTITYID VARCHAR,
    AVERAGELEADTIME VARCHAR,
    STANDARDPRICE VARCHAR,
    LASTRECEIPTCOST VARCHAR,
    LASTRECEIPTDATE VARCHAR,
    MINORDERQTY VARCHAR,
    MAXORDERQTY VARCHAR,
    ONORDERQTY VARCHAR,
    UNITMEASURECODE VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PURCHASING.PURCHASEORDERDETAIL (
    PURCHASEORDERID VARCHAR,
    PURCHASEORDERDETAILID VARCHAR,
    DUEDATE VARCHAR,
    ORDERQTY VARCHAR,
    PRODUCTID VARCHAR,
    UNITPRICE VARCHAR,
    LINETOTAL VARCHAR,
    RECEIVEDQTY VARCHAR,
    REJECTEDQTY VARCHAR,
    STOCKEDQTY VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PURCHASING.PURCHASEORDERHEADER (
    PURCHASEORDERID VARCHAR,
    REVISIONNUMBER VARCHAR DEFAULT '0',
    STATUS VARCHAR DEFAULT '1',
    EMPLOYEEID VARCHAR,
    VENDORID VARCHAR,
    SHIPMETHODID VARCHAR,
    ORDERDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR),
    SHIPDATE VARCHAR,
    SUBTOTAL VARCHAR DEFAULT '0',
    TAXAMT VARCHAR DEFAULT '0',
    FREIGHT VARCHAR DEFAULT '0',
    TOTALDUE VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PURCHASING.SHIPMETHOD (
    SHIPMETHODID VARCHAR,
    NAME VARCHAR,
    SHIPBASE VARCHAR DEFAULT '0',
    SHIPRATE VARCHAR DEFAULT '0',
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.PURCHASING.VENDOR (
    BUSINESSENTITYID VARCHAR,
    ACCOUNTNUMBER VARCHAR,
    NAME VARCHAR,
    CREDITRATING VARCHAR,
    PREFERREDVENDORSTATUS VARCHAR DEFAULT 'TRUE',
    ACTIVEFLAG VARCHAR DEFAULT 'TRUE',
    PURCHASINGWEBSERVICEURL VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace schema ADVENTUREWORKS.SALES COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.COUNTRYREGIONCURRENCY (
    COUNTRYREGIONCODE VARCHAR,
    CURRENCYCODE VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.CREDITCARD (
    CREDITCARDID VARCHAR,
    CARDTYPE VARCHAR,
    CARDNUMBER VARCHAR,
    EXPMONTH VARCHAR,
    EXPYEAR VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.CURRENCY (
    CURRENCYCODE VARCHAR,
    NAME VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.CURRENCYRATE (
    CURRENCYRATEID VARCHAR,
    CURRENCYRATEDATE VARCHAR,
    FROMCURRENCYCODE VARCHAR,
    TOCURRENCYCODE VARCHAR,
    AVERAGERATE VARCHAR,
    ENDOFDAYRATE VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.CUSTOMER (
    CUSTOMERID VARCHAR,
    PERSONID VARCHAR,
    STOREID VARCHAR,
    TERRITORYID VARCHAR,
    ACCOUNTNUMBER VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.PERSONCREDITCARD (
    BUSINESSENTITYID VARCHAR,
    CREDITCARDID VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.SALESORDERDETAIL (
    SALESORDERID VARCHAR,
    SALESORDERDETAILID VARCHAR,
    CARRIERTRACKINGNUMBER VARCHAR,
    ORDERQTY VARCHAR,
    PRODUCTID VARCHAR,
    SPECIALOFFERID VARCHAR,
    UNITPRICE VARCHAR,
    UNITPRICEDISCOUNT VARCHAR DEFAULT '0',
    LINETOTAL VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.SALESORDERHEADER (
    SALESORDERID VARCHAR,
    REVISIONNUMBER VARCHAR DEFAULT '0',
    ORDERDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR),
    DUEDATE VARCHAR,
    SHIPDATE VARCHAR,
    STATUS VARCHAR DEFAULT '1',
    ONLINEORDERFLAG VARCHAR DEFAULT 'TRUE',
    SALESORDERNUMBER VARCHAR,
    PURCHASEORDERNUMBER VARCHAR,
    ACCOUNTNUMBER VARCHAR,
    CUSTOMERID VARCHAR,
    SALESPERSONID VARCHAR,
    TERRITORYID VARCHAR,
    BILLTOADDRESSID VARCHAR,
    SHIPTOADDRESSID VARCHAR,
    SHIPMETHODID VARCHAR,
    CREDITCARDID VARCHAR,
    CREDITCARDAPPROVALCODE VARCHAR,
    CURRENCYRATEID VARCHAR,
    SUBTOTAL VARCHAR DEFAULT '0',
    TAXAMT VARCHAR DEFAULT '0',
    FREIGHT VARCHAR DEFAULT '0',
    TOTALDUE VARCHAR,
    COMMENT VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.SALESORDERHEADERSALESREASON (
    SALESORDERID VARCHAR,
    SALESREASONID VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.SALESPERSON (
    BUSINESSENTITYID VARCHAR,
    TERRITORYID VARCHAR,
    SALESQUOTA VARCHAR,
    BONUS VARCHAR DEFAULT '0',
    COMMISSIONPCT VARCHAR DEFAULT '0',
    SALESYTD VARCHAR DEFAULT '0',
    SALESLASTYEAR VARCHAR DEFAULT '0',
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.SALESPERSONQUOTAHISTORY (
    BUSINESSENTITYID VARCHAR,
    QUOTADATE VARCHAR,
    SALESQUOTA VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.SALESREASON (
    SALESREASONID VARCHAR,
    NAME VARCHAR,
    REASONTYPE VARCHAR,
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.SALESTAXRATE (
    SALESTAXRATEID VARCHAR,
    STATEPROVINCEID VARCHAR,
    TAXTYPE VARCHAR,
    TAXRATE VARCHAR DEFAULT '0',
    NAME VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.SALESTERRITORY (
    TERRITORYID VARCHAR,
    NAME VARCHAR,
    COUNTRYREGIONCODE VARCHAR,
    "GROUP" VARCHAR,
    SALESYTD VARCHAR DEFAULT '0',
    SALESLASTYEAR VARCHAR DEFAULT '0',
    COSTYTD VARCHAR DEFAULT '0',
    COSTLASTYEAR VARCHAR DEFAULT '0',
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.SALESTERRITORYHISTORY (
    BUSINESSENTITYID VARCHAR,
    TERRITORYID VARCHAR,
    STARTDATE VARCHAR,
    ENDDATE VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.SHOPPINGCARTITEM (
    SHOPPINGCARTITEMID VARCHAR,
    SHOPPINGCARTID VARCHAR,
    QUANTITY VARCHAR DEFAULT '1',
    PRODUCTID VARCHAR,
    DATECREATED VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.SPECIALOFFER (
    SPECIALOFFERID VARCHAR,
    DESCRIPTION VARCHAR,
    DISCOUNTPCT VARCHAR DEFAULT '0',
    TYPE VARCHAR,
    CATEGORY VARCHAR,
    STARTDATE VARCHAR,
    ENDDATE VARCHAR,
    MINQTY VARCHAR DEFAULT '0',
    MAXQTY VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.SPECIALOFFERPRODUCT (
    SPECIALOFFERID VARCHAR,
    PRODUCTID VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

create
or replace TABLE ADVENTUREWORKS.SALES.STORE (
    BUSINESSENTITYID VARCHAR,
    NAME VARCHAR,
    SALESPERSONID VARCHAR,
    DEMOGRAPHICS VARCHAR,
    ROWGUID VARCHAR DEFAULT UUID_STRING(),
    MODIFIEDDATE VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
) COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}';

select top 10 * from information_schema.tables;

select get_ddl('DATABASE', 'AdventureWorks', TRUE);

select table_schema, COUNT(*) Table_Count from information_schema.tables
where table_catalog =  'ADVENTUREWORKS' and table_schema <> 'INFORMATION_SCHEMA' and table_type = 'BASE TABLE'
group by table_schema
order by 1;

select * from information_schema.tables
where table_catalog =  'ADVENTUREWORKS' and table_schema = 'PERSON'
order by table_name;

CREATE OR REPLACE TABLE dbo.DatabaseLog (
    DatabaseLogID VARCHAR,
    PostTime VARCHAR,
    DatabaseUser VARCHAR,
    Event VARCHAR,
    "Schema" VARCHAR,
    Object VARCHAR,
    TSQL VARCHAR,
    XmlEvent VARCHAR
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}'
;

CREATE OR REPLACE TABLE HumanResources.JobCandidate (
    JobCandidateID VARCHAR,
    BusinessEntityID VARCHAR,
    Resume VARCHAR,
    ModifiedDate VARCHAR DEFAULT CAST(CURRENT_TIMESTAMP() AS VARCHAR)
)
COMMENT = '{ "origin": "sf_sc", "name": "snowconvert", "version": {  "major": 1,  "minor": 20,  "patch": "10.0" }, "attributes": {  "component": "transact",  "convertedOn": "11/13/2025",  "domain": "gyknife",  "migrationid": "aHyaAYUPyH+Bfvdm7wR0Mw==" }}'
;
