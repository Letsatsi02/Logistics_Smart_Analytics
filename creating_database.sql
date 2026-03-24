-- Create Database
CREATE DATABASE smart_logistics;
USE smart_logistics;
GO
-- ============================================================
-- DIMENSION TABLES
-- ============================================================

-- Dim_Customer
CREATE TABLE Dim_Customer (
    CustomerID      INT             PRIMARY KEY,
    FullName        NVARCHAR(100)   NOT NULL,
    PhoneNumber     NVARCHAR(20),
    Email           NVARCHAR(100),
    CustomerType    NVARCHAR(50),
    LocationID      INT,
    JoinDate        DATE,
    IsActive        BIT             DEFAULT 1       -- 1 = TRUE, 0 = FALSE
);
GO
-- Dim_Vehicle
CREATE TABLE Dim_Vehicle (
    VehicleID       INT             PRIMARY KEY,
    VehicleType     NVARCHAR(50)    NOT NULL,
    PlateNumber     NVARCHAR(20)    NOT NULL UNIQUE,
    CapacityKG      DECIMAL(10,2),
    ModelYear       SMALLINT,
    Status          NVARCHAR(20)    DEFAULT 'Active'
);
GO
-- Dim_Driver
CREATE TABLE Dim_Driver (
    DriverID        INT             PRIMARY KEY,
    DriverName      NVARCHAR(100)   NOT NULL,
    LicenseType     NVARCHAR(20),
    ExperienceYears SMALLINT,
    HireDate        DATE,
    IsActive        BIT             DEFAULT 1
);
GO
-- Dim_Location
CREATE TABLE Dim_Location (
    LocationID      INT             PRIMARY KEY,
    City            NVARCHAR(100)   NOT NULL,
    Region          NVARCHAR(100),
    Country         NVARCHAR(100)   NOT NULL,
    PostalCode      NVARCHAR(20),
    Latitude        DECIMAL(9,6),
    Longitude       DECIMAL(9,6)
);
GO
-- Dim_Date
CREATE TABLE Dim_Date (
    DateID          INT             PRIMARY KEY,
    FullDate        DATE            NOT NULL,
    Day             TINYINT         NOT NULL,
    Month           TINYINT         NOT NULL,
    Year            SMALLINT        NOT NULL,
    DayOfWeek       NVARCHAR(10)    NOT NULL,
    Quarter         TINYINT         NOT NULL,
    IsHoliday       BIT             DEFAULT 0       -- 1 = Holiday, 0 = Normal day
);
GO
-- ============================================================
-- FACT TABLE
-- ============================================================

CREATE TABLE Fact_Deliveries (
    DeliveryID              INT             PRIMARY KEY,
    CustomerID              INT             NOT NULL,
    DriverID                INT             NOT NULL,
    VehicleID               INT             NOT NULL,
    DateID                  INT             NOT NULL,
    LocationID              INT             NOT NULL,
    DeliveryStatus          NVARCHAR(30)    NOT NULL,
    DistanceKM              DECIMAL(10,2),
    DeliveryCost            DECIMAL(12,2),
    DeliveryTimeMinutes     INT,

    CONSTRAINT fk_customer  FOREIGN KEY (CustomerID)    REFERENCES Dim_Customer(CustomerID),
    CONSTRAINT fk_driver    FOREIGN KEY (DriverID)      REFERENCES Dim_Driver(DriverID),
    CONSTRAINT fk_vehicle   FOREIGN KEY (VehicleID)     REFERENCES Dim_Vehicle(VehicleID),
    CONSTRAINT fk_date      FOREIGN KEY (DateID)        REFERENCES Dim_Date(DateID),
    CONSTRAINT fk_location  FOREIGN KEY (LocationID)    REFERENCES Dim_Location(LocationID)
);
GO
USE smart_logistics;
GO

-- ============================================================
-- Dim_Date
-- ============================================================
INSERT INTO Dim_Date VALUES
(20240101, '2024-01-01', 1,  1,  2024, 'Monday',    1, 1),
(20240115, '2024-01-15', 15, 1,  2024, 'Monday',    1, 0),
(20240201, '2024-02-01', 1,  2,  2024, 'Thursday',  1, 0),
(20240315, '2024-03-15', 15, 3,  2024, 'Friday',    1, 0),
(20240401, '2024-04-01', 1,  4,  2024, 'Monday',    2, 0),
(20240515, '2024-05-15', 15, 5,  2024, 'Wednesday', 2, 0),
(20240601, '2024-06-01', 1,  6,  2024, 'Saturday',  2, 0),
(20240701, '2024-07-01', 1,  7,  2024, 'Monday',    3, 0),
(20240815, '2024-08-15', 15, 8,  2024, 'Thursday',  3, 0),
(20240901, '2024-09-01', 1,  9,  2024, 'Sunday',    3, 0),
(20241001, '2024-10-01', 1,  10, 2024, 'Tuesday',   4, 0),
(20241201, '2024-12-25', 25, 12, 2024, 'Wednesday', 4, 1);
GO
