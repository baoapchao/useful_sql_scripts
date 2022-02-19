USE boody_xero
GO

/****** Object:  StoredProcedure [dbo].[CreateCalendarTable]    Script Date: 11/21/2021 1:17:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[CreateCalendarTable] (@StartDate date, @NumberOfYear int, @FiscalYearEndMonth INT) AS 
BEGIN

DECLARE @CutoffDate date = DATEADD(DAY, -1, DATEADD(YEAR, @NumberOfYear, @StartDate));

;WITH seq(n) AS 
(
  SELECT 0 UNION ALL SELECT n + 1 FROM seq
  WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
),
d(d) AS 
(
  SELECT DATEADD(DAY, n, @StartDate) FROM seq
),
src AS
(
  SELECT
    Date               = CONVERT(date, d),
	Year               = DATEPART(YEAR,      d),
	QuarterOfYear      = DATEPART(Quarter,   d),
	MonthOfYear        = DATEPART(MONTH,     d),
    DayOfMonth         = DATEPART(DAY,       d),
	DateInt		       = FORMAT(d, 'yyyymmdd'),
	MonthName          = DATENAME(MONTH,     d),
	MonthInCalendar    = FORMAT(d, 'MMM yyyy'),
	QuarterInCalendar  = 'Q' + CONVERT(NVARCHAR(5) , DATEPART(Quarter,   d)) + ' ' + CONVERT(NVARCHAR(5) , DATEPART(YEAR, d)), 
    DayInWeek          = DATEPART(WEEKDAY,   d), 
    DayOfWeekName      = DATENAME(WEEKDAY,   d),
	WeekEnding         = DATEADD(dd, 7-(DATEPART(dw, d)), d), --end saturday
    [Week Number]      = DATEPART(WEEK,      d),
    --TheISOWeek       = DATEPART(ISO_WEEK,  d),
	MonthnYear         = DATEPART(YEAR, d) * 1000 + DATEPART(MONTH, d) * 100,
	QuarternYear       = DATEPART(YEAR, d) * 1000 + DATEPART(Quarter, d) * 100,
	ShortYear          = FORMAT(d, 'yy'),
	FY                 = 'FY' + CASE WHEN DatePart(Month, d) <= @FiscalYearENdMonth THEN RIGHT(DatePart(Year, d), 2) ELSE RIGHT((DatePart(Year, d) + 1) , 2) END ,
    --TheFirstOfMonth  = DATEFROMPARTS(YEAR(d), MONTH(d), 1),
    --TheLastOfYear    = DATEFROMPARTS(YEAR(d), 12, 31),
    --TheDayOfYear     = DATEPART(DAYOFYEAR, d),
	ShortFinancialYear = CASE WHEN DatePart(Month, d) <= @FiscalYearENdMonth THEN RIGHT(DatePart(Year, d), 2) ELSE RIGHT((DatePart(Year, d) + 1) , 2) END 
  FROM d
)
SELECT *
INTO dbo.CalendarDate
FROM src
  ORDER BY Date
  OPTION (MAXRECURSION 0)
/*  
DROP TABLE dbo.CalendarDate

EXEC [dbo].[CreateCalendarTable] @StartDate = '2014-01-01', @NumberOfYear = 11, @FiscalYearEndMonth = 6
*/
 
END;
GO


