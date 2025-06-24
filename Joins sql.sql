
CREATE DATABASE ServerCo;
GO

--  Use the Database
USE ServerCo;
GO

-- Create Tables

-- Servers Table
CREATE TABLE Servers (
    server_id INT PRIMARY KEY,
    server_name VARCHAR(50),
    region VARCHAR(50)
);

-- Alerts Table
CREATE TABLE Alerts (
    alert_id INT PRIMARY KEY,
    server_id INT,
    alert_type VARCHAR(50),
    severity VARCHAR(20)
);

-- AI Models Table
CREATE TABLE AI_Models (
    model_id INT PRIMARY KEY,
    model_name VARCHAR(50),
    use_case VARCHAR(50)
);

-- Model Deployments Table
CREATE TABLE ModelDeployments (
    deployment_id INT PRIMARY KEY,
    server_id INT,
    model_id INT,
    deployed_on DATE
);

--  Insert Sample Data

-- Servers Data
INSERT INTO Servers VALUES
(1, 'web-server-01', 'us-east'),
(2, 'db-server-01', 'us-east'),
(3, 'api-server-01', 'eu-west'),
(4, 'cache-server-01', 'us-west');

-- Alerts Data
INSERT INTO Alerts VALUES
(101, 1, 'CPU Spike', 'High'),
(102, 2, 'Disk Failure', 'Critical'),
(103, 2, 'Memory Leak', 'Medium'),
(104, 5, 'Network Latency', 'Low'); -- 5 doesn't exist in Servers (intentional edge case)

-- AI Models Data
INSERT INTO AI_Models VALUES
(201, 'AnomalyDetector-v2', 'Alert Prediction'),
(202, 'ResourceForecaster', 'Capacity Planning'),
(203, 'LogParser-NLP', 'Log Analysis');

-- Model Deployments Data
INSERT INTO ModelDeployments VALUES
(301, 1, 201, '2025-06-01'),
(302, 2, 201, '2025-06-03'),
(303, 2, 202, '2025-06-10'),
(304, 3, 203, '2025-06-12');
--INNER JOIN - Show alerts with server names
SELECT 
  Alerts.alert_id,
  Alerts.alert_type,
  Alerts.severity,
  Servers.server_name
FROM Alerts
INNER JOIN Servers
  ON Alerts.server_id = Servers.server_id;

-- LEFT JOIN - Show all servers and any alerts
SELECT 
  Servers.server_id,
  Servers.server_name,
  Servers.region,
  Alerts.alert_type,
  Alerts.severity
FROM Servers
LEFT JOIN Alerts
  ON Servers.server_id = Alerts.server_id;

--  RIGHT JOIN - Show all alerts and server names (include alerts without servers)
-- (SQL Server supports RIGHT JOIN)
SELECT 
  Alerts.alert_id,
  Alerts.alert_type,
  Alerts.severity,
  Servers.server_name
FROM Alerts
RIGHT JOIN Servers
  ON Alerts.server_id = Servers.server_id;

--  FULL OUTER JOIN - All alerts and all servers (matched + unmatched)
SELECT 
  Servers.server_name,
  Alerts.alert_type,
  Alerts.severity
FROM Servers
FULL OUTER JOIN Alerts
  ON Servers.server_id = Alerts.server_id;

-- CROSS JOIN - Every server with every AI model
SELECT 
  Servers.server_name,
  AI_Models.model_name
FROM Servers
CROSS JOIN AI_Models;

--  INNER JOIN with filter - Only 'Critical' alerts with server name
SELECT 
  Alerts.alert_id,
  Alerts.alert_type,
  Servers.server_name
FROM Alerts
INNER JOIN Servers
  ON Alerts.server_id = Servers.server_id
WHERE Alerts.severity = 'Critical';

-- LEFT JOIN with NULL - Servers that do NOT have AI models deployed
SELECT 
  Servers.server_id,
  Servers.server_name
FROM Servers
LEFT JOIN ModelDeployments
  ON Servers.server_id = ModelDeployments.server_id
WHERE ModelDeployments.server_id IS NULL;

--  CROSS JOIN with filter - Possible deployments for EU servers only
SELECT 
  Servers.server_name,
  AI_Models.model_name
FROM Servers
CROSS JOIN AI_Models
WHERE Servers.region = 'eu-west';

