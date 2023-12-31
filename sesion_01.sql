
-- base de datos

-- DROP DATABASE IF EXISTS celsia_generacion;
-- CREATE DATABASE celsia_generacion;
SELECT datname FROM pg_database;

-- Schema

-- DROP SCHEMA IF EXISTS "test" CASCADE;
CREATE SCHEMA IF NOT EXISTS "test";

-- Crear tabla

-- DROP TABLE IF EXISTS test.USERS CASCADE;
-- DROP TABLE IF EXISTS test.PROJECT CASCADE;
-- DROP TABLE IF EXISTS test.USER_PROJECTS CASCADE;

CREATE TABLE IF NOT EXISTS test.USERS(
 DATE_MAKE TIMESTAMP DEFAULT NOW(),
 DATE_UPDATE TIMESTAMP DEFAULT NOW(),
 _ID VARCHAR(80) DEFAULT '-1',
 NAME VARCHAR(250) DEFAULT '-1',
 _DATA JSONB DEFAULT '{}',
 INDEX SERIAL,
 PRIMARY KEY(_ID)
);
CREATE INDEX IF NOT EXISTS USERS_DATE_MAKE_IDX ON test.USERS(DATE_MAKE);

CREATE TABLE IF NOT EXISTS test.PROJECT(
 DATE_MAKE TIMESTAMP DEFAULT NOW(),
 DATE_UPDATE TIMESTAMP DEFAULT NOW(),
 _ID VARCHAR(80) DEFAULT '-1',
 NAME VARCHAR(250) DEFAULT '-1',
 _DATA JSONB DEFAULT '{}',
 INDEX SERIAL,
 PRIMARY KEY(_ID)
);
CREATE INDEX IF NOT EXISTS PROJECT_DATE_MAKE_IDX ON test.PROJECT(DATE_MAKE);

CREATE TABLE IF NOT EXISTS test.USER_PROJECTS(
 DATE_MAKE TIMESTAMP DEFAULT NOW(),
 USER_ID VARCHAR(80) DEFAULT '-1' REFERENCES test.USERS(_ID) ON DELETE CASCADE ON UPDATE CASCADE,
 PROJECT_ID VARCHAR(80) DEFAULT '-1' REFERENCES test.PROJECT(_ID) ON DELETE CASCADE ON UPDATE CASCADE,
 INDEX SERIAL,
 PRIMARY KEY(USER_ID, PROJECT_ID)
);
CREATE INDEX IF NOT EXISTS USER_PROJECTS_DATE_MAKE_IDX ON test.USER_PROJECTS(DATE_MAKE);

-- INSERT
INSERT INTO test.USERS(_ID, NAME, _DATA)
VALUES('1A', 'Usuario 1', '{"nombre": "Jhon", "apellido": "Doe"}');

-- INSERT RETURNING
INSERT INTO test.USERS(_ID, NAME, _DATA)
VALUES('2A', 'Usuario 2', '{"nombre": "Jhon Jhon", "apellido": "Doe"}') RETURNING INDEX;

INSERT INTO test.PROJECT(_ID, NAME, _DATA)
VALUES('1P', 'Projecto 1', '{"nombre": "Project 1", "descripcion": ""}') RETURNING *;

-- DELETE WHERE
DELETE FROM test.USERS WHERE _ID='1A';

-- DELETE
DELETE FROM test.USERS;

-- INSERT EN BACH
INSERT INTO test.USERS(_ID, NAME, _DATA)
VALUES('1A', 'Usuario 1', '{"nombre": "Jhon", "apellido": "Doe"}'),
('2A', 'Usuario 2', '{"nombre": "Jhon Jhon", "apellido": "Doe"}');

-- INTEGRIDAD REFERENCIAL
INSERT INTO test.USER_PROJECTS(USER_ID, PROJECT_ID)
VALUES('1A', '1P') RETURNING *;

-- FUNCTION
CREATE OR REPLACE FUNCTION test.PING()
RETURNS
 VARCHAR(250) AS $$
DECLARE
 RESULT VARCHAR(250);
BEGIN
 RESULT = 'PONG';
 RETURN RESULT;
END;
$$ LANGUAGE plpgsql;

-- FUNCTION CREATE USER
CREATE OR REPLACE FUNCTION test.UPSET_USER(
VID VARCHAR(80),
VNAME VARCHAR(250),
VDATA JSONB)
RETURNS
 INTEGER AS $$
DECLARE
 RESULT INTEGER;
BEGIN
 SELECT INDEX INTO RESULT FROM test.USERS WHERE _ID=VID LIMIT 1;
 IF NOT FOUND THEN
  INSERT INTO test.USERS(_ID, NAME, _DATA)
  VALUES(VID, VNAME, VDATA) RETURNING INDEX INTO RESULT;
 ELSE
  UPDATE test.USERS SET
  DATE_UPDATE=NOW(),
  NAME=VNAME,
  _DATA=VDATA
  WHERE _ID=VID
  RETURNING INDEX INTO RESULT;
 END IF;

 RETURN RESULT;
END;
$$ LANGUAGE plpgsql;

-- EJECUCION DE FUNCTION
SELECT test.UPSET_USER('3A', 'Usuario 3', '{
"nombre": "Jhon",
"apellido": "Doe"
}');