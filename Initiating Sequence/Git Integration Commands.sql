/* 
The commands in this worksheet were used to setup Git Integration so that I can keep my previous work
as I switch to the next Trial account of Snowflake.
*/

CREATE OR REPLACE SECRET my_git_secret
  TYPE = password
  USERNAME = 'nachiket8188'
  PASSWORD = '_REMOVED';
  /* 
  The password is not password to the Github account rather a PAT (Personal Access Token) you generate for that       account. 
  */
  
create or replace API INTEGRATION git_api_integration
    API_PROVIDER = git_https_api
    API_ALLOWED_PREFIXES = ('https://github.com/nachiket8188')
    ALLOWED_AUTHENTICATION_SECRETS = (SNOWFLAKE_LEARNING_DB.PUBLIC.MY_GIT_SECRET)
    ENABLED = TRUE;

CREATE OR REPLACE GIT REPOSITORY snowflake_practice
    API_INTEGRATION = git_api_integration
    ORIGIN = 'https://github.com/nachiket8188/snowflake_practice.git'
    GIT_CREDENTIALS = my_git_secret;

select getdate();

describe API INTEGRATION git_api_integration;

SHOW SECRETS;