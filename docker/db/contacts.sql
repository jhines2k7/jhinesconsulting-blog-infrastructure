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