create or replace VIEW public.v_calendar_date AS
WITH CTE1 AS (
SELECT *,
	(current_timestamp AT TIME ZONE 'AESST')::date as today,
	CASE WHEN EXTRACT(month from (current_timestamp AT TIME ZONE 'AESST')::date) <= 6 THEN RIGHT(EXTRACT(year from (current_timestamp AT TIME ZONE 'AESST')::date)::text,2) ELSE RIGHT((extract(year from (current_timestamp AT TIME ZONE 'AESST')::date)+ 1)::text, 2) end as this_fy 
FROM public.calendar_date
)
SELECT *,
	CASE WHEN Date = Today THEN 1 ELSE 0 end as is_today,
	CASE WHEN Date < Today THEN 1 ELSE 0 end as is_before_today,
	CASE WHEN Date <= Today THEN 1 ELSE 0 end as is_on_or_before_today,
	CASE WHEN this_fy::int = short_fy THEN 1 ELSE 0 end as is_this_fy,
	case when today - interval '1 day' = Date THEN 1 ELSE 0 end as is_yesterday, 
	CASE WHEN week_ending = date + (7 - EXTRACT(ISODOW FROM date))::INT  THEN 1 ELSE 0 end as is_this_week,
	CASE WHEN first_day_of_month = today + (1 - EXTRACT(DAY FROM today))::INT THEN 1 ELSE 0 end as is_this_month,
	CASE WHEN today + (1 - EXTRACT(DAY FROM today))::INT - interval '6 month' <= Date AND  date_trunc('month', today) + interval '1 month - 1 day' >= Date THEN 1 ELSE 0 end as is_last_6_months,
	CASE WHEN today - interval '7 day' <= Date AND  Today >= Date THEN 1 ELSE 0 end is_last_7_days,
	CASE WHEN Week_ending = today + (0 - EXTRACT(ISODOW FROM today))::INT THEN 1 ELSE 0 END as is_last_week
FROM CTE1

go