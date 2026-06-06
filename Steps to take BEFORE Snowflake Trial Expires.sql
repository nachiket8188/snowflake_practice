/* Use the below commands in order to take a proper backup from the soon-to-expire trial Snowflake account. */

/* To check the Git Repo stages you've created. */
SHOW GIT REPOSITORIES IN ACCOUNT;

/* To backup as much as database objects as possible with their DDLs */
/* SELECT GET_DDL('database', 'UTIL_DB', true); */

/* Output of above query for different DBs is pasted below. */

/* 1. NICK_DB_SI : I had created this database and content within it during the hands-on exercise at the Snowflake BUILD event in 2025, which happened in Kharadi. Perhaps going forward it might not be needed. */

create or replace database NICK_DB_SI;

create or replace schema NICK_DB_SI.PUBLIC;

create or replace schema NICK_DB_SI.RETAIL;

create or replace TABLE NICK_DB_SI.RETAIL.MARKETING_CAMPAIGN_METRICS (
	DATE DATE,
	CATEGORY VARCHAR(16777216),
	CAMPAIGN_NAME VARCHAR(16777216),
	IMPRESSIONS NUMBER(38,0),
	CLICKS NUMBER(38,0)
);
create or replace TABLE NICK_DB_SI.RETAIL.PRODUCTS (
	PRODUCT_ID NUMBER(38,0),
	PRODUCT_NAME VARCHAR(16777216),
	CATEGORY VARCHAR(16777216)
);
create or replace TABLE NICK_DB_SI.RETAIL.PRODUCTS_WITH_AVG_PRICE (
	PRODUCT_ID NUMBER(38,0),
	PRODUCT_NAME VARCHAR(16777216),
	CATEGORY VARCHAR(16777216),
	AVG_PRICE NUMBER(38,2)
);
create or replace TABLE NICK_DB_SI.RETAIL.SALES (
	DATE DATE,
	REGION VARCHAR(16777216),
	PRODUCT_ID NUMBER(38,0),
	UNITS_SOLD NUMBER(38,0),
	SALES_AMOUNT NUMBER(38,2)
);
create or replace TABLE NICK_DB_SI.RETAIL.SOCIAL_MEDIA (
	DATE DATE,
	CATEGORY VARCHAR(16777216),
	PLATFORM VARCHAR(16777216),
	INFLUENCER VARCHAR(16777216),
	MENTIONS NUMBER(38,0)
);
create or replace TABLE NICK_DB_SI.RETAIL.SUPPORT_CASES (
	ID VARCHAR(16777216),
	TITLE VARCHAR(16777216),
	PRODUCT VARCHAR(16777216),
	TRANSCRIPT VARCHAR(16777216),
	DATE DATE
);
create or replace view NICK_DB_SI.RETAIL.AVG_PRICE_PER_UNIT_PRODUCT_PER_SALE(
	PRODUCT_ID,
	REGION,
	ROUNDED_AVG_PRICE_PER_UNIT
) as
SELECT 
    PRODUCT_ID,
    REGION,
    RoundToWhole(avg_price_per_unit) AS rounded_avg_price_per_unit
FROM TABLE(AvgPricePerUnitProductPerSale());

CREATE OR REPLACE FILE FORMAT NICK_DB_SI.RETAIL.SWT_CSVFORMAT
	TYPE = csv
	SKIP_HEADER = 1
	FIELD_OPTIONALLY_ENCLOSED_BY = '\"'
;

CREATE OR REPLACE FUNCTION NICK_DB_SI.RETAIL.AVGPRICEPERUNITPRODUCTPERSALE()
RETURNS TABLE ("DATE" DATE, "REGION" VARCHAR, "PRODUCT_ID" NUMBER(38,0), "UNITS_SOLD" NUMBER(38,0), "SALES_AMOUNT" NUMBER(38,2), "AVG_PRICE_PER_UNIT" NUMBER(38,8))
LANGUAGE SQL
AS '
    SELECT 
        DATE,
        REGION,
        PRODUCT_ID,
        UNITS_SOLD,
        SALES_AMOUNT,
        SALES_AMOUNT / UNITS_SOLD AS avg_price_per_unit
    FROM SALES
    WHERE UNITS_SOLD > 0
';

CREATE OR REPLACE FUNCTION NICK_DB_SI.RETAIL.ROUNDTOWHOLE("VALUE" FLOAT)
RETURNS NUMBER(38,0)
LANGUAGE PYTHON
RUNTIME_VERSION = '3.13'
HANDLER = 'round_value'
AS '
def round_value(value):
    if value is None:
        return None
    return round(value, 0)
';

create or replace cortex search service NICK_DB_SI.RETAIL.SUPPORT_CASES
	ON TRANSCRIPT
	attributes TITLE,PRODUCT
	warehouse='COMPUTE_WH'
	target_lag='1 hour'
	refresh_mode=INCREMENTAL
	as (
	SELECT
		ID,
		TITLE,
		PRODUCT,
		TRANSCRIPT,
		DATE
	FROM NICK_DB_SI.RETAIL.SUPPORT_CASES
);

/* 2. ADVENTUREWORKS :  I had created this database for the first few POCs involving Snowflake. Very important and useful scripts.  */

create or replace database ADVENTUREWORKS COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}';

create or replace schema ADVENTUREWORKS.DBO COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}';

create or replace TABLE ADVENTUREWORKS.DBO.AWBUILDVERSION (
	SYSTEMINFORMATIONID NUMBER(38,0) NOT NULL,
	"Database Version" VARCHAR(50) NOT NULL,
	VERSIONDATE TIMESTAMP_NTZ(3) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.DBO.DATABASELOG (
	DATABASELOGID NUMBER(38,0) NOT NULL,
	POSTTIME TIMESTAMP_NTZ(3) NOT NULL,
	DATABASEUSER VARCHAR(128) NOT NULL,
	EVENT VARCHAR(128) NOT NULL,
	"Schema" VARCHAR(128),
	OBJECT VARCHAR(128),
	TSQL VARCHAR(16777216) NOT NULL,
	XMLEVENT VARIANT NOT NULL
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.DBO.ERRORLOG (
	ERRORLOGID NUMBER(38,0) NOT NULL,
	ERRORTIME TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3)),
	USERNAME VARCHAR(128) NOT NULL,
	ERRORNUMBER NUMBER(38,0) NOT NULL,
	ERRORSEVERITY NUMBER(38,0),
	ERRORSTATE NUMBER(38,0),
	ERRORPROCEDURE VARCHAR(252),
	ERRORLINE NUMBER(38,0),
	ERRORMESSAGE VARCHAR(8000) NOT NULL
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace schema ADVENTUREWORKS.HUMANRESOURCES COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}';

