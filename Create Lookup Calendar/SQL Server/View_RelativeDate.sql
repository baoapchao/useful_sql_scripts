USE [boody_xero]
GO

/****** Object:  View [dbo].[v_relativedate]    Script Date: 11/21/2021 1:33:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_relativedate] AS (
SELECT Date, [Relative Date]
FROM [boody_xero].[dbo].[v_calendardate]
UNPIVOT
(
	Score
	FOR [Relative Date] in ([isToday]
      ,[isBeforeToday]
      ,[isOnorBeforeToday]
      ,[isThisFYEAR]
      ,[isYesterday]
      ,[isThisWeek]
      ,[isThisMonth]
      ,[isLast6Months]
      ,[isLast7Days])
) AS DateUnpivot
WHERE Score = 1
)
GO

