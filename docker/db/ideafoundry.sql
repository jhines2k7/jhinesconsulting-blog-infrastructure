# noinspection SqlNoDataSourceInspectionForFile

CREATE DATABASE IF NOT EXISTS ideafoundry;

USE ideafoundry;

CREATE TABLE person (
  id          INT(11) NOT NULL PRIMARY KEY,
  occasion_id VARCHAR(255),
  email       VARCHAR(255),
  address     VARCHAR(255),
  zip         VARCHAR(255),
  city        VARCHAR(255),
  phone       VARCHAR(255),
  first_name  VARCHAR(255),
  last_name   VARCHAR(255),
  full_name   VARCHAR(255),
  created_at  VARCHAR(255),
  updated_at  VARCHAR(255)
)
  ENGINE = InnoDB;

CREATE TABLE occurrence (
  id           INT(11) NOT NULL PRIMARY KEY,
  occasion_id  VARCHAR(255),
  duration     INT(11),
  closes_at    VARCHAR(255),
  created_at   VARCHAR(255),
  ends_at      VARCHAR(255),
  is_active    TINYINT(1),
  schedule_id  VARCHAR(255),
  starts_at    VARCHAR(255),
  time_slot_id VARCHAR(255),
  updated_at   VARCHAR(255)
)
  ENGINE = InnoDB;

CREATE TABLE occasion_order (
  id                  INT(11) NOT NULL PRIMARY KEY,
  occasion_id         VARCHAR(255),
  person_id           INT(11),
  occurrence_id       INT(11),
  gift_card_amount    DOUBLE,
  coupon_amount       DOUBLE,
  outstanding_balance DOUBLE,
  subtotal            DOUBLE,
  total               DOUBLE,
  coupon_description  VARCHAR(255),
  tax_percentage      DOUBLE,
  payment_status      VARCHAR(255),
  status              VARCHAR(255),
  balance             DOUBLE,
  price               DOUBLE,
  description         VARCHAR(255),
  verification_code   VARCHAR(255),
  quantity            INT(11),
  tax                 DOUBLE,
  created_at          VARCHAR(255),
  updated_at          VARCHAR(255),
  FOREIGN KEY fk_person_id(person_id) REFERENCES person (id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  FOREIGN KEY fk_occurrence_id(occurrence_id) REFERENCES occurrence (id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
)
  ENGINE = InnoDB;

CREATE TABLE question (
  id          INT(11) NOT NULL PRIMARY KEY,
  occasion_id VARCHAR(255),
  question    LONGTEXT,
  answer      LONGTEXT,
  created_at  VARCHAR(255),
  updated_at  VARCHAR(255)
)
  ENGINE = InnoDB;

CREATE TABLE order_question (
  order_id    INT(11),
  question_id INT(11),
  CONSTRAINT order_question_pk PRIMARY KEY (order_id, question_id),
  CONSTRAINT fk_order_question_order FOREIGN KEY (order_id) REFERENCES occasion_order (id),
  CONSTRAINT fk_order_question_question FOREIGN KEY (question_id) REFERENCES question (id)
)
  ENGINE = InnoDB;

CREATE TABLE person_question (
  person_id   INT(11),
  question_id INT(11),
  CONSTRAINT person_question_pk PRIMARY KEY (person_id, question_id),
  CONSTRAINT fk_person_question_person FOREIGN KEY (person_id) REFERENCES person (id),
  CONSTRAINT fk_person_question_question FOREIGN KEY (question_id) REFERENCES question (id)
)
  ENGINE = InnoDB;

CREATE TABLE person_occurrence (
  person_id     INT(11),
  occurrence_id INT(11),
  CONSTRAINT person_occurrence_pk PRIMARY KEY (person_id, occurrence_id),
  CONSTRAINT fk_person_occurrence_person FOREIGN KEY (person_id) REFERENCES person (id),
  CONSTRAINT fk_person_occurrence_occurrence FOREIGN KEY (occurrence_id) REFERENCES occurrence (id)
)
  ENGINE = InnoDB;

CREATE TABLE occurrence_question (
  occurrence_id INT(11),
  question_id   INT(11),
  CONSTRAINT occurrence_question_pk PRIMARY KEY (occurrence_id, question_id),
  CONSTRAINT fk_occurrence_question_occurrence FOREIGN KEY (occurrence_id) REFERENCES occurrence (id),
  CONSTRAINT fk_occurrence_question_question FOREIGN KEY (question_id) REFERENCES question (id)
)
  ENGINE = InnoDB;
