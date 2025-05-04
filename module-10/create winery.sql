-- Drop winery database if it exists
DROP DATABASE IF EXISTS winery;

DROP USER IF EXISTS 'winery_user'@'localhost';

CREATE USER 'winery_user'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'merlot';

-- Creating database and tables for RedGroup in 3NF
CREATE DATABASE winery;
USE winery;

-- Grant all privileges to the winery database to user winery_user on localhost
GRANT ALL PRIVILEGES ON winery.* TO 'winery_user'@'localhost';

-- Creating Employee table
CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Position VARCHAR(50),
    Hourly_Rate DECIMAL(10,2),
    Weekly_Hours INT
);

-- Creating Work_Log table
CREATE TABLE Work_Log (
    Log_ID INT PRIMARY KEY,
    Employee_ID INT,
    Date DATE,
    Time_IN TIME,
    Time_OUT TIME,
    Hours_Worked DECIMAL(5,2),
    Quarter INT,
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);

-- Creating Wine table
CREATE TABLE Wine (
    Wine_ID INT PRIMARY KEY,
    Wine_Type VARCHAR(50) NOT NULL,
    Cost_Per_Bottle DECIMAL(10,2),
    Stock_Quantity INT
);

-- Creating Monthly_Sales table
CREATE TABLE Monthly_Sales (
    Sale_ID INT PRIMARY KEY,
    Wine_ID INT,
    Sale_Month DATE,
    Bottles_Sold INT,
    FOREIGN KEY (Wine_ID) REFERENCES Wine(Wine_ID)
);

-- Creating Distributor table
CREATE TABLE Distributor (
    Distributor_ID INT PRIMARY KEY,
    Distributor_Name VARCHAR(100) NOT NULL,
    Contact_Info VARCHAR(200)
);

-- Creating Supplier table
CREATE TABLE Supplier (
    Supplier_ID INT PRIMARY KEY,
    Supplier_Name VARCHAR(100) NOT NULL,
    Supplier_Contact VARCHAR(200)
);

-- Creating Supply_Item table
CREATE TABLE Supply_Item (
    Item_ID INT PRIMARY KEY,
    Item_Type VARCHAR(50) NOT NULL,
    Supplier_ID INT,
    Cost_Per_Unit DECIMAL(10,2),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
);

-- Creating Order table
CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Distributor_ID INT,
    Order_Date DATE,
    Total_Cost DECIMAL(10,2),
    Wine_ID INT,
    Order_ID_Quantity INT,
    FOREIGN KEY (Distributor_ID) REFERENCES Distributor(Distributor_ID),
    FOREIGN KEY (Wine_ID) REFERENCES Wine(Wine_ID)
);

-- Creating Shipment table
CREATE TABLE Shipment (
    Shipment_ID INT PRIMARY KEY,
    Supplier_ID INT,
    Order_ID INT,
    Quantity INT,
    Expected_Delivery_Date DATE,
    Actual_Delivery_Date DATE,
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID)
);

-- Creating Status table
CREATE TABLE Status (
    Status_ID INT PRIMARY KEY,
    Order_ID INT,
    Wine_ID INT,
    Quantity_Ordered INT,
    Status VARCHAR(30),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    FOREIGN KEY (Wine_ID) REFERENCES Wine(Wine_ID)
);

-- Populating Employee table
INSERT INTO Employee (Employee_ID, First_Name, Last_Name, Position, Hourly_Rate, Weekly_Hours) VALUES
(1, 'Dario', 'Doe', 'Manager', 25.00, 40),
(2, 'Judejah', 'Smith', 'Sales Associate', 18.00, 35),
(3, 'Scott', 'Johnson', 'Winemaker', 30.00, 45),
(4, 'Kris', 'Williams', 'Accountant', 22.00, 40),
(5, 'Sue', 'Brown', 'Warehouse Worker', 16.00, 38),
(6, 'John', 'Davis', 'Marketing', 20.00, 36);

-- Populating Work_Log table
INSERT INTO Work_Log (Log_ID, Employee_ID, Date, Time_IN, Time_OUT, Hours_Worked, Quarter) VALUES
(1, 1, '2025-01-01', '08:00:00', '16:00:00', 8.00, 1),
(2, 2, '2025-01-02', '09:00:00', '17:00:00', 8.00, 1),
(3, 3, '2025-01-03', '07:00:00', '15:30:00', 8.50, 1),
(4, 4, '2025-01-04', '08:30:00', '16:30:00', 8.00, 1),
(5, 5, '2025-01-05', '10:00:00', '18:00:00', 8.00, 1),
(6, 6, '2025-01-06', '09:30:00', '17:30:00', 8.00, 1);

