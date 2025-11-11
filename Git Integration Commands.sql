CREATE OR REPLACE SECRET my_git_secret
  TYPE = password
  USERNAME = 'nachiket8188'
  PASSWORD = '_REMOVED';

create or replace API INTEGRATION git_api_integration
API_PROVIDER = git_https_api
API_ALLOWED_PREFIXES = ('https://github.com/nachiket8188')
ALLOWED_AUTHENTICATION_SECRETS = (my_git_secret)
ENABLED = TRUE;

CREATE OR REPLACE GIT REPOSITORY snowflake_practice
API_INTEGRATION = git_api_integration
ORIGIN = 'https://github.com/nachiket8188/snowflake_practice.git'
GIT_CREDENTIALS = my_git_secret;