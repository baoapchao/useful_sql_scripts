DROP TABLE if exists public.calendar_date;

CREATE TABLE public.calendar_date
(
--  date_dim_id              INT NOT NULL,
  date              DATE NOT NULL,
--  epoch                    BIGINT NOT NULL,
--  day_suffix               VARCHAR(4) NOT NULL,
  day_of_week_name                 VARCHAR(9) NOT NULL,
--  day_of_week              INT NOT NULL,
--  day_of_month             INT NOT NULL,
--  day_of_quarter           INT NOT NULL,
--  day_of_year              INT NOT NULL,
--  week_of_month            INT NOT NULL,
--  week_of_year             INT NOT NULL,
  week_of_year_iso         CHAR(10) NOT NULL,
  month_of_year             INT NOT NULL,
  month_name               VARCHAR(9) NOT NULL,
--  month_name_abbreviated   CHAR(3) NOT NULL,
  quarter_of_year           INT NOT NULL,
--  quarter_name             VARCHAR(9) NOT NULL,
  year              INT NOT NULL,
--  first_day_of_week        DATE NOT NULL,
  week_ending         DATE NOT NULL,
  first_day_of_month       DATE NOT NULL,
--  last_day_of_month        DATE NOT NULL,
  first_day_of_quarter     DATE NOT NULL,
--  last_day_of_quarter      DATE NOT NULL,
  first_day_of_year        DATE NOT NULL,
--  last_day_of_year         DATE NOT NULL,
--  mmyyyy                   CHAR(6) NOT NULL,
--  mmddyyyy                 CHAR(10) NOT NULL,
--  weekend_indr             BOOLEAN NOT null,
  financial_year		   text not null,
  short_fy	               int not null,
  date_int				   int not null,
  month_n_year			   int not null,
  quarter_n_year           int not null,
  month_in_calendar		   text not null
);

ALTER TABLE public.CalendarDate ADD CONSTRAINT CalendarDate_date_dim_id_pk PRIMARY KEY (date_dim_id);

CREATE INDEX CalendarDate_date_actual_idx
  ON CalendarDate(date_actual);

COMMIT;

INSERT INTO public.calendar_date
SELECT 
--		TO_CHAR(datum, 'yyyymmdd')::INT AS date_dim_id,
       datum AS date,
--       EXTRACT(EPOCH FROM datum) AS epoch,
--       TO_CHAR(datum, 'fmDDth') AS day_suffix,
       TO_CHAR(datum, 'TMDay') AS day_of_week_name,
--       EXTRACT(ISODOW FROM datum) AS day_of_week,
--       EXTRACT(DAY FROM datum) AS day_of_month,
--       datum - DATE_TRUNC('quarter', datum)::DATE + 1 AS day_of_quarter,
--       EXTRACT(DOY FROM datum) AS day_of_year,
--       TO_CHAR(datum, 'W')::INT AS week_of_month,
--       EXTRACT(WEEK FROM datum) AS week_of_year,
       EXTRACT(ISOYEAR FROM datum) || TO_CHAR(datum, '"-W"IW-') || EXTRACT(ISODOW FROM datum) AS week_of_year_iso,
       EXTRACT(MONTH FROM datum) AS month_of_year,
       TO_CHAR(datum, 'TMMonth') AS month_name,
--       TO_CHAR(datum, 'Mon') AS month_name_abbreviated,
       EXTRACT(QUARTER FROM datum) AS quarter_of_year,
--       CASE
--           WHEN EXTRACT(QUARTER FROM datum) = 1 THEN 'First'
--           WHEN EXTRACT(QUARTER FROM datum) = 2 THEN 'Second'
--           WHEN EXTRACT(QUARTER FROM datum) = 3 THEN 'Third'
--           WHEN EXTRACT(QUARTER FROM datum) = 4 THEN 'Fourth'
--           END AS quarter_name,
       EXTRACT(YEAR FROM datum) AS year,
--       datum + (1 - EXTRACT(ISODOW FROM datum))::INT AS first_day_of_week,
       datum + (7 - EXTRACT(ISODOW FROM datum))::INT AS week_ending,
       datum + (1 - EXTRACT(DAY FROM datum))::INT AS first_day_of_month,
--       (DATE_TRUNC('MONTH', datum) + INTERVAL '1 MONTH - 1 day')::DATE AS last_day_of_month,
       DATE_TRUNC('quarter', datum)::DATE AS first_day_of_quarter,
--       (DATE_TRUNC('quarter', datum) + INTERVAL '3 MONTH - 1 day')::DATE AS last_day_of_quarter,
       TO_DATE(EXTRACT(YEAR FROM datum) || '-01-01', 'YYYY-MM-DD') AS first_day_of_year,
--       TO_DATE(EXTRACT(YEAR FROM datum) || '-12-31', 'YYYY-MM-DD') AS last_day_of_year,
--       TO_CHAR(datum, 'mmyyyy') AS mmyyyy,
--       TO_CHAR(datum, 'mmddyyyy') AS mmddyyyy,
--       CASE
--           WHEN EXTRACT(ISODOW FROM datum) IN (6, 7) THEN TRUE
--           ELSE FALSE
--           END AS weekend_indr,
       'FY' || CASE WHEN date_part('Month', datum) <= 6 THEN RIGHT(cast(date_part('Year', datum) as text), 2) ELSE RIGHT(cast(date_part('Year', datum) + 1 as text), 2) end as financial_year,
       CASE WHEN date_part('Month', datum) <= 6 THEN RIGHT(cast(date_part('Year', datum) as text), 2)::int ELSE RIGHT(cast(date_part('Year', datum) + 1 as text) , 2)::int end as short_fy,
       TO_CHAR(datum, 'yyyymmdd')::int as date_int,
       date_part('YEAR', datum) * 10000 + date_part('MONTH', datum) * 100 as month_n_year,
       date_part('YEAR', datum) * 1000 + date_part('Quarter', datum) * 100 as quarter_n_year,
       TO_CHAR(datum, 'Mon') || ' ' || EXTRACT(YEAR FROM datum) as month_in_calendar
       
FROM (SELECT '2014-01-01'::DATE + SEQUENCE.DAY AS datum
      FROM GENERATE_SERIES(0, 4000) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) DQ
ORDER BY 1;


select * from public.calendar_date