-- Populating Wine table
INSERT INTO Wine (Wine_ID, Wine_Type, Cost_Per_Bottle, Stock_Quantity) VALUES
(1, 'Cabernet', 25.00, 100),
(2, 'Chablis', 20.00, 150),
(3, 'Merlot', 22.00, 80),
(4, 'Chardonnay', 30.00, 60);

-- Populating Monthly_Sales table
INSERT INTO Monthly_Sales (Sale_ID, Wine_ID, Sale_Month, Bottles_Sold) VALUES
(1, 1, '2025-01-01', 50),
(2, 2, '2025-01-01', 75),
(3, 3, '2025-02-01', 40),
(4, 4, '2025-02-01', 30);

-- Populating Distributor table
INSERT INTO Distributor (Distributor_ID, Distributor_Name, Contact_Info) VALUES
(1, 'Wine Distributors Inc.', 'contact@winedist.com'),
(2, 'Vineyard Supplies', 'sales@vineyardsupplies.com'),
(3, 'Global Wines Ltd.', 'info@globalwines.com'),
(4, 'Premium Vintners', 'support@premiumvintners.com'),
(5, 'Local Wine Co.', 'contact@localwineco.com'),
(6, 'Elite Distributors', 'sales@elitedistributors.com');

-- Populating Supplier table
INSERT INTO Supplier (Supplier_ID, Supplier_Name, Supplier_Contact) VALUES
(1, 'Bottle Makers', 'supply@bottlemakers.com'),
(2, 'Cork Suppliers', 'sales@corksuppliers.com'),
(3, 'Label Printers Co.', 'info@labelprinters.com'),
(4, 'Glass Works', 'contact@glassworks.com'),
(5, 'Packaging Solutions', 'support@packagingsolutions.com'),
(6, 'Barrel Makers', 'sales@barrelmakers.com');

-- Populating Supply_Item table
INSERT INTO Supply_Item (Item_ID, Item_Type, Supplier_ID, Cost_Per_Unit) VALUES
(1, 'Glass Bottle', 1, 1.50),
(2, 'Cork', 2, 0.30),
(3, 'Label', 3, 0.20),
(4, 'Wine Barrel', 6, 200.00),
(5, 'Packaging Box', 5, 2.00),
(6, 'Bottle Cap', 4, 0.25);

-- Populating Order table
INSERT INTO Orders (Order_ID, Distributor_ID, Order_Date, Total_Cost, Wine_ID, Order_ID_Quantity) VALUES
(1, 1, '2025-01-10', 2500.00, 1, 100),
(2, 2, '2025-01-15', 3000.00, 2, 150),
(3, 3, '2025-02-01', 1760.00, 3, 80),
(4, 4, '2025-02-10', 1800.00, 4, 60),
(5, 5, '2025-03-01', 2160.00, 4, 120),
(6, 6, '2025-03-15', 1350.00, 1, 90);

-- Populating Shipment table
INSERT INTO Shipment (Shipment_ID, Supplier_ID, Order_ID, Quantity, Expected_Delivery_Date, Actual_Delivery_Date) VALUES
(1, 1, 1, 100, '2025-01-20', '2025-01-19'),
(2, 2, 2, 150, '2025-01-25', '2025-02-07'),
(3, 3, 3, 80, '2025-02-10', '2025-02-09'),
(4, 4, 4, 60, '2025-02-20', '2025-02-19'),
(5, 5, 5, 120, '2025-03-10', '2025-03-09'),
(6, 6, 6, 90, '2025-03-25', '2025-04-24');

-- Populating Status table
INSERT INTO Status (Status_ID, Order_ID, Wine_ID, Quantity_Ordered, Status) VALUES
(1, 1, 1, 100, 'Shipping'),
(2, 2, 2, 150, 'Delivered'),
(3, 3, 3, 80, 'Picking'),
(4, 4, 4, 60, 'Shipping'),
(5, 5, 4, 120, 'Delivered'),
(6, 6, 1, 90, 'Picking');