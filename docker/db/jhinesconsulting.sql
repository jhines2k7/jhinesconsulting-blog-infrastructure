# noinspection SqlNoDataSourceInspectionForFile

CREATE DATABASE IF NOT EXISTS jhinesconsulting_contacts;

USE jhinesconsulting_contacts;

CREATE TABLE contact (
  id          INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  client_id   VARCHAR(255),
  name        VARCHAR(255),
  email       VARCHAR(255),
  message     LONGTEXT,
  created     DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  updated     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
)
  ENGINE = InnoDB;

GRANT SELECT, INSERT, DELETE, UPDATE ON jhinesconsulting_contacts TO ${JHC_DB_USER}@'%' IDENTIFIED BY ${JHC_DB_PASS};

CREATE DATABASE IF NOT EXISTS jhinesconsulting_projects;

USE jhinesconsulting_projects;

CREATE TABLE project (
  id            VARCHAR(255),
  name          VARCHAR(255),
  detail_image  VARCHAR(255),
  home_image    VARCHAR(255),
  description   LONGTEXT,
  solution      LONGTEXT,
  client_name   VARCHAR(255),
  duration      VARCHAR(255),
  date          VARCHAR(255),
  budget        VARCHAR(255)
)
  ENGINE = InnoDB;

GRANT SELECT, INSERT, DELETE, UPDATE ON jhinesconsulting_projects TO ${JHC_DB_USER}@'%' IDENTIFIED BY ${JHC_DB_PASS};