create or replace TABLE ADVENTUREWORKS.HUMANRESOURCES.DEPARTMENT (
	DEPARTMENTID NUMBER(38,0) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	GROUPNAME VARCHAR(16777216) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.HUMANRESOURCES.EMPLOYEE (
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	NATIONALIDNUMBER VARCHAR(30) NOT NULL,
	LOGINID VARCHAR(512) NOT NULL,
	ORGANIZATIONNODE VARCHAR(16777216),
	ORGANIZATIONLEVEL NUMBER(38,0),
	JOBTITLE VARCHAR(100) NOT NULL,
	BIRTHDATE DATE NOT NULL,
	MARITALSTATUS VARCHAR(2) NOT NULL,
	GENDER VARCHAR(2) NOT NULL,
	HIREDATE DATE NOT NULL,
	SALARIEDFLAG BOOLEAN NOT NULL DEFAULT TRUE,
	VACATIONHOURS NUMBER(38,0) NOT NULL DEFAULT 0,
	SICKLEAVEHOURS NUMBER(38,0) NOT NULL DEFAULT 0,
	CURRENTFLAG BOOLEAN NOT NULL DEFAULT TRUE,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.HUMANRESOURCES.EMPLOYEEDEPARTMENTHISTORY (
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	DEPARTMENTID NUMBER(38,0) NOT NULL,
	SHIFTID NUMBER(38,0) NOT NULL,
	STARTDATE DATE NOT NULL,
	ENDDATE DATE,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.HUMANRESOURCES.EMPLOYEEPAYHISTORY (
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	RATECHANGEDATE TIMESTAMP_NTZ(3) NOT NULL,
	RATE NUMBER(38,4) NOT NULL,
	PAYFREQUENCY NUMBER(38,0) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.HUMANRESOURCES.JOBCANDIDATE (
	JOBCANDIDATEID NUMBER(38,0) NOT NULL,
	BUSINESSENTITYID NUMBER(38,0),
	RESUME VARIANT,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.HUMANRESOURCES.SHIFT (
	SHIFTID NUMBER(38,0) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	STARTTIME TIME(7) NOT NULL,
	ENDTIME TIME(7) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
CREATE OR REPLACE FILE FORMAT ADVENTUREWORKS.HUMANRESOURCES.FF_EMPLOYEE_CSV
	SKIP_HEADER = 1
	DATE_FORMAT = 'YYYY-MM-DD'
COMMENT='To be used while moving data from the Table Stage @HumanResources.%Employee to corresponding table'
;
create or replace schema ADVENTUREWORKS.PERSON COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}';

create or replace TABLE ADVENTUREWORKS.PERSON.ADDRESS (
	ADDRESSID NUMBER(38,0) NOT NULL,
	ADDRESSLINE1 VARCHAR(120) NOT NULL,
	ADDRESSLINE2 VARCHAR(120),
	CITY VARCHAR(60) NOT NULL,
	STATEPROVINCEID NUMBER(38,0) NOT NULL,
	POSTALCODE VARCHAR(30) NOT NULL,
	SPATIALLOCATION GEOGRAPHY,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PERSON.ADDRESSTYPE (
	ADDRESSTYPEID NUMBER(38,0) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PERSON.BUSINESSENTITY (
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PERSON.BUSINESSENTITYADDRESS (
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	ADDRESSID NUMBER(38,0) NOT NULL,
	ADDRESSTYPEID NUMBER(38,0) NOT NULL,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PERSON.BUSINESSENTITYCONTACT (
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	PERSONID NUMBER(38,0) NOT NULL,
	CONTACTTYPEID NUMBER(38,0) NOT NULL,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PERSON.CONTACTTYPE (
	CONTACTTYPEID NUMBER(38,0) NOT NULL,
	NAME VARIANT NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PERSON.COUNTRYREGION (
	COUNTRYREGIONCODE VARCHAR(6) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PERSON.EMAILADDRESS (
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	EMAILADDRESSID NUMBER(38,0) NOT NULL,
	EMAILADDRESS VARCHAR(100),
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PERSON.PASSWORD (
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	PASSWORDHASH VARCHAR(128) NOT NULL,
	PASSWORDSALT VARCHAR(10) NOT NULL,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PERSON.PERSON (
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	PERSONTYPE VARCHAR(4) NOT NULL,
	NAMESTYLE NUMBER(38,0) NOT NULL DEFAULT 0,
	TITLE VARCHAR(16),
	FIRSTNAME VARCHAR(50) NOT NULL,
	MIDDLENAME VARCHAR(50),
	LASTNAME VARCHAR(50) NOT NULL,
	SUFFIX VARCHAR(20),
	EMAILPROMOTION NUMBER(38,0) NOT NULL DEFAULT 0,
	ADDITIONALCONTACTINFO VARIANT,
	DEMOGRAPHICS VARIANT,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PERSON.PERSONPHONE (
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	PHONENUMBER VARCHAR(16777216) NOT NULL,
	PHONENUMBERTYPEID NUMBER(38,0) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PERSON.PHONENUMBERTYPE (
	PHONENUMBERTYPEID NUMBER(38,0) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PERSON.STATEPROVINCE (
	STATEPROVINCEID NUMBER(38,0) NOT NULL,
	STATEPROVINCECODE VARCHAR(6) NOT NULL,
	COUNTRYREGIONCODE VARCHAR(6) NOT NULL,
	ISONLYSTATEPROVINCEFLAG BOOLEAN NOT NULL DEFAULT TRUE,
	NAME VARCHAR(50) NOT NULL,
	TERRITORYID NUMBER(38,0) NOT NULL,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace schema ADVENTUREWORKS.PRODUCTION COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}';

create or replace TABLE ADVENTUREWORKS.PRODUCTION.BILLOFMATERIALS (
	BILLOFMATERIALSID NUMBER(38,0) NOT NULL,
	PRODUCTASSEMBLYID NUMBER(38,0),
	COMPONENTID NUMBER(38,0) NOT NULL,
	STARTDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3)),
	ENDDATE TIMESTAMP_NTZ(3),
	UNITMEASURECODE VARCHAR(6) NOT NULL,
	BOMLEVEL NUMBER(38,0) NOT NULL,
	PERASSEMBLYQTY NUMBER(8,2) NOT NULL DEFAULT 1,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.CULTURE (
	CULTUREID VARCHAR(12) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.DOCUMENT (
	DOCUMENTNODE VARCHAR(16777216) NOT NULL,
	DOCUMENTLEVEL NUMBER(38,0),
	TITLE VARCHAR(100) NOT NULL,
	OWNER NUMBER(38,0) NOT NULL,
	FOLDERFLAG BOOLEAN NOT NULL DEFAULT FALSE,
	FILENAME VARCHAR(800) NOT NULL,
	FILEEXTENSION VARCHAR(16) NOT NULL,
	REVISION VARCHAR(10) NOT NULL,
	CHANGENUMBER NUMBER(38,0) NOT NULL DEFAULT 0,
	STATUS NUMBER(38,0) NOT NULL,
	DOCUMENTSUMMARY VARCHAR(16777216),
	DOCUMENT BINARY(8388608),
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.ILLUSTRATION (
	ILLUSTRATIONID NUMBER(38,0) NOT NULL,
	DIAGRAM VARIANT,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.LOCATION (
	LOCATIONID NUMBER(38,0) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	COSTRATE NUMBER(38,4) NOT NULL DEFAULT 0,
	AVAILABILITY NUMBER(8,2) NOT NULL DEFAULT 0,
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCT (
	PRODUCTID NUMBER(38,0) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	PRODUCTNUMBER VARCHAR(50) NOT NULL,
	MAKEFLAG BOOLEAN NOT NULL DEFAULT TRUE,
	FINISHEDGOODSFLAG BOOLEAN NOT NULL DEFAULT TRUE,
	COLOR VARCHAR(30),
	SAFETYSTOCKLEVEL NUMBER(38,0) NOT NULL,
	REORDERPOINT NUMBER(38,0) NOT NULL,
	STANDARDCOST NUMBER(38,4) NOT NULL,
	LISTPRICE NUMBER(38,4) NOT NULL,
	SIZE VARCHAR(10),
	SIZEUNITMEASURECODE VARCHAR(6),
	WEIGHTUNITMEASURECODE VARCHAR(6),
	WEIGHT NUMBER(8,2),
	DAYSTOMANUFACTURE NUMBER(38,0) NOT NULL,
	PRODUCTLINE VARCHAR(4),
	CLASS VARCHAR(4),
	STYLE VARCHAR(4),
	PRODUCTSUBCATEGORYID NUMBER(38,0),
	PRODUCTMODELID NUMBER(38,0),
	SELLSTARTDATE TIMESTAMP_NTZ(9) NOT NULL,
	SELLENDDATE TIMESTAMP_NTZ(9),
	DISCONTINUEDDATE TIMESTAMP_NTZ(9),
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTCATEGORY (
	PRODUCTCATEGORYID NUMBER(38,0) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTCOSTHISTORY (
	PRODUCTID NUMBER(38,0) NOT NULL,
	STARTDATE TIMESTAMP_NTZ(3) NOT NULL,
	ENDDATE TIMESTAMP_NTZ(3),
	STANDARDCOST NUMBER(38,4) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTDESCRIPTION (
	PRODUCTDESCRIPTIONID NUMBER(38,0) NOT NULL,
	DESCRIPTION VARCHAR(800) NOT NULL,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTDOCUMENT (
	PRODUCTID NUMBER(38,0) NOT NULL,
	DOCUMENTNODE VARCHAR(16777216) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTINVENTORY (
	PRODUCTID NUMBER(38,0) NOT NULL,
	LOCATIONID NUMBER(38,0) NOT NULL,
	SHELF VARCHAR(20) NOT NULL,
	BIN NUMBER(38,0) NOT NULL,
	QUANTITY NUMBER(38,0) NOT NULL DEFAULT 0,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTLISTPRICEHISTORY (
	PRODUCTID NUMBER(38,0) NOT NULL,
	STARTDATE TIMESTAMP_NTZ(3) NOT NULL,
	ENDDATE TIMESTAMP_NTZ(3),
	LISTPRICE NUMBER(38,4) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTMODEL (
	PRODUCTMODELID NUMBER(38,0) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	CATALOGDESCRIPTION VARCHAR(16777216),
	INSTRUCTIONS VARCHAR(16777216),
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTMODELILLUSTRATION (
	PRODUCTMODELID NUMBER(38,0) NOT NULL,
	ILLUSTRATIONID NUMBER(38,0) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTMODELPRODUCTDESCRIPTIONCULTURE (
	PRODUCTMODELID NUMBER(38,0) NOT NULL,
	PRODUCTDESCRIPTIONID NUMBER(38,0) NOT NULL,
	CULTUREID VARCHAR(12) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTPHOTO (
	PRODUCTPHOTOID NUMBER(38,0) NOT NULL,
	THUMBNAILPHOTO BINARY(8388608),
	THUMBNAILPHOTOFILENAME VARCHAR(100),
	LARGEPHOTO BINARY(8388608),
	LARGEPHOTOFILENAME VARCHAR(100),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTPRODUCTPHOTO (
	PRODUCTID NUMBER(38,0) NOT NULL,
	PRODUCTPHOTOID NUMBER(38,0) NOT NULL,
	"Primary" NUMBER(38,0) NOT NULL DEFAULT 1,
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTREVIEW (
	PRODUCTREVIEWID NUMBER(38,0) NOT NULL,
	PRODUCTID NUMBER(38,0) NOT NULL,
	REVIEWERNAME VARCHAR(16777216) NOT NULL,
	REVIEWDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9)),
	EMAILADDRESS VARCHAR(100) NOT NULL,
	RATING NUMBER(38,0) NOT NULL,
	COMMENTS VARCHAR(7700),
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.PRODUCTSUBCATEGORY (
	PRODUCTSUBCATEGORYID NUMBER(38,0) NOT NULL,
	PRODUCTCATEGORYID NUMBER(38,0) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.SCRAPREASON (
	SCRAPREASONID NUMBER(38,0) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.TRANSACTIONHISTORY (
	TRANSACTIONID NUMBER(38,0) NOT NULL,
	PRODUCTID NUMBER(38,0) NOT NULL,
	REFERENCEORDERID NUMBER(38,0) NOT NULL,
	REFERENCEORDERLINEID NUMBER(38,0) NOT NULL DEFAULT 0,
	TRANSACTIONDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3)),
	TRANSACTIONTYPE VARCHAR(2) NOT NULL,
	QUANTITY NUMBER(38,0) NOT NULL,
	ACTUALCOST NUMBER(38,4) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.TRANSACTIONHISTORYARCHIVE (
	TRANSACTIONID NUMBER(38,0) NOT NULL,
	PRODUCTID NUMBER(38,0) NOT NULL,
	REFERENCEORDERID NUMBER(38,0) NOT NULL,
	REFERENCEORDERLINEID NUMBER(38,0) NOT NULL DEFAULT 0,
	TRANSACTIONDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9)),
	TRANSACTIONTYPE VARCHAR(2) NOT NULL,
	QUANTITY NUMBER(38,0) NOT NULL,
	ACTUALCOST NUMBER(38,4) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.UNITMEASURE (
	UNITMEASURECODE VARCHAR(6) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.WORKORDER (
	WORKORDERID NUMBER(38,0) NOT NULL,
	PRODUCTID NUMBER(38,0) NOT NULL,
	ORDERQTY NUMBER(38,0) NOT NULL,
	STOCKEDQTY NUMBER(38,0) NOT NULL,
	SCRAPPEDQTY NUMBER(38,0) NOT NULL,
	STARTDATE TIMESTAMP_NTZ(3) NOT NULL,
	ENDDATE TIMESTAMP_NTZ(3),
	DUEDATE TIMESTAMP_NTZ(3) NOT NULL,
	SCRAPREASONID NUMBER(38,0),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PRODUCTION.WORKORDERROUTING (
	WORKORDERID NUMBER(38,0) NOT NULL,
	PRODUCTID NUMBER(38,0) NOT NULL,
	OPERATIONSEQUENCE NUMBER(38,0) NOT NULL,
	LOCATIONID NUMBER(38,0) NOT NULL,
	SCHEDULEDSTARTDATE TIMESTAMP_NTZ(3) NOT NULL,
	SCHEDULEDENDDATE TIMESTAMP_NTZ(3) NOT NULL,
	ACTUALSTARTDATE TIMESTAMP_NTZ(3),
	ACTUALENDDATE TIMESTAMP_NTZ(3),
	ACTUALRESOURCEHRS NUMBER(9,4),
	PLANNEDCOST NUMBER(38,4) NOT NULL,
	ACTUALCOST NUMBER(38,4),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace schema ADVENTUREWORKS.PUBLIC;

create or replace TABLE ADVENTUREWORKS.PUBLIC.TEAMS (
	TEAM VARCHAR(16777216)
);
/* create or replace streamlit ADVENTUREWORKS.PUBLIC.MQBF8C9YZ0CBNUX6
	ROOT_LOCATION='snow://workspace/THEDARKPRINCE$.PUBLIC.MQBF8C9YZ0CBNUX6/versions/live'
	main_file='streamlit_app.py'
	query_warehouse='COMPUTE_WH'
	comment='{"lastUpdatedUser":"2687872849961","lastUpdatedTime":1770831467300}'
	title='AdventureWorks Cortex Analyst Demo'; */
create or replace schema ADVENTUREWORKS.PURCHASING COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}';

create or replace TABLE ADVENTUREWORKS.PURCHASING.PRODUCTVENDOR (
	PRODUCTID NUMBER(38,0) NOT NULL,
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	AVERAGELEADTIME NUMBER(38,0) NOT NULL,
	STANDARDPRICE NUMBER(38,4) NOT NULL,
	LASTRECEIPTCOST NUMBER(38,4),
	LASTRECEIPTDATE TIMESTAMP_NTZ(3),
	MINORDERQTY NUMBER(38,0) NOT NULL,
	MAXORDERQTY NUMBER(38,0) NOT NULL,
	ONORDERQTY NUMBER(38,0),
	UNITMEASURECODE VARCHAR(6) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PURCHASING.PURCHASEORDERDETAIL (
	PURCHASEORDERID NUMBER(38,0) NOT NULL,
	PURCHASEORDERDETAILID NUMBER(38,0) NOT NULL,
	DUEDATE TIMESTAMP_NTZ(3) NOT NULL,
	ORDERQTY NUMBER(38,0) NOT NULL,
	PRODUCTID NUMBER(38,0) NOT NULL,
	UNITPRICE NUMBER(38,4) NOT NULL,
	LINETOTAL NUMBER(38,4) NOT NULL,
	RECEIVEDQTY NUMBER(8,2) NOT NULL,
	REJECTEDQTY NUMBER(8,2) NOT NULL,
	STOCKEDQTY NUMBER(9,2) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PURCHASING.PURCHASEORDERHEADER (
	PURCHASEORDERID NUMBER(38,0) NOT NULL,
	REVISIONNUMBER NUMBER(38,0) NOT NULL DEFAULT 0,
	STATUS NUMBER(38,0) NOT NULL DEFAULT 1,
	EMPLOYEEID NUMBER(38,0) NOT NULL,
	VENDORID NUMBER(38,0) NOT NULL,
	SHIPMETHODID NUMBER(38,0) NOT NULL,
	ORDERDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3)),
	SHIPDATE TIMESTAMP_NTZ(3),
	SUBTOTAL NUMBER(38,4) NOT NULL DEFAULT 0,
	TAXAMT NUMBER(38,4) NOT NULL DEFAULT 0,
	FREIGHT NUMBER(38,4) NOT NULL DEFAULT 0,
	TOTALDUE NUMBER(38,4) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PURCHASING.SHIPMETHOD (
	SHIPMETHODID NUMBER(38,0) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	SHIPBASE NUMBER(38,4) NOT NULL DEFAULT 0,
	SHIPRATE NUMBER(38,4) NOT NULL DEFAULT 0,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.PURCHASING.VENDOR (
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	ACCOUNTNUMBER VARCHAR(16777216) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	CREDITRATING NUMBER(38,0) NOT NULL,
	PREFERREDVENDORSTATUS BOOLEAN NOT NULL DEFAULT TRUE,
	ACTIVEFLAG BOOLEAN NOT NULL DEFAULT TRUE,
	PURCHASINGWEBSERVICEURL VARCHAR(16777216),
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace schema ADVENTUREWORKS.SALES COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}';

create or replace TABLE ADVENTUREWORKS.SALES.COUNTRYREGIONCURRENCY (
	COUNTRYREGIONCODE VARCHAR(6) NOT NULL,
	CURRENCYCODE VARCHAR(6) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.CREDITCARD (
	CREDITCARDID NUMBER(38,0) NOT NULL,
	CARDTYPE VARCHAR(100) NOT NULL,
	CARDNUMBER VARCHAR(50) NOT NULL,
	EXPMONTH NUMBER(38,0) NOT NULL,
	EXPYEAR NUMBER(38,0) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.CURRENCY (
	CURRENCYCODE VARCHAR(1) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.CURRENCYRATE (
	CURRENCYRATEID NUMBER(38,0) NOT NULL,
	CURRENCYRATEDATE TIMESTAMP_NTZ(3) NOT NULL,
	FROMCURRENCYCODE VARCHAR(6) NOT NULL,
	TOCURRENCYCODE VARCHAR(6) NOT NULL,
	AVERAGERATE NUMBER(38,4) NOT NULL,
	ENDOFDAYRATE NUMBER(38,4) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.CUSTOMER (
	CUSTOMERID NUMBER(38,0) NOT NULL,
	PERSONID NUMBER(38,0),
	STOREID NUMBER(38,0),
	TERRITORYID NUMBER(38,0),
	ACCOUNTNUMBER VARCHAR(10) NOT NULL,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.PERSONCREDITCARD (
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	CREDITCARDID NUMBER(38,0) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.SALESORDERDETAIL (
	SALESORDERID NUMBER(38,0) NOT NULL,
	SALESORDERDETAILID NUMBER(38,0) NOT NULL,
	CARRIERTRACKINGNUMBER VARCHAR(50),
	ORDERQTY NUMBER(38,0) NOT NULL,
	PRODUCTID NUMBER(38,0) NOT NULL,
	SPECIALOFFERID NUMBER(38,0) NOT NULL,
	UNITPRICE NUMBER(38,4) NOT NULL,
	UNITPRICEDISCOUNT NUMBER(38,4) NOT NULL DEFAULT 0,
	LINETOTAL NUMBER(38,6) NOT NULL,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.SALESORDERHEADER (
	SALESORDERID NUMBER(38,0) NOT NULL,
	REVISIONNUMBER NUMBER(38,0) NOT NULL DEFAULT 0,
	ORDERDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9)),
	DUEDATE TIMESTAMP_NTZ(9) NOT NULL,
	SHIPDATE TIMESTAMP_NTZ(9),
	STATUS NUMBER(38,0) NOT NULL DEFAULT 1,
	ONLINEORDERFLAG BOOLEAN NOT NULL DEFAULT TRUE,
	SALESORDERNUMBER VARCHAR(50) NOT NULL,
	PURCHASEORDERNUMBER VARCHAR(16777216),
	ACCOUNTNUMBER VARCHAR(16777216),
	CUSTOMERID NUMBER(38,0) NOT NULL,
	SALESPERSONID NUMBER(38,0),
	TERRITORYID NUMBER(38,0),
	BILLTOADDRESSID NUMBER(38,0) NOT NULL,
	SHIPTOADDRESSID NUMBER(38,0) NOT NULL,
	SHIPMETHODID NUMBER(38,0) NOT NULL,
	CREDITCARDID NUMBER(38,0),
	CREDITCARDAPPROVALCODE VARCHAR(15),
	CURRENCYRATEID NUMBER(38,0),
	SUBTOTAL NUMBER(38,4) NOT NULL DEFAULT 0,
	TAXAMT NUMBER(38,4) NOT NULL DEFAULT 0,
	FREIGHT NUMBER(38,4) NOT NULL DEFAULT 0,
	TOTALDUE NUMBER(38,4) NOT NULL,
	COMMENT VARCHAR(256),
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.SALESORDERHEADERSALESREASON (
	SALESORDERID NUMBER(38,0) NOT NULL,
	SALESREASONID NUMBER(38,0) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.SALESPERSON (
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	TERRITORYID NUMBER(38,0),
	SALESQUOTA NUMBER(38,4),
	BONUS NUMBER(38,4) NOT NULL DEFAULT 0,
	COMMISSIONPCT NUMBER(38,4) NOT NULL DEFAULT 0,
	SALESYTD NUMBER(38,4) NOT NULL DEFAULT 0,
	SALESLASTYEAR NUMBER(38,4) NOT NULL DEFAULT 0,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.SALESPERSONQUOTAHISTORY (
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	QUOTADATE TIMESTAMP_NTZ(3) NOT NULL,
	SALESQUOTA NUMBER(38,4) NOT NULL,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.SALESREASON (
	SALESREASONID NUMBER(38,0) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	REASONTYPE VARCHAR(16777216) NOT NULL,
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.SALESTAXRATE (
	SALESTAXRATEID NUMBER(38,0) NOT NULL,
	STATEPROVINCEID NUMBER(38,0) NOT NULL,
	TAXTYPE NUMBER(38,0) NOT NULL,
	TAXRATE NUMBER(38,4) NOT NULL DEFAULT 0,
	NAME VARCHAR(16777216) NOT NULL,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.SALESTERRITORY (
	TERRITORYID NUMBER(38,0) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	COUNTRYREGIONCODE VARCHAR(6) NOT NULL,
	"GROUP" VARCHAR(100) NOT NULL,
	SALESYTD NUMBER(38,4) NOT NULL DEFAULT 0,
	SALESLASTYEAR NUMBER(38,4) NOT NULL DEFAULT 0,
	COSTYTD NUMBER(38,4) NOT NULL DEFAULT 0,
	COSTLASTYEAR NUMBER(38,4) NOT NULL DEFAULT 0,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(9) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(9))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.SALESTERRITORYHISTORY (
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	TERRITORYID NUMBER(38,0) NOT NULL,
	STARTDATE TIMESTAMP_NTZ(3) NOT NULL,
	ENDDATE TIMESTAMP_NTZ(3),
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.SHOPPINGCARTITEM (
	SHOPPINGCARTITEMID NUMBER(38,0) NOT NULL,
	SHOPPINGCARTID VARCHAR(100) NOT NULL,
	QUANTITY NUMBER(38,0) NOT NULL DEFAULT 1,
	PRODUCTID NUMBER(38,0) NOT NULL,
	DATECREATED TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3)),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.SPECIALOFFER (
	SPECIALOFFERID NUMBER(38,0) NOT NULL,
	DESCRIPTION VARCHAR(510) NOT NULL,
	DISCOUNTPCT NUMBER(38,4) NOT NULL DEFAULT 0,
	TYPE VARCHAR(100) NOT NULL,
	CATEGORY VARCHAR(100) NOT NULL,
	STARTDATE TIMESTAMP_NTZ(3) NOT NULL,
	ENDDATE TIMESTAMP_NTZ(3) NOT NULL,
	MINQTY NUMBER(38,0) NOT NULL DEFAULT 0,
	MAXQTY NUMBER(38,0),
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.SPECIALOFFERPRODUCT (
	SPECIALOFFERID NUMBER(38,0) NOT NULL,
	PRODUCTID NUMBER(38,0) NOT NULL,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;
create or replace TABLE ADVENTUREWORKS.SALES.STORE (
	BUSINESSENTITYID NUMBER(38,0) NOT NULL,
	NAME VARCHAR(16777216) NOT NULL,
	SALESPERSONID NUMBER(38,0),
	DEMOGRAPHICS VARIANT,
	ROWGUID VARCHAR(16777216) NOT NULL DEFAULT UUID_STRING(),
	MODIFIEDDATE TIMESTAMP_NTZ(3) NOT NULL DEFAULT CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ(3))
)COMMENT='{ \"origin\": \"sf_sc\", \"name\": \"snowconvert\", \"version\": {  \"major\": 1,  \"minor\": 20,  \"patch\": \"10.0\" }, \"attributes\": {  \"component\": \"transact\",  \"convertedOn\": \"11/13/2025\",  \"domain\": \"gyknife\",  \"migrationid\": \"aHyaAYUPyH+Bfvdm7wR0Mw==\" }}'
;

/* 3. AI_POC :  Created this database to create a POC to create a Cortex agent around insurance book content. That is just the first POC. This can be used for many such POCs. */

create or replace database AI_POC;

create or replace schema AI_POC.CORTEX_SEARCH;

create or replace TABLE AI_POC.CORTEX_SEARCH.BOOK_CONTENT_TEXT (
	FILE_NAME VARCHAR(16777216),
	PAGE_DESCRIPTION_VARIANT VARIANT,
	PAGE_DESCRIPTION_STRING VARCHAR(16777216)
);
create or replace cortex search service AI_POC.CORTEX_SEARCH.BOOK_SEARCH_SERVICE
	ON PAGE_DESCRIPTION_STRING
	attributes FILE_NAME
	warehouse='COMPUTE_WH'
	target_lag='30 days'
	refresh_mode=INCREMENTAL
	as (
    SELECT page_description_string, file_name FROM book_content_text
  );
create or replace schema AI_POC.PUBLIC;

/* 4. INTERVIEW_PREP : I created this database and objects within it to prepare for interview-related SQL questions surrounding data analysis, window functions, etc. The scripts which reference objects created within this database can be located in "Some DA related practice statements" worksheet.  */

create or replace database INTERVIEW_PREP;

create or replace schema INTERVIEW_PREP.DATA_ANALYSIS;

create or replace TABLE INTERVIEW_PREP.DATA_ANALYSIS.EMPLOYEES (
	EMP_ID NUMBER(38,0),
	EMP_NAME VARCHAR(16777216),
	DEPT VARCHAR(16777216),
	SALARY NUMBER(38,0)
);
create or replace TABLE INTERVIEW_PREP.DATA_ANALYSIS.LOGIN_DATES (
	CUSTOMER_ID NUMBER(38,0),
	LOGIN_DATE DATE
);
create or replace TABLE INTERVIEW_PREP.DATA_ANALYSIS.MONTHLY_SALES (
	EMPID NUMBER(38,0),
	AMOUNT NUMBER(38,0),
	MONTH VARCHAR(3)
);
create or replace TABLE INTERVIEW_PREP.DATA_ANALYSIS.ORDERS (
	ORDER_ID NUMBER(38,0),
	CUSTOMER_ID NUMBER(38,0),
	ORDER_DATE DATE,
	AMOUNT NUMBER(10,2)
);
create or replace TABLE INTERVIEW_PREP.DATA_ANALYSIS.ORDERS_DIFF (
	ORDER_ID NUMBER(38,0),
	CUSTOMER_ID NUMBER(38,0),
	ORDER_DATE DATE,
	AMOUNT NUMBER(38,0)
);
create or replace TABLE INTERVIEW_PREP.DATA_ANALYSIS.PRODUCTS (
	CATEGORY VARCHAR(16777216),
	PRODUCT VARCHAR(16777216),
	SALES NUMBER(38,0)
);
create or replace TABLE INTERVIEW_PREP.DATA_ANALYSIS.PRODUCT_SALES (
	REPORT_DATE VARCHAR(12),
	PRODUCT_ID NUMBER(38,0),
	VALUE FLOAT
);
create or replace TABLE INTERVIEW_PREP.DATA_ANALYSIS.PURCHASES (
	CUSTOMER_ID NUMBER(38,0),
	PRODUCT_ID VARCHAR(10),
	PURCHASE_DATE DATE
);
create or replace TABLE INTERVIEW_PREP.DATA_ANALYSIS.SALES (
	CUSTOMER_ID NUMBER(38,0),
	SALE_DATE DATE,
	AMOUNT NUMBER(38,0)
);

/*
create or replace streamlit INTERVIEW_PREP.DATA_ANALYSIS.MN0T1CXDQCC1267M/versions/live'
	main_file='streamlit_app.py'
	query_warehouse='COMPUTE_WH'
	comment='{"lastUpdatedUser":"2687872849961","lastUpdatedTime":1765907661104}'
	title='My First Streamlit App within Snowflake';
*/

create or replace schema INTERVIEW_PREP.PUBLIC;

/* 5. SNOWFLAKE_PRACTICE_DEV :  This database was created to facilitate the POCs surrounding Snowflake purely. Specifically, like POC 1 and POC 2. It should be used in future for similar purposes.  */

create or replace database SNOWFLAKE_PRACTICE_DEV;

create or replace schema SNOWFLAKE_PRACTICE_DEV.ANALYTICS;

create or replace schema SNOWFLAKE_PRACTICE_DEV.CORE;

create or replace schema SNOWFLAKE_PRACTICE_DEV.RAW;

create or replace TABLE SNOWFLAKE_PRACTICE_DEV.RAW.CUSTOMERS_RAW (
	CUSTOMER_ID VARCHAR(16777216),
	CUSTOMER_NAME VARCHAR(16777216),
	EMAIL VARCHAR(16777216),
	COUNTRY VARCHAR(16777216),
	CREATED_DATE VARCHAR(16777216),
	_FILENAME VARCHAR(16777216),
	_INGESTDATE TIMESTAMP_NTZ(9) DEFAULT CURRENT_TIMESTAMP()
);
create or replace TABLE SNOWFLAKE_PRACTICE_DEV.RAW.INGESTION_CONFIG (
	SOURCE_NAME VARCHAR(16777216),
	FILE_FORMAT VARCHAR(16777216),
	TARGET_TABLE_NAME VARCHAR(16777216),
	S3_FOLDER_PATH VARCHAR(16777216),
	ENABLED BOOLEAN
);
create or replace TABLE SNOWFLAKE_PRACTICE_DEV.RAW.ORDERS_RAW (
	ORDER_ID VARCHAR(16777216),
	CUSTOMER_ID VARCHAR(16777216),
	ORDER_DATE VARCHAR(16777216),
	ORDER_AMOUNT VARCHAR(16777216),
	STATUS VARCHAR(16777216),
	_FILENAME VARCHAR(16777216),
	_INGESTDATE TIMESTAMP_NTZ(9) DEFAULT CURRENT_TIMESTAMP()
);
create or replace TABLE SNOWFLAKE_PRACTICE_DEV.RAW.PAYMENTS_RAW (
	PAYMENT_ID VARCHAR(16777216),
	ORDER_ID VARCHAR(16777216),
	PAYMENT_DATE VARCHAR(16777216),
	PAYMENT_METHOD VARCHAR(16777216),
	AMOUNT VARCHAR(16777216),
	_FILENAME VARCHAR(16777216),
	_INGESTDATE TIMESTAMP_NTZ(9) DEFAULT CURRENT_TIMESTAMP()
);
create or replace TABLE SNOWFLAKE_PRACTICE_DEV.RAW.PRODUCTS_RAW (
	PRODUCT_ID VARCHAR(16777216),
	PRODUCT_NAME VARCHAR(16777216),
	CATEGORY VARCHAR(16777216),
	PRICE VARCHAR(16777216),
	_FILENAME VARCHAR(16777216),
	_INGESTDATE TIMESTAMP_NTZ(9) DEFAULT CURRENT_TIMESTAMP()
);
create or replace TABLE SNOWFLAKE_PRACTICE_DEV.RAW.SHIPMENTS_RAW (
	SHIPMENT_ID VARCHAR(16777216),
	ORDER_ID VARCHAR(16777216),
	SHIPMENT_DATE VARCHAR(16777216),
	STATUS VARCHAR(16777216),
	_FILENAME VARCHAR(16777216),
	_INGESTDATE TIMESTAMP_NTZ(9) DEFAULT CURRENT_TIMESTAMP()
);
create or replace view SNOWFLAKE_PRACTICE_DEV.RAW.MARKED_RUNNING_QUERIES(
	QUERY_ID,
	QUERY_TEXT,
	DATABASE_NAME,
	SCHEMA_NAME,
	QUERY_TYPE,
	USER_NAME,
	ROLE_NAME,
	WAREHOUSE_NAME,
	WAREHOUSE_SIZE,
	WAREHOUSE_TYPE,
	EXECUTION_STATUS,
	START_TIME,
	END_TIME,
	TOTAL_ELAPSED_TIME,
	EXECUTION_TIME,
	ACTUAL_EXECUTION_TIME,
	MARKED_FLAG
) as
select
    query_id,
    query_text,
    database_name,
    schema_name,
    query_type,
    user_name,
    role_name,
    warehouse_name,
    warehouse_size,
    warehouse_type,
    execution_status,
    start_time,
    end_time,
    total_elapsed_time,
    execution_time,
    TIMEDIFF('MINUTES', start_time, current_timestamp()) as actual_execution_time,
    /* For RUNNING queries, the end_time shows as Shows a UNIX epoch timestamp (e.g., 1970-01-01). Therefore, we need to use current_timestamp() */
    CASE WHEN actual_execution_time >= 15 THEN 'Y' ELSE 'N' END MARKED_FLAG
from
    TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
where
    execution_status = 'RUNNING'
order by
    start_time desc;
create or replace view SNOWFLAKE_PRACTICE_DEV.RAW.WH_DAILY_COST(
	DATE,
	WAREHOUSE_ID,
	WAREHOUSE_NAME,
	CREDITS_USED,
	CREDITS_USED_COMPUTE,
	CREDITS_USED_CLOUD_SERVICES,
	CREDITS_ATTRIBUTED_COMPUTE_QUERIES
) as
SELECT
    TO_DATE(start_time) date,
    warehouse_id,
    warehouse_name,
    SUM(credits_used) credits_used,
    SUM(credits_used_compute) credits_used_compute,
    SUM(credits_used_cloud_services) credits_used_cloud_services,
    SUM(credits_attributed_compute_queries) credits_attributed_compute_queries
FROM
    SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
GROUP BY
    date,
    warehouse_id,
    warehouse_name
ORDER BY
    date,
    credits_used desc;
create or replace view SNOWFLAKE_PRACTICE_DEV.RAW.WH_MONTHLY_COST(
	MONTH,
	MONTH_YYYY_MM,
	WAREHOUSE_ID,
	WAREHOUSE_NAME,
	CREDITS_USED,
	CREDITS_USED_COMPUTE,
	CREDITS_USED_CLOUD_SERVICES,
	CREDITS_ATTRIBUTED_COMPUTE_QUERIES
) as
SELECT
    TO_CHAR(start_time, 'Mon-YY') Month,
    TO_CHAR(start_time, 'YYYY-MM') month_yyyy_mm,
    warehouse_id,
    warehouse_name,
    SUM(credits_used) credits_used,
    SUM(credits_used_compute) credits_used_compute,
    SUM(credits_used_cloud_services) credits_used_cloud_services,
    SUM(credits_attributed_compute_queries) credits_attributed_compute_queries
FROM
    SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
GROUP BY
    month,
    warehouse_id,
    warehouse_name,
    month_yyyy_mm
ORDER BY
    month_yyyy_mm,
    credits_used desc;
CREATE OR REPLACE FILE FORMAT SNOWFLAKE_PRACTICE_DEV.RAW.FF_CSV_CUSTOMERS
	PARSE_HEADER = TRUE
	ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
	SKIP_BLANK_LINES = TRUE
;
CREATE OR REPLACE FILE FORMAT SNOWFLAKE_PRACTICE_DEV.RAW.FF_CSV_ORDERS
	PARSE_HEADER = TRUE
	ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
	SKIP_BLANK_LINES = TRUE
;
CREATE OR REPLACE FILE FORMAT SNOWFLAKE_PRACTICE_DEV.RAW.FF_CSV_PAYMENTS
	PARSE_HEADER = TRUE
	ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
	SKIP_BLANK_LINES = TRUE
;
CREATE OR REPLACE FILE FORMAT SNOWFLAKE_PRACTICE_DEV.RAW.FF_CSV_PRODUCTS
	PARSE_HEADER = TRUE
	ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
	SKIP_BLANK_LINES = TRUE
;
CREATE OR REPLACE FILE FORMAT SNOWFLAKE_PRACTICE_DEV.RAW.FF_CSV_SHIPMENTS
	PARSE_HEADER = TRUE
	ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
	SKIP_BLANK_LINES = TRUE
;
CREATE OR REPLACE PROCEDURE SNOWFLAKE_PRACTICE_DEV.RAW.SP_CHECK_FOR_QUERIES()
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS CALLER
AS 'DECLARE
    row_count INTEGER DEFAULT 0;
BEGIN
    SELECT COUNT(*) INTO :row_count from marked_running_queries where MARKED_FLAG = ''Y'';
    IF (row_count = 0) THEN
        CALL SYSTEM$SET_RETURN_VALUE(''SKIP'');
    ELSE
        CALL SYSTEM$SET_RETURN_VALUE(''RUN_KILL'');
        RETURN ''Queries found. Triggering kill task.'';
    END IF;
END';
CREATE OR REPLACE PROCEDURE SNOWFLAKE_PRACTICE_DEV.RAW.SP_COPY_INTO_DYNAMIC("TABLE_LIST_ARRAY" ARRAY DEFAULT null)
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS OWNER
AS 'DECLARE
        current_db varchar(24);
        current_schem varchar(10);
        res RESULTSET;
        source_name varchar(500);
        file_format varchar(500);
        enabled boolean;
        target_table_name varchar(500);
        s3_folder_path varchar(500);
        sql_command varchar(2000);
        /* invalid_ip_exception EXCEPTION (-20002, ''Raised invalid_ip_exception.''); */
        /* Commenting line above as the EXCEPTION is not used below. */
BEGIN
    select current_database(), current_schema() into :current_db, :current_schem; /* Not really required as I am setting the context at the beginning of the script itself. */
    IF (:table_list_array is NULL) THEN /* Load into ALL ENABLEd sources within INGESTION_CONFIG. */
        let cur1 CURSOR FOR select source_name, file_format, target_table_name, s3_folder_path, enabled from INGESTION_CONFIG; --
        FOR record in cur1 DO
           source_name := record.source_name;
           file_format := record.file_format;
           enabled := record.enabled;
           target_table_name := record.target_table_name;
           s3_folder_path := record.s3_folder_path;
           IF (enabled = TRUE) THEN 
           /* Creating a Dynamic SQL statement is more generic and need not be Snowflake-specific. Also, binding variables was causing one              issue after another. Dynamic SQL took less time to implement. */
                sql_command := ''COPY INTO '' || target_table_name || 
                               '' FROM @EXT_STAGE_FOR_POC_01/'' || source_name || ''/'' ||  
                               '' INCLUDE_METADATA = (_FILENAME = METADATA$FILENAME, _INGESTDATE = METADATA$START_SCAN_TIME)
                                 FILE_FORMAT = (FORMAT_NAME = '' || file_format || 
                               '')'' || '' MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
                '';
                execute immediate :sql_command;
            ELSE
                CONTINUE;
            END IF;
        END FOR;
        CLOSE cur1;
    ELSE /* Load into ONLY REQUESTED ENABLEd sources within INGESTION_CONFIG. */
        /* IF(IS_ARRAY(table_list_array::VARIANT) = FALSE) THEN
            RAISE invalid_ip_exception;
        END IF;
        */
        /* No need to handle this particular type of EXCEPTION as checking the type of INPUT parameter is taken care of in the declaration part of SP itself.*/
        res := (SELECT source_name, file_format, target_table_name, enabled 
                FROM INGESTION_CONFIG
                WHERE source_name IN (SELECT value::string FROM TABLE(FLATTEN(INPUT => :table_list_array))));
        FOR record in res DO
           source_name := record.source_name;
           file_format := record.file_format;
           enabled := record.enabled;
           target_table_name := record.target_table_name;
           IF (enabled = TRUE) THEN
                    sql_command := ''COPY INTO '' || target_table_name || 
                                   '' FROM @EXT_STAGE_FOR_POC_01/'' || source_name || ''/'' ||  
                                   '' INCLUDE_METADATA = (_FILENAME = METADATA$FILENAME, _INGESTDATE = METADATA$START_SCAN_TIME)
                                     FILE_FORMAT = (FORMAT_NAME = '' || file_format || 
                                   '')'' || '' MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
                    '';
                execute immediate :sql_command;
            ELSE
                CONTINUE;
            END IF;
        END FOR;
    END IF;
    RETURN ''Success !!'';
END';
CREATE OR REPLACE PROCEDURE SNOWFLAKE_PRACTICE_DEV.RAW.SP_KILL_QUERY()
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS CALLER
AS 'DECLARE
    rs RESULTSET DEFAULT (select 
                            query_id,
                            query_text,
                            database_name,
                            schema_name,
                            query_type,
                            user_name,
                            role_name,
                            warehouse_name,
                            warehouse_size,
                            warehouse_type,
                            execution_status,
                            start_time,
                            end_time,
                            total_elapsed_time,
                            execution_time,
                            actual_execution_time,
                            MARKED_FLAG
                        from marked_running_queries
                        where MARKED_FLAG = ''Y''
                        );
    query_id varchar(400);
BEGIN
    FOR record IN rs DO
        query_id := record.query_id;
        SELECT SYSTEM$CANCEL_QUERY(:query_id);
    END FOR;
RETURN ''Success !!'';
END';
create or replace pipe SNOWFLAKE_PRACTICE_DEV.RAW.MYPIPE_FOR_SNOWPIPE_DEMO auto_ingest=true as COPY INTO SNOWFLAKE_PRACTICE_DEV.RAW.SUPERSTORE_SALES
  FROM @s2_stage_for_snowpipe;
create or replace task SNOWFLAKE_PRACTICE_DEV.RAW.T_CHECK_MARKED_QUERIES
	schedule='30 MINUTES'
	as CALL sp_check_for_queries();
create or replace task SNOWFLAKE_PRACTICE_DEV.RAW.T_EXECUTE_QUERY_KILL
	warehouse=COMPUTE_WH
	after SNOWFLAKE_PRACTICE_DEV.RAW.T_CHECK_MARKED_QUERIES
	when SYSTEM$GET_PREDECESSOR_RETURN_VALUE('SP_CHECK_FOR_QUERIES') = 'RUN_KILL'
	as CALL SP_KILL_QUERY();

/* 6. SNOWFLAKE_PRACTICE_QA : This database was created by cloning from SNOWFLAKE_PRACTICE_DEV, I believe. This database and the SNOWFLAKE_PRACTICE_PROD database were created to mimic environments in Snowflake accounts set up in real companies to practice code promotion and so on. */

create or replace database SNOWFLAKE_PRACTICE_QA;

create or replace schema SNOWFLAKE_PRACTICE_QA.ANALYTICS;

create or replace schema SNOWFLAKE_PRACTICE_QA.CORE;

create or replace schema SNOWFLAKE_PRACTICE_QA.RAW;

create or replace pipe SNOWFLAKE_PRACTICE_QA.RAW.MYPIPE_FOR_SNOWPIPE_DEMO auto_ingest=true as COPY INTO SNOWFLAKE_PRACTICE.PUBLIC.SUPERSTORE_SALES
  FROM @s2_stage_for_snowpipe;


/* 7. SNOWFLAKE_PRACTICE_PROD : This database was created by cloning from SNOWFLAKE_PRACTICE_DEV, I believe. This database and the SNOWFLAKE_PRACTICE_QA database were created to mimic environments in Snowflake accounts set up in real companies to practice code promotion and so on. */

create or replace database SNOWFLAKE_PRACTICE_PROD;

create or replace schema SNOWFLAKE_PRACTICE_PROD.ANALYTICS;

create or replace schema SNOWFLAKE_PRACTICE_PROD.CORE;

create or replace schema SNOWFLAKE_PRACTICE_PROD.RAW;

create or replace pipe SNOWFLAKE_PRACTICE_PROD.RAW.MYPIPE_FOR_SNOWPIPE_DEMO auto_ingest=true as COPY INTO SNOWFLAKE_PRACTICE.PUBLIC.SUPERSTORE_SALES
  FROM @s2_stage_for_snowpipe;

/* 8. UTIL_DB :  This database was created during the 2025 Snowflake Build event. It holds the API integration for DORA assessment among other things. */

/*

create or replace database UTIL_DB;

create or replace schema UTIL_DB.PUBLIC;

CREATE OR REPLACE EXTERNAL FUNCTION UTIL_DB.PUBLIC.GRADER("STEP" VARCHAR, "PASSED" BOOLEAN, "ACTUAL" NUMBER(38,0), "EXPECTED" NUMBER(38,0), "DESCRIPTION" VARCHAR)
RETURNS VARIANT
API_INTEGRATION = "DORA_API_INTEGRATION"
CONTEXT_HEADERS = (CURRENT_TIMESTAMP,CURRENT_ACCOUNT,CURRENT_STATEMENT,CURRENT_ACCOUNT_NAME)
AS 'https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora/grader';
CREATE OR REPLACE EXTERNAL FUNCTION UTIL_DB.PUBLIC.GREETING("EMAIL" VARCHAR, "FIRSTNAME" VARCHAR, "MIDDLENAME" VARCHAR, "LASTNAME" VARCHAR)
RETURNS VARIANT
API_INTEGRATION = "DORA_API_INTEGRATION"
CONTEXT_HEADERS = (CURRENT_TIMESTAMP,CURRENT_ACCOUNT,CURRENT_STATEMENT,CURRENT_ACCOUNT_NAME)
AS 'https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora/greeting';

*/

-- Network policies, resource monitors, warehouses, roles, users
SHOW INTEGRATIONS;
SHOW STAGES IN ACCOUNT;
SHOW FILE FORMATS IN ACCOUNT;
SHOW WAREHOUSES;
SHOW RESOURCE MONITORS;
SHOW NETWORK POLICIES;
SHOW ROLES;

-- Then GET_DDL on the ones that matter

-- Generate COPY INTO statements for every table in a schema

CREATE STAGE my_backup_stage;

/* So, new learning: when you query a view like TABLES, COLUMNS from INFORMATION_SCHEMA, it will only return the results or rows that are contained within the current database in the context. That is why the dynamic SELECT statement that we are trying to create below to generate COPY INTO commands for each table, will have to run within each DB separately; it won't work with one go. See if there's a way you can use account_usage_schema to identify the table names at account level and not database level. */

SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' ORDER BY ROW_COUNT DESC;

SELECT 
  'COPY INTO @my_backup_stage/' || table_name || '/ FROM ' || 
  table_schema || '.' || table_name || 
  ' FILE_FORMAT = (TYPE = PARQUET);' AS copy_statement
FROM information_schema.tables
WHERE table_catalog = 'INTERVIEW_PREP'
  AND table_type = 'BASE TABLE';

COPY INTO @my_backup_stage/PURCHASES/ FROM DATA_ANALYSIS.PURCHASES FILE_FORMAT = (TYPE = PARQUET);
COPY INTO @my_backup_stage/ORDERS_DIFF/ FROM DATA_ANALYSIS.ORDERS_DIFF FILE_FORMAT = (TYPE = PARQUET);
COPY INTO @my_backup_stage/MONTHLY_SALES/ FROM DATA_ANALYSIS.MONTHLY_SALES FILE_FORMAT = (TYPE = PARQUET);
COPY INTO @my_backup_stage/ORDERS/ FROM DATA_ANALYSIS.ORDERS FILE_FORMAT = (TYPE = PARQUET);
COPY INTO @my_backup_stage/PRODUCTS/ FROM DATA_ANALYSIS.PRODUCTS FILE_FORMAT = (TYPE = PARQUET);
COPY INTO @my_backup_stage/LOGIN_DATES/ FROM DATA_ANALYSIS.LOGIN_DATES FILE_FORMAT = (TYPE = PARQUET);
COPY INTO @my_backup_stage/EMPLOYEES/ FROM DATA_ANALYSIS.EMPLOYEES FILE_FORMAT = (TYPE = PARQUET);
COPY INTO @my_backup_stage/SALES/ FROM DATA_ANALYSIS.SALES FILE_FORMAT = (TYPE = PARQUET);
COPY INTO @my_backup_stage/PRODUCT_SALES/ FROM DATA_ANALYSIS.PRODUCT_SALES FILE_FORMAT = (TYPE = PARQUET);

/* Basically, what we are doing above is generating a COPY INTO statement to copy data from each desired table into its respective folder within a named internal stage. After that the command from below can be run using Snowflake CLI tool, which is not the same thing as Snow SQL, to automatically download all the files from this stage to some local location.  */

/*  Thanks to the recursive flag in the command, Snowflake CLI will create the directory structure within the stage in the destination folder locally. */

snow stage copy @my_backup_stage/ . --recursive --connection trial_acct_1;

SELECT *, TOKEN_CREDITS AS TOTAL_CREDITS
FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_CODE_SNOWSIGHT_USAGE_HISTORY
WHERE USAGE_TIME >= DATEADD('day', -1, CURRENT_TIMESTAMP())
ORDER BY TOTAL_CREDITS DESC;