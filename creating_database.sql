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
-- ============================================================
-- Dim_Customer
-- ============================================================
INSERT INTO Dim_Customer VALUES
(1,  'Thabo Nkosi',        '0821234567', 'thabo@email.com',    'Retail',    1,  '2022-03-10', 1),
(2,  'Lerato Dlamini',     '0839876543', 'lerato@corp.co.za',  'Corporate', 2,  '2021-07-15', 1),
(3,  'Mohammed Patel',     '0741112233', 'mpatel@biz.co.za',   'SME',       3,  '2023-01-20', 1),
(4,  'Nomsa Zulu',         '0823334455', 'nomsa@mail.co.za',   'Retail',    4,  '2022-11-05', 1),
(5,  'Pieter van der Berg','0826667788', 'pieter@co.za',       'Corporate', 5,  '2020-06-01', 1),
(6,  'Ayanda Mthembu',     '0835559900', 'ayanda@co.za',       'SME',       6,  '2023-08-14', 1),
(7,  'Fatima Osman',       '0810001122', 'fatima@shop.co.za',  'Retail',    7,  '2024-01-03', 1),
(8,  'David Sithole',      '0827778899', 'david@biz.co.za',    'Corporate', 8,  '2021-04-22', 0),
(9,  'Zanele Mokoena',     '0844445566', 'zanele@mail.co.za',  'Retail',    9,  '2023-05-30', 1),
(10, 'Sipho Mahlangu',     '0852223344', 'sipho@co.za',        'SME',       10, '2022-09-18', 1);
GO
-- ============================================================
-- Dim_Vehicle
-- ============================================================
INSERT INTO Dim_Vehicle VALUES
(1,  'Motorbike', 'GP 12-34 AB',  50.00,   2021, 'Active'),
(2,  'Van',       'GP 56-78 CD',  800.00,  2020, 'Active'),
(3,  'Truck',     'WC 90-12 EF',  5000.00, 2019, 'Active'),
(4,  'Van',       'KZN 34-56 GH', 800.00,  2022, 'Maintenance'),
(5,  'Motorbike', 'GP 78-90 IJ',  50.00,   2023, 'Active'),
(6,  'Truck',     'GP 11-22 KL',  8000.00, 2020, 'Active'),
(7,  'Van',       'EC 33-44 MN',  1000.00, 2021, 'Active'),
(8,  'Motorbike', 'WC 55-66 OP',  50.00,   2022, 'Active'),
(9,  'Truck',     'FS 77-88 QR',  6000.00, 2018, 'Retired'),
(10, 'Van',       'LP 99-00 ST',  900.00,  2023, 'Active');
GO
-- ============================================================
-- Dim_Driver
-- ============================================================
INSERT INTO Dim_Driver VALUES
(1,  'Bongani Khoza',     'C',  8,  '2016-03-01', 1),
(2,  'Ruan du Plessis',   'EC', 12, '2012-07-15', 1),
(3,  'Nandi Cele',        'B',  3,  '2021-01-10', 1),
(4,  'Ashraf Hendricks',  'C',  6,  '2018-05-20', 1),
(5,  'Lungelo Ntuli',     'B',  2,  '2022-06-01', 1),
(6,  'Maria Santos',      'EC', 15, '2009-09-09', 1),
(7,  'Trevor Botha',      'C',  9,  '2015-11-03', 0),
(8,  'Nomvula Shabalala', 'B',  4,  '2020-02-14', 1),
(9,  'Yusuf Fredericks',  'C',  7,  '2017-08-30', 1),
(10, 'Dineo Molefe',      'B',  1,  '2023-09-01', 1);
GO
-- ============================================================
-- Fact_Deliveries
-- ============================================================
INSERT INTO Fact_Deliveries VALUES
(1001, 1,  1,  1,  20240115, 2,  'Delivered',  12.5,  85.00,   35),
(1002, 2,  2,  2,  20240201, 3,  'Delivered',  45.0,  320.00,  120),
(1003, 3,  3,  5,  20240315, 1,  'Pending',    8.2,   55.00,   25),
(1004, 4,  4,  3,  20240401, 4,  'Delivered',  95.0,  750.00,  210),
(1005, 5,  5,  1,  20240515, 5,  'Failed',     6.0,   45.00,   20),
(1006, 6,  6,  6,  20240601, 6,  'Delivered',  210.0, 1400.00, 360),
(1007, 7,  7,  7,  20240701, 7,  'In Transit', 30.0,  200.00,  85),
(1008, 8,  8,  8,  20240815, 8,  'Delivered',  15.0,  95.00,   40),
(1009, 9,  9,  10, 20240901, 9,  'Delivered',  22.0,  140.00,  60),
(1010, 10, 10, 2,  20241001, 10, 'Pending',    78.0,  520.00,  180),
(1011, 1,  2,  2,  20240601, 1,  'Delivered',  18.0,  120.00,  55),
(1012, 3,  1,  5,  20240701, 3,  'Delivered',  9.5,   65.00,   30),
(1013, 5,  4,  3,  20240815, 2,  'Failed',     110.0, 820.00,  250),
(1014, 7,  6,  6,  20241001, 6,  'Delivered',  190.0, 1250.00, 330),
(1015, 2,  3,  1,  20241201, 4,  'Delivered',  7.0,   50.00,   22);
GO
--- Query 1 retrieves a complete view of all deliveries in the system, 
--- combine data from the fact table Fact_Delivery with all related dimension tables for detailed
SELECT
    f.DeliveryID,
    c.FullName AS CustomerName,
    c.CustomerType,
    dr.DriverName,
    dr.LicenseType,
    v.VehicleType,
    v.PlateNumber,
    l.City,
    l.Region,
    d.FullDate AS DeliveryDate,
    d.DayOfWeek,
    f.DeliveryStatus,
    f.DistanceKM,
    f.DeliveryCost,
    f.DeliveryTimeMinutes
