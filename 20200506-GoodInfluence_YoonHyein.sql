-- -- SQLite
-- -- [MAKE TABLES]


-- CREATE TABLE BENEFIT_MENU
-- (
--   MENTYPE_ID TEXT NOT NULL,
--   MENU_TYPE  TEXT NULL    ,
--   PRIMARY KEY (MENTYPE_ID)
-- );

-- CREATE TABLE BENEFIT_PERSONELL
-- (
--   PERSONELL_ID        TEXT NOT NULL,
--   AMOUNT_OF_PERSONELL TEXT NULL    ,
--   PRIMARY KEY (PERSONELL_ID)
-- );

-- CREATE TABLE BENEFIT_RECEIVER
-- (
--   RECEIVER_ID TEXT NOT NULL,
--   RECEIVER    TEXT NULL    ,
--   PRIMARY KEY (RECEIVER_ID)
-- );

-- CREATE TABLE DONATION_GENERAL
-- (
--   PARTICIPATE_ID TEXT NOT NULL,
--   PATICIPATION   TEXT NULL    ,
--   PRIMARY KEY (PARTICIPATE_ID)
-- );

-- CREATE TABLE GOOD_STORE
-- (
--   STORE_ID       FLOAT NOT NULL,
--   STORE_NAME     TEXT  NULL    ,
--   OWNER          TEXT  NULL    ,
--   TEL            FLOAT NULL    ,
--   ADDRESS        TEXT  NULL    ,
--   PROVINCE_ID    TEXT  NOT NULL,
--   OPR_TIME      TEXT  NOT NULL,
--   PERSONELL_ID   TEXT  NOT NULL,
--   PARTICIPATE_ID TEXT  NOT NULL,
--   MENTYPE_ID     TEXT  NOT NULL,
--   DONATION_ID     TEXT NOT NULL,  
--   PRIMARY KEY (STORE_ID),
-- CONSTRAINT FK_LOCATION_TO_GOOD_STORE
--     FOREIGN KEY (PROVINCE_ID)
--     REFERENCES LOCATION (PROVINCE_ID),
-- CONSTRAINT FK_OPERATING_TIME_TO_GOOD_STORE
--     FOREIGN KEY (OPR_TIME)
--     REFERENCES OPERATING_TIME (OPR_TIME),
-- CONSTRAINT FK_BENEFIT_PERSONELL_TO_GOOD_STORE
--     FOREIGN KEY (PERSONELL_ID)
--     REFERENCES BENEFIT_PERSONELL (PERSONELL_ID),
-- CONSTRAINT FK_DONATION_GENERAL_TO_GOOD_STORE
--     FOREIGN KEY (PARTICIPATE_ID)
--     REFERENCES DONATION_GENERAL (PARTICIPATE_ID),
-- CONSTRAINT FK_BENEFIT_MENU_TO_GOOD_STORE
--     FOREIGN KEY (MENTYPE_ID)
--     REFERENCES BENEFIT_MENU (MENTYPE_ID),
-- CONSTRAINT FK_ROUTINAL_DONATION_TO_GOOD_STORE
--     FOREIGN KEY (DONATION_ID)
--     REFERENCES ROUTINAL_DONATION (DONATION_ID)    
-- );

-- CREATE TABLE LOCATION
-- (
--   PROVINCE_ID   TEXT NOT NULL,
--   PROVINCE_NAME TEXT NULL    ,
--   PRIMARY KEY (PROVINCE_ID)
-- );

-- CREATE TABLE OPERATING_TIME
-- (
--   OPR_TIME TEXT NOT NULL,
--   PRIMARY KEY (OPR_TIME)
-- );

-- CREATE TABLE ROUTINAL_DONATION
-- (
--   DONATION_ID     TEXT NOT NULL,
--   DONATION_AMOUNT TEXT NULL    ,
--   PRIMARY KEY (DONATION_ID)
-- );

-- CREATE TABLE STORE_RECEIVER
-- (
--   STORE_ID    FLOAT NOT NULL,
--   RECEIVER_ID TEXT  NOT NULL,
-- CONSTRAINT FK_GOOD_STORE_TO_STORE_RECEIVER
--     FOREIGN KEY (STORE_ID)
--     REFERENCES GOOD_STORE (STORE_ID),
-- CONSTRAINT FK_BENEFIT_RECEIVER_TO_STORE_RECEIVER
--     FOREIGN KEY (RECEIVER_ID)
--     REFERENCES BENEFIT_RECEIVER (RECEIVER_ID)
-- );



-- [INSERT VALUES INTO TABLES]


-- LOCATION TABLE
INSERT INTO LOCATION (PROVINCE_ID,PROVINCE_NAME)
SELECT ROWID, 지역
FROM GOODINF_TABLE
GROUP BY 지역;


-- ROUTINAL_DONATION TABLE
UPDATE goodinf_table
SET 월정기후원 = '없음'
WHERE 월정기후원 IS NULL OR 월정기후원 = '차후 후원예정' OR 월정기후원 = '아직 매출이 마이너스라 나중에 참여할께요...꼭!이요' OR 월정기후원 = '차후 법인의 사업방향 안내를 받고 후원에 참여하고 싶습니다';

SELECT DISTINCT 월정기후원, ROWID
FROM goodinf_table
GROUP BY 월정기후원;

INSERT INTO ROUTINAL_DONATION (DONATION_ID, DONATION_AMOUNT)
SELECT ROWID, 월정기후원 
FROM goodinf_table
GROUP BY 월정기후원;

