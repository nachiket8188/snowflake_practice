select localtime();
/* 
By default, Snowflake accounts have their timezone set to 'US/Pacific'.
*/

/* To find out the current timezone for you, create and use following function. */
create or replace function GET_CURRENT_TIMEZONE()
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS
$$
    const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    return timezone;
$$
;

select get_current_timezone();

/* To change the timezone for current session. */
/* To check acceptable values for TIMEZONE, check out - https://data.iana.org/time-zones/tzdb-2025b/zone1970.tab */
ALTER SESSION SET TIMEZONE = 'Asia/Kolkata';

select get_current_timezone();

select localtime();

/* To change the timezone for account (for good). */
ALTER ACCOUNT SET TIMEZONE = 'Asia/Kolkata';

select get_current_timezone();

select localtime();