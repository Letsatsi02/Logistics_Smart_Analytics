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