-- BENEFIT_MENU TABLE
SELECT DISTINCT 제공품목_전메뉴or일부한정상품등, ROWID
FROM goodinf_table
GROUP BY 제공품목_전메뉴or일부한정상품등;

SELECT DISTINCT 제공품목_전메뉴or일부한정상품등
FROM goodinf_table
WHERE 제공품목_전메뉴or일부한정상품등 NOT LIKE '전메뉴'
AND 제공품목_전메뉴or일부한정상품등 IS NOT NULL;

UPDATE goodinf_table
SET 제공품목_전메뉴or일부한정상품등 = '전메뉴'
WHERE 제공품목_전메뉴or일부한정상품등 NOT LIKE '%제외%'
AND 제공품목_전메뉴or일부한정상품등 NOT LIKE '%이내%'
AND 제공품목_전메뉴or일부한정상품등 LIKE '%모든%무상%'
OR 제공품목_전메뉴or일부한정상품등 LIKE '%모든%무료%%'
OR 제공품목_전메뉴or일부한정상품등 LIKE '%모든%메뉴%'
OR 제공품목_전메뉴or일부한정상품등 LIKE '%전%메뉴%무료%'
OR 제공품목_전메뉴or일부한정상품등 LIKE '%전%메뉴%무상%'
OR 제공품목_전메뉴or일부한정상품등 LIKE '%전%메뉴%가격 제한 없음%';

UPDATE goodinf_table
SET 제공품목_전메뉴or일부한정상품등 = '전메뉴'
WHERE 제공품목_전메뉴or일부한정상품등 LIKE '%식사%무상%'
AND ROWID IN (137, 223, 371, 379, 468)
OR 제공품목_전메뉴or일부한정상품등 LIKE '%전메뉴%'
AND ROWID IN (207, 246, 1, 287, 423)
OR 제공품목_전메뉴or일부한정상품등 LIKE '%전메뉴 ';

UPDATE goodinf_table
SET 제공품목_전메뉴or일부한정상품등 = '일부메뉴'
WHERE 제공품목_전메뉴or일부한정상품등 NOT LIKE '전메뉴'
AND 제공품목_전메뉴or일부한정상품등 IS NOT NULL;

INSERT INTO BENEFIT_MENU (MENTYPE_ID, MENU_TYPE)
SELECT DISTINCT ROWID, 제공품목_전메뉴or일부한정상품등
FROM goodinf_table
GROUP BY 제공품목_전메뉴or일부한정상품등;

-- BENEFIT_PERSONELL TABLE
SELECT DISTINCT 제공대상1, ROWID
FROM goodinf_table
GROUP BY 제공대상1;

SELECT DISTINCT 제공대상1, ROWID
FROM goodinf_table
WHERE 제공대상1 LIKE '%누구나%';

UPDATE goodinf_table
SET 제공대상1 = '본인'
WHERE 제공대상1 LIKE '%본인%'
AND 제공대상1 NOT LIKE '%불가%'
AND 제공대상1 NOT LIKE '%가족%'
AND 제공대상1 NOT LIKE '%형제%'
AND 제공대상1 NOT LIKE '%동반%'
OR 제공대상1 LIKE '%당사자%'
OR 제공대상1 LIKE '%본인만%'
OR 제공대상1 LIKE '%카드소지자%'
OR 제공대상1 LIKE '%결식아동%본인%'
OR 제공대상1 LIKE '%결식아동으로%제한%'
OR 제공대상1 LIKE '비포함'
OR 제공대상1 LIKE '결식아동'
OR 제공대상1 LIKE '없음';

UPDATE goodinf_table
SET 제공대상1 = '가족까지'
WHERE 제공대상1 LIKE '%가족%'
OR 제공대상1 LIKE '%형제%'
OR 제공대상1 LIKE '%동생%' ;

UPDATE goodinf_table
SET 제공대상1 = '제한없음'
WHERE 제공대상1 LIKE '%동반자%'
OR 제공대상1 LIKE '제한없음'
OR 제공대상1 LIKE '%누구나%'
OR 제공대상1 LIKE '%제한없음%';

UPDATE goodinf_table
SET 제공대상1 = '동반1인'
WHERE 제공대상1 LIKE '%1인%';

UPDATE goodinf_table
SET 제공대상1 = '동반2인'
WHERE 제공대상1 LIKE '%2인%';

UPDATE goodinf_table
SET 제공대상1 = '동반3인'
WHERE 제공대상1 LIKE '%3인%';

-- BENEFIT_PERSONELL TABLE
INSERT INTO BENEFIT_PERSONELL (PERSONELL_ID, AMOUNT_OF_PERSONELL)
SELECT DISTINCT ROWID, 제공대상1
FROM goodinf_table
GROUP BY 제공대상1;

-- DONATION_GENERAL TABLE
SELECT DISTINCT 후원회원참여여부, ROWID
FROM goodinf_table
GROUP BY 후원회원참여여부;

INSERT INTO DONATION_GENERAL (PARTICIPATE_ID, PATICIPATION)
SELECT DISTINCT ROWID, 후원회원참여여부 
FROM goodinf_table
GROUP BY 후원회원참여여부;

-- -- OPERATING_TIME TABLE
-- SELECT DISTINCT 영업시간, ROWID
-- FROM goodinf_table
-- GROUP BY 영업시간;
