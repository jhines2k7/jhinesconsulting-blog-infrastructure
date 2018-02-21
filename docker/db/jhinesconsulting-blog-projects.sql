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