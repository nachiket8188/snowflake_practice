-- Create a dedicated role for CI/CD, isolated from your personal role
CREATE ROLE IF NOT EXISTS CICD_ROLE;

-- Create a small, auto-suspending warehouse just for pipeline runs
CREATE WAREHOUSE IF NOT EXISTS CICD_WH
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

-- Create the service user with the public key you just generated
CREATE USER IF NOT EXISTS CICD_USER
    RSA_PUBLIC_KEY = '_REMOVED'
    DEFAULT_ROLE = CICD_ROLE
    DEFAULT_WAREHOUSE = CICD_WH
    MUST_CHANGE_PASSWORD = FALSE;

-- Wire it together
GRANT ROLE CICD_ROLE TO USER CICD_USER;
GRANT USAGE ON WAREHOUSE CICD_WH TO ROLE CICD_ROLE;

-- Create a database this role will manage
CREATE DATABASE IF NOT EXISTS DEMO_CICD_DB;
GRANT OWNERSHIP ON DATABASE DEMO_CICD_DB TO ROLE CICD_ROLE;

