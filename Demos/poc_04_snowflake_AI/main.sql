CREATE DATABASE AI_POC;

CREATE SCHEMA CORTEX_SEARCH;

USE DATABASE AI_POC;

USE SCHEMA CORTEX_SEARCH;

CREATE OR REPLACE WAREHOUSE AI_WAREHOUSE WAREHOUSE_TYPE = 'STANDARD' WAREHOUSE_SIZE = 'X-SMALL' GENERATION = '1' AUTO_SUSPEND = 180
INITIALLY_SUSPENDED = TRUE 
COMMENT = 'This VW is to be used solely for AI-centric PoC work which involves using Snowflake Intelligence, Cortex AI Functions, Cortex Search Agent, Cortex Analyst, Cortex Agent etc.';

CREATE OR REPLACE STAGE book_images
DIRECTORY=(ENABLE=true)
ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE')
COMMENT = 'Stage created for holding image files of screnshots of book pages.';

SHOW STAGES;

LIST @BOOK_IMAGES;

ALTER STAGE BOOK_IMAGES REFRESH;

CREATE OR REPLACE TABLE BOOK_CONTENT_TEXT AS
SELECT
    relative_path as file_name,
    SNOWFLAKE.CORTEX.AI_COMPLETE(
        'claude-3-5-sonnet',
        'Describe this study book page in detail, including all text, formulas, and diagrams.',
        TO_FILE('@book_images', relative_path)
    ) as page_description
FROM DIRECTORY(@BOOK_IMAGES);

SELECT
    *
FROM DIRECTORY(@BOOK_IMAGES);

select * from BOOK_CONTENT_TEXT;

DESCRIBE TABLE BOOK_CONTENT_TEXT;

select top 5 PAGE_DESCRIPTION::VARCHAR from BOOK_CONTENT_TEXT;

/* For 21.PNG, this is what the AI_COMPLETE function coughed up */
"This appears to be a summary page from Chapter 1 of a Marine Insurance textbook. The page contains 11 key points (a through k) summarizing important concepts in marine insurance. Here's a detailed breakdown:\n\na) Explains that under the Marine Insurance Act (MIA), losses can be classified as either total or partial losses.\n\nb) Defines Actual Total Loss as a physical and absolute total loss.\n\nc) Explains Constructive Total Loss as a commercial total loss, where the subject matter isn't necessarily destroyed but commercial total loss has occurred.\n\nd) States that in marine insurance, an insured can abandon subject matter to insurers and claim Constructive Total Loss (CTL).\n\ne) Defines Particular Average as partial loss/damage caused fortuitously by an insured peril, excluding voluntary damage like General Average damage.\n\nf) Explains General Average as a voluntary sacrifice or expenditure that's extraordinary in nature, occurring when the entire adventure is in danger.\n\ng) Outlines the duty of the insured to act as if uninsured and take measures to minimize loss despite being insured.\n\nh) Details the documentation requirements following a general average loss declaration and average adjuster appointment.\n\ni) Defines piracy as forcible robbery at sea, whether committed by outside marauders or by those within the ship.\n\nj) Discusses the debate around ransom payments to pirates, noting that while it's legal under English law, it may be void if connected to terrorism.\n\nk) Explains Marine Delay in Start Up coverage for consequential and pure financial losses arising from Material Damage, Fortuitous events to Land Conveyance, and Uncontrollable Maritime events.\n\nThe text is formatted in a clear, bullet-point style with consistent lettering and indentation, making it easy to read and reference."

ALTER TABLE BOOK_CONTENT_TEXT RENAME COLUMN page_description to page_description_variant;

ALTER TABLE BOOK_CONTENT_TEXT ADD COLUMN page_description_string STRING;

UPDATE BOOK_CONTENT_TEXT SET page_description_string = page_description_variant::VARCHAR;

CREATE OR REPLACE CORTEX SEARCH SERVICE book_search_service
  ON page_description_string
  ATTRIBUTES file_name
  WAREHOUSE = AI_WAREHOUSE
  TARGET_LAG = '30 DAYS' -- Keeps the index updated automatically
  AS (
    SELECT page_description_string, file_name FROM book_content_text
  );

  SELECT SNOWFLAKE.CORTEX.VALIDATE_SEMANTIC_MODEL('@AI_POC.CORTEX_SEARCH.YOUR_STAGE/study_book_model.yaml');