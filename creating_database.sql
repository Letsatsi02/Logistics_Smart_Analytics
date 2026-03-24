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
-- ============================================================
-- Dim_Location
-- ============================================================
INSERT INTO Dim_Location VALUES
(1,  'Johannesburg',   'Gauteng',       'South Africa', '2000', -26.2041, 28.0473),
(2,  'Cape Town',      'Western Cape',  'South Africa', '8000', -33.9249, 18.4241),
(3,  'Durban',         'KwaZulu-Natal', 'South Africa', '4001', -29.8587, 31.0218),
(4,  'Pretoria',       'Gauteng',       'South Africa', '0001', -25.7479, 28.2293),
(5,  'Port Elizabeth', 'Eastern Cape',  'South Africa', '6001', -33.9608, 25.6022),
(6,  'Sandton',        'Gauteng',       'South Africa', '2196', -26.1070, 28.0567),
(7,  'Soweto',         'Gauteng',       'South Africa', '1800', -26.2678, 27.8585),
(8,  'Bloemfontein',   'Free State',    'South Africa', '9300', -29.0852, 26.1596),
(9,  'East London',    'Eastern Cape',  'South Africa', '5200', -33.0153, 27.9116),
(10, 'Polokwane',      'Limpopo',       'South Africa', '0699', -23.8962, 29.4486);
GO