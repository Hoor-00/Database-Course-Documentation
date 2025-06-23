CREATE DATABASE DatabaseCo;
USE  DatabaseCo;

CREATE TABLE Employee (
    SSN int primary key identity(1,1),
    FN nvarchar(30),
    LN nvarchar(30),
    BD date,
    Gender bit default 0,
    Superviser int,
    DNum int, 
    FOREIGN KEY (Superviser) REFERENCES Employee(SSN)
);

ALTER TABLE Employee
add FOREIGN KEY (DNum) REFERENCES Department(DNum);

CREATE TABLE Department (
    DNum int primary key identity(1,1),
    DName nvarchar(30),
    SSN int,
    HiringDate DATE,
    FOREIGN KEY (SSN) REFERENCES Employee(SSN)
);

CREATE TABLE Locations (
    DNum int,
    Location nvarchar(30),
    PRIMARY KEY (DNum, Location),
    FOREIGN KEY (DNum) REFERENCES Department(DNum)
);

CREATE TABLE Project (
    ProjectNumber int PRIMARY KEY IDENTITY(1,1),
    PN nvarchar(30),
    City nvarchar(30),
    Location nvarchar(30),
    DNum int,
    FOREIGN KEY (DNum) REFERENCES Department(DNum)
);
CREATE TABLE myWork (
    SSN int,
    PNum int,
    Hours int,
    PRIMARY KEY (SSN, PNum),
    FOREIGN KEY (SSN) REFERENCES Employee(SSN),
    FOREIGN KEY (PNum) REFERENCES Project(ProjectNumber)
);

CREATE TABLE Dependent (
    SSN int,
    DNum nvarchar(30)PRIMARY KEY,
    Gender bit default 0 ,
    BD date,
    FOREIGN KEY (SSN) REFERENCES Employee(SSN)
);

