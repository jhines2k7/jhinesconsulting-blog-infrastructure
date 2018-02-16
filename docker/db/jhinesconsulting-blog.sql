# noinspection SqlNoDataSourceInspectionForFile

CREATE DATABASE IF NOT EXISTS jhinesconsulting;

USE jhinesconsulting;

CREATE TABLE contact (
  id          INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  client_id   VARCHAR(255),
  name        VARCHAR(255),
  email       VARCHAR(255),
  message     LONGTEXT,
  created     DATE,
  updated     DATE
)
ENGINE = InnoDB;