FROM dbo.Fact_Delivery f
INNER JOIN dbo.Dim_Customer c ON f.CustomerID = c.CustomerID
INNER JOIN dbo.Dim_Driver dr ON f.DriverID = dr.DriverID
INNER JOIN dbo.Dim_Vehicle v ON f.VehicleID = v.VehicleID
INNER JOIN dbo.Dim_Location l ON f.LocationID = l.LocationID
INNER JOIN dbo.Dim_Date d ON f.DateID = d.DateID
ORDER BY d.FullDate DESC;
--- Query 2 Which customers generate the most revenue based on their total spend and number of deliveries?
SELECT
c.FullName AS CustomerName,
c.CustomerType,
c.Email,
l.City AS CustomerCity,
l.Region,
COUNT(f.DeliveryID) AS TotalDeliveries,
ROUND(SUM(f.DeliveryCost), 2) AS TotalRevenue,
ROUND(AVG(f.DeliveryCost), 2) AS AvgDeliveryCost,
SUM(CASE WHEN f.DeliveryStatus = 'Delivered' THEN 1 ELSE 0 END) AS Successful,
SUM(CASE WHEN f.DeliveryStatus = 'Failed' THEN 1 ELSE 0 END) AS Failed
FROM dbo.Fact_Delivery f
INNER JOIN Dim_Customer c ON f.CustomerID = c.CustomerID
INNER JOIN Dim_Location l ON f.LocationID = l.LocationID
INNER JOIN Dim_Driver dr ON f.DriverID = dr.DriverID
INNER JOIN Dim_Vehicle v ON f.VehicleID = v.VehicleID
INNER JOIN Dim_Date d ON f.DateID = d.DateID
GROUP BY c.CustomerID, c.FullName, c.CustomerType, c.Email, l.City, l.Region
ORDER BY TotalRevenue DESC;
--- Which drivers perform best, ranked by their delivery success rate and speed?
SELECT
dr.DriverName,
dr.LicenseType,
dr.ExperienceYears,
v.VehicleType AS VehicleUsed,
COUNT(f.DeliveryID) AS TotalDeliveries,
SUM(CASE WHEN f.DeliveryStatus = 'Delivered' THEN 1 ELSE 0 END) AS Successful,
SUM(CASE WHEN f.DeliveryStatus = 'Failed' THEN 1 ELSE 0 END) AS Failed,
ROUND(
CAST(SUM(CASE WHEN f.DeliveryStatus = 'Delivered'
THEN 1 ELSE 0 END) AS FLOAT)
/ COUNT(f.DeliveryID) * 100, 1
) AS SuccessRatePct,
ROUND(AVG(f.DistanceKM), 1) AS AvgDistanceKM,
ROUND(AVG(CAST(f.DeliveryTimeMinutes AS FLOAT)), 1) AS AvgTimeMin
FROM dbo.Fact_Delivery f
INNER JOIN Dim_Driver dr ON f.DriverID = dr.DriverID
INNER JOIN Dim_Vehicle v ON f.VehicleID = v.VehicleID
INNER JOIN Dim_Customer c ON f.CustomerID = c.CustomerID
INNER JOIN Dim_Location l ON f.LocationID = l.LocationID
INNER JOIN Dim_Date d ON f.DateID = d.DateID
GROUP BY dr.DriverID, dr.DriverName, dr.LicenseType, dr.ExperienceYears, v.VehicleType
ORDER BY SuccessRatePct DESC;
-- Which vehicles are most cost-efficient and generate the highest revenue per kilometre?
SELECT
v.VehicleType,
v.PlateNumber,
v.CapacityKG,
v.Status AS VehicleStatus,
dr.DriverName AS AssignedDriver,
l.City AS DeliveryCity,
COUNT(f.DeliveryID) AS TotalTrips,
ROUND(SUM(f.DistanceKM), 1) AS TotalKMCovered,
ROUND(SUM(f.DeliveryCost), 2) AS TotalRevenue,
ROUND(SUM(f.DeliveryCost) / NULLIF(SUM(f.DistanceKM), 0), 2) AS RevenuePerKM
FROM dbo.Fact_Delivery f
INNER JOIN Dim_Vehicle v ON f.VehicleID = v.VehicleID
INNER JOIN Dim_Driver dr ON f.DriverID = dr.DriverID
INNER JOIN Dim_Customer c ON f.CustomerID = c.CustomerID
INNER JOIN Dim_Location l ON f.LocationID = l.LocationID
INNER JOIN Dim_Date d ON f.DateID = d.DateID
GROUP BY v.VehicleID, v.VehicleType, v.PlateNumber,
v.CapacityKG, v.Status, dr.DriverName, l.City
ORDER BY RevenuePerKM DESC;
--- Which cities and regions have the highest delivery demand for resource allocation?
SELECT
l.City,
l.Region,
l.Country,
COUNT(f.DeliveryID) AS TotalDeliveries,
ROUND(SUM(f.DeliveryCost), 2) AS TotalRevenue,
ROUND(AVG(f.DistanceKM), 1) AS AvgDistanceKM,
ROUND(AVG(CAST(f.DeliveryTimeMinutes AS FLOAT)), 1) AS AvgDeliveryTimeMin,
COUNT(DISTINCT c.CustomerID) AS UniqueCustomers,
COUNT(DISTINCT dr.DriverID) AS DriversDeployed
FROM dbo.Fact_Delivery f
INNER JOIN Dim_Location l ON f.LocationID = l.LocationID
INNER JOIN Dim_Customer c ON f.CustomerID = c.CustomerID
INNER JOIN Dim_Driver dr ON f.DriverID = dr.DriverID
INNER JOIN Dim_Vehicle v ON f.VehicleID = v.VehicleID
INNER JOIN Dim_Date d ON f.DateID = d.DateID
GROUP BY l.LocationID, l.City, l.Region, l.Country
ORDER BY TotalDeliveries DESC;
--- What are the month-on-month delivery trends and growth across all key metrics?
SELECT
d.Year,
d.Month,
d.Quarter,
COUNT(f.DeliveryID) AS TotalDeliveries,
ROUND(SUM(f.DeliveryCost), 2) AS TotalRevenue,
COUNT(DISTINCT c.CustomerID) AS UniqueCustomers,
COUNT(DISTINCT dr.DriverID) AS ActiveDrivers,
COUNT(DISTINCT v.VehicleID) AS VehiclesUsed,
COUNT(DISTINCT l.City) AS CitiesServed,
SUM(CASE WHEN f.DeliveryStatus = 'Delivered' THEN 1 ELSE 0 END) AS Delivered,
SUM(CASE WHEN f.DeliveryStatus = 'Failed' THEN 1 ELSE 0 END) AS Failed
FROM dbo.Fact_Delivery f
INNER JOIN Dim_Date d ON f.DateID = d.DateID
INNER JOIN Dim_Customer c ON f.CustomerID = c.CustomerID
INNER JOIN Dim_Driver dr ON f.DriverID = dr.DriverID
INNER JOIN Dim_Vehicle v ON f.VehicleID = v.VehicleID
INNER JOIN Dim_Location l ON f.LocationID = l.LocationID
GROUP BY d.Year, d.Month, d.Quarter
ORDER BY d.Year, d.Month;
-- What are the root causes of every failed delivery? 
SELECT
f.DeliveryID,
d.FullDate AS DeliveryDate,
d.DayOfWeek,
d.IsHoliday,
c.FullName AS CustomerName,
c.CustomerType,
c.PhoneNumber AS CustomerPhone,
dr.DriverName,
dr.LicenseType,
dr.ExperienceYears,
v.VehicleType,
v.PlateNumber,
v.Status AS VehicleStatus,
l.City,
l.Region,
f.DistanceKM,
f.DeliveryCost,
f.DeliveryTimeMinutes
FROM dbo.Fact_Delivery f
INNER JOIN Dim_Customer c ON f.CustomerID = c.CustomerID
INNER JOIN Dim_Driver dr ON f.DriverID = dr.DriverID
INNER JOIN Dim_Vehicle v ON f.VehicleID = v.VehicleID
INNER JOIN Dim_Location l ON f.LocationID = l.LocationID
INNER JOIN Dim_Date d ON f.DateID = d.DateID
WHERE f.DeliveryStatus = 'Failed'
ORDER BY d.FullDate DESC;
--- How do revenue and success rate compare across Corporate, Retail, and SME customer segments?
SELECT
c.CustomerType,
COUNT(DISTINCT c.CustomerID) AS TotalCustomers,
COUNT(f.DeliveryID) AS TotalDeliveries,
ROUND(SUM(f.DeliveryCost), 2) AS TotalRevenue,
ROUND(AVG(f.DeliveryCost), 2) AS AvgRevenuePerDelivery,
COUNT(DISTINCT l.City) AS CitiesServed,
ROUND(
CAST(SUM(CASE WHEN f.DeliveryStatus = 'Delivered'
THEN 1 ELSE 0 END) AS FLOAT)
/ COUNT(f.DeliveryID) * 100, 1
) AS SuccessRatePct
FROM dbo.Fact_Delivery f
INNER JOIN Dim_Customer c ON f.CustomerID = c.CustomerID
INNER JOIN Dim_Location l ON f.LocationID = l.LocationID
INNER JOIN Dim_Driver dr ON f.DriverID = dr.DriverID
INNER JOIN Dim_Vehicle v ON f.VehicleID = v.VehicleID
INNER JOIN Dim_Date d ON f.DateID = d.DateID
GROUP BY c.CustomerType
ORDER BY TotalRevenue DESC;
-- What are the operational costs of deliveries on weekends and public holidays?
SELECT
d.FullDate AS DeliveryDate,
d.DayOfWeek,
CASE
WHEN d.IsHoliday = 1 THEN 'Public Holiday'
WHEN d.DayOfWeek IN ('Saturday','Sunday') THEN 'Weekend'
ELSE 'Weekday'
END AS DayType,
c.FullName AS CustomerName,
dr.DriverName,
v.VehicleType,
l.City,
f.DeliveryStatus,
f.DistanceKM,
f.DeliveryCost,
f.DeliveryTimeMinutes
FROM dbo.Fact_Delivery f
INNER JOIN Dim_Date d ON f.DateID = d.DateID
INNER JOIN Dim_Customer c ON f.CustomerID = c.CustomerID
INNER JOIN Dim_Driver dr ON f.DriverID = dr.DriverID
INNER JOIN Dim_Vehicle v ON f.VehicleID = v.VehicleID
INNER JOIN Dim_Location l ON f.LocationID = l.LocationID
WHERE d.IsHoliday = 1 OR d.DayOfWeek IN ('Saturday', 'Sunday')
ORDER BY d.FullDate DESC;
--- Which deliveries over 50 KM have high distance and cost, and need routing attention?
SELECT
f.DeliveryID,
c.FullName AS CustomerName,
c.CustomerType,
dr.DriverName,
dr.ExperienceYears,
v.VehicleType,
v.CapacityKG,
l.City,
l.Region,
d.FullDate AS DeliveryDate,
f.DeliveryStatus,
f.DistanceKM,
f.DeliveryCost,
f.DeliveryTimeMinutes,
ROUND(f.DeliveryCost / NULLIF(f.DistanceKM, 0), 2) AS CostPerKM
FROM dbo.Fact_Delivery f
INNER JOIN Dim_Customer c ON f.CustomerID = c.CustomerID
INNER JOIN Dim_Driver dr ON f.DriverID = dr.DriverID
INNER JOIN Dim_Vehicle v ON f.VehicleID = v.VehicleID
INNER JOIN Dim_Location l ON f.LocationID = l.LocationID
INNER JOIN Dim_Date d ON f.DateID = d.DateID
WHERE f.DistanceKM > 50
ORDER BY f.DistanceKM DESC;