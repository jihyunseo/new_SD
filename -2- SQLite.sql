-- SQLite
CREATE TABLE ATTACHEDFILE
(
  FILE     TEXT NOT NULL,
  CONTENTS TEXT NULL    ,
  PRIMARY KEY (FILE)
);

CREATE TABLE AUTHORITY
(
  AUTHORITY_ID TEXT NULL    ,
  NAME         TEXT NULL    ,
  DESCRIPTION  TEXT NULL    ,
  USE_YN       TEXT NULL    ,
  PRIMARY KEY (AUTHORITY_ID)
);

CREATE TABLE HOBBY
(
  ID               NULL    ,
  NAME        TEXT NULL    ,
  SPORTS      TEXT NOT NULL,
  INSTRUMENTS      NULL    ,
  DIY              NULL    ,
  ELSE             NULL    ,
  JOIN        TEXT NULL    
  CONSTRAINT FK_MEMBER_TO_HOBBY
    FOREIGN KEY (JOIN)
    REFERENCES MEMBER (JOIN);
);

CREATE TABLE LOGHISTORY
(
  LOGINTIME    TEXT NOT NULL,
  LOGOUTTIME   TEXT NULL    ,
  AUTHORITY_ID TEXT NULL    ,
  PRIMARY KEY (LOGINTIME)
  CONSTRAINT FK_AUTHORITY_TO_LOGHISTORY
    FOREIGN KEY (AUTHORITY_ID)
    REFERENCES AUTHORITY (AUTHORITY_ID);
);

CREATE TABLE MEMBER
(
  ID(EMAIL)        TEXT NULL    ,
  PASSWORD         TEXT NULL    ,
  NAME             TEXT NULL    ,
  JOIN             TEXT NULL    ,
  ORGANIZATION     TEXT NULL    ,
  ORGANIZATION_SEQ TEXT NOT NULL,
  AUTHORITY_ID     TEXT NULL    ,
  PRIMARY KEY (JOIN)
  CONSTRAINT FK_ORGANIZATION_TO_MEMBER
    FOREIGN KEY (ORGANIZATION_SEQ)
    REFERENCES ORGANIZATION (ORGANIZATION_SEQ);
    CONSTRAINT FK_AUTHORITY_TO_MEMBER
    FOREIGN KEY (AUTHORITY_ID)
    REFERENCES AUTHORITY (AUTHORITY_ID);
);

CREATE TABLE ORGANIZATION
(
  ORGANIZATION_SEQ TEXT NOT NULL,
  NAME             TEXT NULL    ,
  TELEPHONE        TEXT NULL    ,
  ORDER_NUMBER     TEXT NULL    ,
  PRIMARY KEY (ORGANIZATION_SEQ)
);

CREATE TABLE PROJECTS
(
  GRADES     TEXT NULL    ,
  THEME      TEXT NOT NULL,
  DUEDATE    TEXT NULL    ,
  GUIDELINE  TEXT NULL    ,
  ASSESSMENT TEXT NULL    ,
  FILE       TEXT NOT NULL,
  PRIMARY KEY (THEME)
  CONSTRAINT FK_ATTACHEDFILE_TO_PROJECTS
    FOREIGN KEY (FILE)
    REFERENCES ATTACHEDFILE (FILE);
);

CREATE TABLE TEACHER
(
  NAME      TEXT NULL    ,
  SUBJECT   TEXT NULL    ,
  ROLL_NO,  TEXT NOT NULL,
  FIRSTNAME TEXT NULL    ,
  LASTNAME  TEXT NULL    ,
  JOIN      TEXT NULL    ,

  PRIMARY KEY (ROLL_NO,)
  CONSTRAINT FK_MEMBER_TO_TEACHER
    FOREIGN KEY (JOIN)
    REFERENCES MEMBER (JOIN);
);




