# noinspection SqlNoDataSourceInspectionForFile

CREATE DATABASE IF NOT EXISTS jhinesconsulting;

USE jhinesconsulting;

CREATE TABLE contact (
  id          INT(11) NOT NULL PRIMARY KEY,
  name        VARCHAR(255),
  email       VARCHAR(255),
  message     LONGTEXT
)
ENGINE = InnoDB;