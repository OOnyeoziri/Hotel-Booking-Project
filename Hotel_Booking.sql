--Which market segment generates the highest revenue? 
Select top 1 Market_Segment, sum (Revenue) as TotalRevenue
From Hotel_Booking
Group by market_segment
Order by TotalRevenue desc

--What is the average lead time for bookings? 
Select Hotel_Type, avg (lead_time) as AvgLeadTime 
From Hotel_Booking
Group by Hotel_Type

--Which room types have the highest cancellation rates?
Select top 3 Reserved_Room_Type, count (*) as TotalBookings,
Sum (Case When Is_Canceled = 1 Then 1 Else 0 End) as CancelledBookings,
Cast (Sum (Case When Is_Canceled = 1 Then 1 Else 0 End) as FLOAT) / Count (*) as CancellationRate
From Hotel_Booking
Group by reserved_Room_Type
Order by CancellationRate Desc;

--How many bookings were made per market segment? 
Select Market_Segment, count (*) as TotalBookings
From Hotel_Booking
Group by Market_Segment
Order by TotalBookings Desc;

--What is the distribution of bookings across customer types? 
Select Customer_Type, count (*) as TotalBookings
From Hotel_Booking
Group by Customer_Type
Order by TotalBookings Desc;

--Which room types generate the highest revenue?
Select top 5 Reserved_Room_Type, sum (Revenue) as TotalRevenue
From Hotel_Booking
Group by Reserved_Room_Type
Order by TotalRevenue Desc;

--During which season is the revenue highest?
Select top 1 Season, sum (Revenue) as TotalRevenue
From Hotel_Booking
Group by Season
Order by TotalRevenue Desc;

--Which countries have the most bookings? 
Select top 10 Country, count (*) as TotalBookings
From Hotel_Booking
Group by Country
Order by TotalBookings Desc;

--What is the ratio of repeat customers versus new customers?
Select Is_Repeated_Guest, Count (*) as TotalBookings
From Hotel_Booking
Where Is_Repeated_Guest >= 1
Group by Is_Repeated_Guest;

--What are the monthly trends in booking numbers?
Select DateName (month, Arrival_Date) as Monthname, Year(Arrival_Date) as Year, Count (*) as Totalbookings
From Hotel_Booking
Group by DateName (month, Arrival_Date), Year(Arrival_Date)
Order by DateName (month, Arrival_Date) Desc;

--Lead time versus Cancellation analysis
Select Lead_Time, Count (*) AS TotalBookings, Sum (CASE WHEN Is_Canceled = 1 THEN 1 ELSE 0 END) AS CancelledBookings
From Hotel_Booking
Group by Lead_Time
Order by Lead_Time;

--Customers with the most cancellations
Select TOP 10 Name, Count(*) AS CancelledBookings
From Hotel_Booking
Where Is_Canceled = 1
Group by Name
Order by CancelledBookings Desc;

--Comparing Weekday/Weeknight vs Weekend Bookings
Select
CASE When DateName (Weekday, Arrival_Date) IN ('Saturday', 'Sunday') Then 'Weekend' Else 'WeekNight'
END AS BookingType, Count(*) AS TotalBookings
From Hotel_Booking
Group by 
CASE When DateName (Weekday, Arrival_Date) IN ('Saturday', 'Sunday') Then 'Weekend' Else 'WeekNight'
END;

--Market Segment with the highest and preferred deposit type
Select Market_Segment, Deposit_Type, Count (Deposit_Type) as TotalDepositType
From Hotel_Booking
Group by Market_Segment, Deposit_Type
Order by TotalDepositType Desc;

--Total number of deposit types made for bookings
Select distinct Deposit_Type, Count (Deposit_Type) as DepositType
From Hotel_Booking
Group by Deposit_Type

--Total Monthly Revenue 
Select Year (Arrival_Date) as Year, DateName (month, Arrival_Date) as MonthName, Sum (Revenue) as TotalRevenue
From Hotel_Booking
Group by Year (Arrival_Date), DateName (month, Arrival_Date) 
Order by Year, MonthName Desc;

--Average Lead Time per Market Segment and Hotel Type
Select Hotel_Type, Market_Segment, Avg (Lead_Time) as AvgLeadTime
From Hotel_Booking
Group by Hotel_Type, Market_Segment
Order by Market_Segment

--Monthly Cancellation rate
Select Year (Arrival_Date) as Year, DateName (month, Arrival_Date) as MonthName, Reserved_Room_Type, Count (*) as TotalBookings,
Sum (CASE When Is_Canceled = 1 THEN 1 ELSE 0 END) AS CanceledBookings,
CAST(Sum (CASE When Is_Canceled = 1 THEN 1 ELSE 0 END) * 100.0 / Count (*) as DECIMAL(5,1)) as CancellationRate
From Hotel_Booking
GROUP BY Year (Arrival_Date), DateName (month, Arrival_Date), Reserved_Room_Type
ORDER BY CancellationRate Desc;

--Average Daily rate (Adr) by Room Type
SELECT Reserved_Room_Type, Round (Avg (Adr),2) as AvgDailyRate
From Hotel_Booking
Group by Reserved_Room_Type
Order by Reserved_Room_Type;

--Average Length of Stay by Room Type
Select Reserved_Room_Type, Avg (DateDiff (Day, Reservation_Status_Date, Arrival_Date)) as AvgStayDuration
From Hotel_Booking
Group by Reserved_Room_Type
Order by AvgStayDuration Desc;

--Ratio of Repeat versus New customers
WITH cte AS (SELECT SUM(CASE WHEN Customer_Type = 'Repeat' THEN 1 ELSE 0 END) AS RepeatBookings,
SUM(CASE WHEN Customer_Type = 'New' THEN 1 ELSE 0 END) AS NewBookings
FROM Hotel_Booking)
SELECT RepeatBookings, NewBookings,
CAST(RepeatBookings * 1.0 / NULLIF(NewBookings, 0) AS DECIMAL(5,2)) AS RepeatToNewRatio
FROM cte;


Select *
From Hotel_Booking
 