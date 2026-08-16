Use FragranceProject;
GO

Select Top(10) *
From dbo.FragranceDataSet;

Select Count(*) as imported_row_count
From dbo.FragranceDataSet;

EXEC sp_help 'dbo.FragranceDataSet';

-- Changed score column to have 2 decimal places
Alter Table dbo.FragranceDataSet
Alter Column score Decimal(4,2) Null;

-- Changed price column to have 2 decimal places
Alter Table dbo.FragranceDataSet
Alter Column retail_price_usd Decimal(10,2) Null;

-- Create a Brands table to give indentifiers to each unique brand 
Create Table dbo.Brands
(
	brand_id INT IDENTITY(1,1) NOT NULL,
	brand_name NVARCHAR(200) NOT NULL,
	CONSTRAINT PK_Brands
		PRIMARY KEY (brand_id),
	CONSTRAINT UQ_Brands_BrandName
		UNIQUE (brand_name)
); 
GO

-- Create a Fragrance table that stores Brands as unique identifiers rather than name
Create Table dbo.Fragrances
(
	fragrance_id INT IDENTITY(1,1) NOT NULL,
	fragrance_rank INT NOT NULL,
	fragrance_name NVARCHAR (200) NOT NULL,
	brand_id INT NOT NULL,
	positive_votes INT NULL,
	negative_votes INT NULL,
	gender NVARCHAR(50) NULL,
	release_year INT NULL,
	score DECIMAL(4,2) NULL,
	retail_price_usd DECIMAL (10,2) NULL,
	bottle_size_ml INT NULL,

	CONSTRAINT PK_Fragrances
		PRIMARY KEY (fragrance_id),
	CONSTRAINT UQ_Fragrances_Rank
		UNIQUE (fragrance_rank),
	CONSTRAINT FK_Fragrances_Brands
		FOREIGN KEY (brand_id)
		REFERENCES dbo.Brands(brand_id)
);
GO

-- Creates Perfumers table giving identifieres to unique perfumers
CREATE TABLE dbo.Perfumers
(
	perfumer_id INT IDENTITY(1,1) NOT NULL,
	perfumer_name NVARCHAR(200) NOT NULL,

	CONSTRAINT PK_Perfumers
		PRIMARY KEY (perfumer_id),

	CONSTRAINT UQ_Perfumers_PerfumerName
		UNIQUE(perfumer_name)
);
GO

-- Junction table between Fragrances Table and Perfumers
CREATE TABLE dbo.FragrancePerfumers
(
	fragrance_id INT NOT NULL,
	perfumer_id INT NOT NULL,

	CONSTRAINT PK_FragrancePerfumers
		PRIMARY KEY (fragrance_id, perfumer_id),
	CONSTRAINT FK_FragrancePerfumers_Fragrances
		FOREIGN KEY (fragrance_id)
		REFERENCES dbo.Fragrances(fragrance_id),
	CONSTRAINT FK_FragrancePerfumers_Perfumers
		FOREIGN KEY (perfumer_id)
		REFERENCES dbo.Perfumers(perfumer_id)
);
GO

-- Creates Notes table giving identifieres to unique Notes 
CREATE TABLE dbo.Notes
(
	note_id INT IDENTITY(1,1) NOT NULL,
	note_name NVARCHAR(255) NOT NULL,

	CONSTRAINT PK_Notes
		PRIMARY KEY (note_id),
	CONSTRAINT UQ_Notes_NoteName
		UNIQUE (note_name)
);
GO

-- Junction table between Fragrances Table and Notes
CREATE TABLE dbo.FragranceNotes
(
	fragrance_id INT NOT NULL,
	note_id INT NOT NULL,
	note_position VARCHAR(10) NOT NULL,
	note_order INT NULL,

	CONSTRAINT PK_Fragrance_Notes
		PRIMARY KEY
		(
			fragrance_id,
			note_id,
			note_position
		),
	CONSTRAINT FK_FragranceNotes_Fragrances
		FOREIGN KEY (fragrance_id)
		REFERENCES dbo.Fragrances(fragrance_id),
	CONSTRAINT FK_Fragrances_Notes
		FOREIGN KEY (note_id)
		REFERENCES dbo.Notes(note_id),
	CONSTRAINT CK_FragranceNotes_Position
		CHECK
		(
			note_position IN
			(
				'Top',
				'Middle',
				'Base',
				'Linear'
			)
		)
);
GO

-- Creates Accords table giving identifieres to unique accords 
CREATE TABLE dbo.Accords
(
	accord_id INT IDENTITY(1,1) NOT NULL,
	accord_name NVARCHAR(100) NOT NULL,
	
	CONSTRAINT PK_Accords
		PRIMARY KEY (accord_id),
	CONSTRAINT UQ_Accords_AccordName
		UNIQUE (accord_name)
);
GO

-- Junction table between Fragrances Table and Accords
CREATE TABLE dbo.FragranceAccords
(
	fragrance_id INT NOT NULL,
	accord_id INT NOT NULL,
	accord_order INT NULL,

	CONSTRAINT PK_FragranceAccords
		PRIMARY KEY (fragrance_id, accord_id),
	CONSTRAINT FL_FragranceAccords_Fragrances
		FOREIGN KEY (fragrance_id)
		REFERENCES dbo.Fragrances(fragrance_id),
	CONSTRAINT FK_FragranceAccords_Accords
		FOREIGN KEY (accord_id)
		REFERENCES dbo.Accords(accord_id)
);
GO

-- Creates Seasons table giving identifieres to unique seasons 
CREATE TABLE dbo.Seasons
(
	season_id INT IDENTITY(1,1) NOT NULL,
	season_name VARCHAR(50) NOT NULL,

	CONSTRAINT PK_Seasons
		PRIMARY KEY (season_id),
	CONSTRAINT UQ_Seasons_SeasonName
		UNIQUE (season_name)
);
GO

-- Junction table between Fragrances Table and Seasons
CREATE TABLE dbo.FragranceSeasons
(
	fragrance_id INT NOT NULL,
	season_id INT NOT NULL,

	CONSTRAINT PK_FragranceSeasons
		PRIMARY KEY (fragrance_id, season_id),
	CONSTRAINT FK_FragranceSeasons_Fragrances
		FOREIGN KEY (fragrance_id)
		REFERENCES dbo.Fragrances(fragrance_id),
	CONSTRAINT FK_FragrancesSeasons_Seasons
		FOREIGN KEY (season_id)
		REFERENCES dbo.Seasons(season_id)
);
GO

-- Creates TimeOfDay table giving identifieres to unique time of day 
CREATE TABLE dbo.TimesOfDay
(
	time_id INT IDENTITY(1,1) NOT NULL,
	time_name VARCHAR(20) Not NULL,

	CONSTRAINT PK_TimesOfDay
		PRIMARY KEY (time_id),
	CONSTRAINT UQ_TimesOfDay_TimeName
		UNIQUE (time_name)
);
GO

-- Junction table between Fragrances Table and TimeOfDays
CREATE TABLE dbo.FragranceTimes
(
	fragrance_id INT NOT NULL,
	time_id INT NOT NULL,

	CONSTRAINT PK_FragranceTimes
		PRIMARY KEY (fragrance_id, time_id),
	CONSTRAINT FK_FragranceTimes_Fragrances
		FOREIGN KEY (fragrance_id)
		REFERENCES dbo.Fragrances(fragrance_id),
	CONSTRAINT FK_FragranceTimes_TimesOfDay
		FOREIGN KEY (time_id)
		REFERENCES dbo.TimesOfDay(time_id)
);
GO

INSERT INTO dbo.Seasons (season_name)
VALUES
	('Spring'),
	('Summer'),
	('Fall'),
	('Winter');

INSERT INTO dbo.TimesOfDay (time_name)
VALUES
	('Day'),
	('Night');
GO

SELECT name as table_name
FROM sys.tables
ORDER BY name;


-- In the Perfumer Table, split the names using ',' as a delimiter and give each unique perfumer an identifier
INSERT INTO dbo.Perfumers
(
	perfumer_name
)
SELECT DISTINCT
	TRIM(s.value) AS perfumer_name
FROM dbo.FragranceDataSet AS fs
CROSS Apply string_split
(
	REPLACE(
		REPLACE(fs.perfumer, CHAR(13), ''),
		CHAR(10),
		','
	),
	','
) AS s
WHERE NULLIF(TRIM(s.value), '') IS NOT NULL
	AND NOT EXISTS
	(
		SELECT 1
		FROM dbo.Perfumers AS p
		WHERE p.perfumer_name = TRIM(s.value)
);

-- From FragranceDataSet Table, insert brand into the Brands Table 
Insert Into dbo.Brands
(
	brand_name
)
Select distinct
	Trim(brand)
From dbo.FragranceDataSet
Where NULLIF(Trim(brand),'') IS NOT NULL;
GO

Select *
From dbo.Brands
Order by brand_name;

-- Filling Fragrances Table with info from FragranceDataSet and Brands Table with unique identifieres instead of names
Insert Into dbo.Fragrances
(
	fragrance_rank,
	fragrance_name,
	brand_id,
	positive_votes,
	negative_votes,
	gender,
	release_year,
	score,
	retail_price_usd,
	bottle_size_ml
)
Select 
	fs.rank,
	fs.fragrance_name,
	b.brand_id,
	fs.positive_votes,
	fs.negative_votes,
	fs.gender,
	fs.year,
	fs.score,
	fs.retail_price_usd,
	fs.bottle_size_ml
From dbo.FragranceDataSet as fs
join dbo.Brands as b
on b.brand_name = fs.brand;
GO

-- Insert unique perfumers from FDS into P Table
Select Count(*) as fragrance_count
from dbo.Fragrances;

Insert Into dbo.Perfumers
(
	perfumer_name
)
Select Distinct Trim(split_value.value)
From dbo.FragranceDataSet as fds
cross apply string_split(fds.perfumer, ',') as split_value
where NULLIF(Trim(split_value.value),'')IS NOT NULL
And Not Exists
(
	Select 1 
	From dbo.Perfumers as p
	Where p.perfumer_name =Trim(split_value.value)
);
GO

--Connect each Fragrance to its Perfumers
Insert INTO dbo.FragrancePerfumers
(
	fragrance_id,
	perfumer_id
)
Select DISTINCT 
	f.fragrance_id,
	p.perfumer_id
From dbo.FragranceDataSet as fds
join dbo.Fragrances as f
on f.fragrance_rank = fds.[rank]
CROSS apply string_split(fds.perfumer,',') as split_value
join dbo.Perfumers as p
on p.perfumer_name = trim(split_value.value)
where NULLIF(trim(split_value.value), '') IS NOT NULL;
GO

Select Top(20)
	f.fragrance_name, 
	p.perfumer_name
From dbo.FragrancePerfumers as fp
join dbo.Fragrances as f
on f.fragrance_id = fp.fragrance_id
join Perfumers as p
on p.perfumer_id = fp.perfumer_id
order by f.fragrance_rank;

-- Gather all note from different columns
Insert into dbo.Notes
(
	note_name
)
Select Distinct note_name
From
(
	Select Trim(s.value) as note_name
	From dbo.FragranceDataSet as fds
	Cross Apply string_split(fds.top_notes, ',') as s
	Union
	Select Trim(s.value) as note_name
	From dbo.FragranceDataSet as fds
	Cross Apply string_split(fds.middle_notes, ',') as s
	Union
	Select Trim(s.value) as note_name
	From dbo.FragranceDataSet as fds
	Cross Apply string_split(fds.base_notes, ',') as s
	Union
	Select Trim(s.value) as note_name
	From dbo.FragranceDataSet as fds
	Cross Apply string_split(fds.linear_notes, ',') as s
) as combined_notes
Where NULLIF(note_name, '') IS NOT NULL;
GO

-- Connecting Fragrances to Top Notes
Insert Into dbo.FragranceNotes
(
	fragrance_id,
	note_id,
	note_position,
	note_order
)
Select Distinct
	f.fragrance_id,
	n.note_id,
	'Top',
	Convert(INT, s.ordinal)
From dbo.FragranceDataSet as fds
join dbo.Fragrances as f
on f.fragrance_rank = fds.[rank]
cross apply string_split(fds.top_notes, ',', 1) as s
join dbo.Notes as n
on n.note_name = trim(s.value)
Where NULLIF(Trim(s.value), '') IS NOT NULL;
GO
-- Connecting Fragrances to Middle Notes
Insert Into dbo.FragranceNotes
(
	fragrance_id,
	note_id,
	note_position,
	note_order
)
Select Distinct
	f.fragrance_id,
	n.note_id,
	'Middle',
	Convert(INT, s.ordinal)
From dbo.FragranceDataSet as fds
join dbo.Fragrances as f
on f.fragrance_rank = fds.[rank]
cross apply string_split(fds.middle_notes, ',', 1) as s
join dbo.Notes as n
on n.note_name = trim(s.value)
Where NULLIF(Trim(s.value), '') IS NOT NULL;
GO
-- Connecting Fragrances to Base Notes
Insert Into dbo.FragranceNotes
(
	fragrance_id,
	note_id,
	note_position,
	note_order
)
Select Distinct
	f.fragrance_id,
	n.note_id,
	'Base',
	Convert(INT, s.ordinal)
From dbo.FragranceDataSet as fds
join dbo.Fragrances as f
on f.fragrance_rank = fds.[rank]
cross apply string_split(fds.base_notes, ',', 1) as s
join dbo.Notes as n
on n.note_name = trim(s.value)
Where NULLIF(Trim(s.value), '') IS NOT NULL;
GO
-- Connecting Fragrances to Linear Notes
Insert Into dbo.FragranceNotes
(
	fragrance_id,
	note_id,
	note_position,
	note_order
)
Select Distinct
	f.fragrance_id,
	n.note_id,
	'Linear',
	Convert(INT, s.ordinal)
From dbo.FragranceDataSet as fds
join dbo.Fragrances as f
on f.fragrance_rank = fds.[rank]
cross apply string_split(fds.linear_notes, ',', 1) as s
join dbo.Notes as n
on n.note_name = trim(s.value)
Where NULLIF(Trim(s.value), '') IS NOT NULL;
GO

-- Inserting accords split by delimiter ','
Insert Into dbo.Accords
(
	accord_name
)
Select Distinct
	Lower(Trim(s.value))
From dbo.FragranceDataSet as fds
cross apply string_split(fds.main_accords, ',') as s
where NULLIF(TRIM(s.value), '') IS NOT NULL;
GO

-- Connecting Fragrances to Accords
With AccordList as
(
	Select
		f.fragrance_id,
		a.accord_id,
		MIN(Convert(INT, s.ordinal)) as accord_order
	From dbo.FragranceDataSet as fds
	Join dbo.Fragrances as f
	on f.fragrance_rank = fds.[rank]
	Cross Apply string_split(fds.main_accords, ',', 1) as s
	join dbo.Accords as a
	on a.accord_name = Lower(Trim(s.value))
	Where  NULLIF(Trim(s.value), '') IS NOT NULL
	Group By f.fragrance_id, a.accord_id
)
Insert Into dbo.FragranceAccords
(
	fragrance_id,
	accord_id,
	accord_order
)
Select 
	al.fragrance_id,
	al.accord_id,
	al.accord_order
From AccordList as al
WHERE NOT Exists
(
	Select 1 
	from dbo.FragranceAccords as fa
	Where fa.fragrance_id = al.fragrance_id
	and fa.accord_id = al.accord_id
);
GO

-- Inserting Seasons 
INSERT INTO dbo.Seasons (season_name)
VALUES
	('Spring'),
	('Summer'),
	('Fall'),
	('Winter');
GO

-- Connect Fragrances to Seasons
Insert Into dbo.FragranceSeasons
(
	fragrance_id,
	season_id
)
Select Distinct
	f.fragrance_id,
	se.season_id
From dbo.FragranceDataSet as fds
Join dbo.Fragrances as f
on f.fragrance_rank = fds.[rank]
cross apply string_split(fds.recommended_seasons, ',',1) as s
join dbo.Seasons as se
on se.season_name = lower(trim(s.value))
Where NULLIF(trim(s.value), '') IS NOT NULL
AND NOT EXISTS
(
	Select 1
	From dbo.FragranceSeasons as fs
	Where fs.fragrance_id = f.fragrance_id
	and fs.season_id = se.season_id
);
GO

--Insert Time values
INSERT INTO dbo.TimesOfDay (time_name)
VALUES
	('Day'),
	('Night');
GO

--Connect Fragrances with Time
Insert Into dbo.FragranceTimes
(
	fragrance_id,
	time_id
)
Select Distinct
	f.fragrance_id,
	tod.time_id
From dbo.FragranceDataSet as fds
join dbo.Fragrances as f
on f.fragrance_rank = fds.[rank]
cross apply string_split(fds.recommended_time, ',') as s
join dbo.TimesOfDay as tod
on tod.time_name = trim(s.value)
where nullif(trim(s.value), '') IS NOT NULL;
GO

--Count Rows in main tables
Select 'FragranceDataSet' as table_name, count(*) as row_count
From dbo.FragranceDataSet
UNION ALL
Select 'Brands', count(*)
From dbo.Brands
UNION ALL
Select 'Fragrances', count(*)
From dbo.Fragrances
UNION ALL
Select 'Perfumers', count(*)
From dbo.Perfumers
UNION ALL
Select 'FragrancePerfumers', count(*)
From dbo.FragrancePerfumers
UNION ALL
Select 'Notes', count(*)
From dbo.Notes
UNION ALL
Select 'FragranceNotes', count(*)
From dbo.FragranceNotes
UNION ALL
Select 'Accords', count(*)
From dbo.Accords
UNION ALL
Select 'FragranceAccords', count(*)
From dbo.FragranceAccords
UNION ALL
Select 'FragranceSeasons', count(*)
FROM dbo.FragranceSeasons
UNION ALL
Select 'FragranceTimes', count(*)
From dbo.FragranceTimes;

--Check for fragrances that failed to load
Select
	fds.[rank],
	fds. fragrance_name,
	fds.brand
from dbo.FragranceDataSet as fds
left join dbo.Fragrances as f
on f.fragrance_rank = fds.[rank]
where f.fragrance_id IS NULL;
--Returned zero rows, all set

--Check for missing perfumer relationships
Select
	f.fragrance_rank,
	f.fragrance_name,
	n.note_name,
	fn.note_position,
	fn.note_order
From dbo.Fragrances as f
join dbo.FragranceNotes as fn
on fn.fragrance_id = f.fragrance_id
join dbo.Notes as n
on n.note_id = fn.note_id
where f.fragrance_name = 'Aventus'
order by 
	case fn.note_position
	when 'Top' then 1
	when 'Middle' then 2
	when 'Base' then 3
	when 'Linear' then 4
End,
fn.note_order;

--Fragances containing vanilla
Select Distinct
	f.fragrance_rank,
	f.fragrance_name,
	b.brand_name,
	fn.note_position,
	f.score
From dbo.Fragrances as f
join dbo.Brands as b
on b.brand_id = f.brand_id
join dbo.FragranceNotes as fn
on fn.fragrance_id = f.fragrance_id
join dbo.Notes as n
on n.note_id = fn.note_id
where n.note_name = 'Vanilla'
order by f.fragrance_rank;

--Count number of fragrances from each Brand 
Select Top 10 brand, count(*) as count
From dbo.FragranceDataSet
Group By brand
Order by count desc;

-- Highest ranked fragances per brand
With By_Brand as (
	Select f.fragrance_rank, b.brand_name, f.fragrance_name, 
	ROW_NUMBER()over(partition by b.brand_id order by f.fragrance_rank) as fragrance_order
	From dbo.Fragrances as f
	Join dbo.Brands as b
	on f.brand_id = b.brand_id)
Select brand_name, fragrance_name, fragrance_rank
From By_Brand
Where fragrance_order = 1
Order by fragrance_rank;

--Average score by brand
--Used CAST instead of ROUND because CAST changes the displayed data type to 2 decimal places, while ROUND only changes the value 
Select b.brand_name, cast(avg(f.score) as decimal(4,2)) as avg_score
From dbo.Fragrances as f
Join dbo.Brands as b
on f.brand_id = b.brand_id
group by b.brand_id, b.brand_name
order by avg(f.score) desc;

--Most profilic perfumers
Select Top 10 p.perfumer_name, count(*) as number_of_fragrances
From dbo.Fragrances as f
Join dbo.FragrancePerfumers as fp
on f.fragrance_id = fp.fragrance_id
Join dbo.Perfumers as p
on fp.perfumer_id = p.perfumer_id
Group by p.perfumer_id, p.perfumer_name
Order by number_of_fragrances desc;

--Most Common Notes 
Select Top 10 n.note_name, count(*) as Times_Used
From dbo.Fragrances as f
Join dbo.FragranceNotes as fn
on f.fragrance_id = fn.fragrance_id
Join dbo.Notes as n
on fn.note_id = n.note_id
Group by n.note_id, n.note_name
order by Times_Used desc;

--Most Common Accords
Select Top 10 a.accord_name, count(*) as Times_Used
From dbo.Fragrances as f
Join dbo.FragranceAccords as fa
on f.fragrance_id = fa.fragrance_id
Join dbo.Accords as a
on fa.accord_id = a.accord_id
Group by a.accord_id, a.accord_name
order by Times_Used desc;

--Most Common Seasons
Select s.season_name, count(*) as Times_Used
From dbo.Fragrances as f
Join dbo.FragranceSeasons as fs
on f.fragrance_id = fs.fragrance_id
Join dbo.Seasons as s
on fs.season_id = s.season_id
Group by s.season_id, s.season_name
order by Times_Used desc;


--Average score by season
Select s.season_name, cast(avg(f.score) as decimal(4,2)) as avg_score
From dbo.Fragrances as f
Join dbo.FragranceSeasons as fs
on f.fragrance_id = fs.fragrance_id
Join dbo.Seasons as s
on fs.season_id = s.season_id
Group by s.season_id, s.season_name
order by avg_score desc;

--Avergae price by Brand
Select b.brand_name, 
cast(avg(f.retail_price_usd *100.00 / nullif(f.bottle_size_ml,0)) as decimal(10,2)) as Avg_Per_100ml
From dbo.Fragrances as f
Join Brands as b
on f.brand_id = b.brand_id
Group by b.brand_id, b.brand_name
Order by Avg_Per_100ml desc;

--Fragrances with multiple perfumers
--STRING_AGG is used to concatenate values from multiple rows into a single string, seperated by a delimiter
Select b.brand_name, f.fragrance_name, string_agg(p.perfumer_name, ', ') as perfumers, count(distinct(p.perfumer_id)) as num_of_perfumers
From dbo.Fragrances as f
Join dbo.FragrancePerfumers as fp
On f.fragrance_id = fp.fragrance_id
Join Perfumers as p
On fp.perfumer_id = p.perfumer_id
Join dbo.Brands as b
on f.brand_id = b.brand_id
Group by f.fragrance_id, b.brand_name, f.fragrance_name
Having count(distinct(p.perfumer_id)) > 1
Order by count(distinct(p.perfumer_id)) desc;

--Top 10 most expensive fragrances
Select top 10 b.brand_name, f.fragrance_name, 
cast(f.retail_price_usd *100.00 / f.bottle_size_ml as decimal(10,2)) as Avg_Per_100ml
From dbo.Fragrances as f
Join Brands as b
on f.brand_id = b.brand_id
Order by Avg_Per_100ml desc;

--Rank fragrances within each brand
Select b.brand_name, f.fragrance_name, f.score,ROW_NUMBER()over(partition by b.brand_id order by f.fragrance_rank) as ranking
From dbo.Fragrances as f
Join dbo.Brands as b
On f.brand_id = b.brand_id;

--Notes in fragrances rated above 4.5 
Select b.brand_name, f.fragrance_name, f.score, string_agg(n.note_name, ', ') as notes
From dbo.Fragrances as f
Join FragranceNotes as fn
On f.fragrance_id = fn.fragrance_id
Join dbo.Notes as n
On fn.note_id = n.note_id
Join Brands b
On f.brand_id = b.brand_id
Where f.score > 4.50
Group By f.fragrance_id, b.brand_name, f.fragrance_name, f.score
Order by f.score desc;

--Perfumers with the highest average fragrance score 
Select p.perfumer_name, cast(avg(f.score) as decimal(4,2)) as avg_score
From dbo.Fragrances as f
Join dbo.FragrancePerfumers as fp
On f.fragrance_id = fp.fragrance_id
Join dbo.Perfumers as p
On fp.perfumer_id = p.perfumer_id
Group by p.perfumer_id, p.perfumer_name
Order by avg_score desc, p.perfumer_name;


--Fragrance Report
With PerfumerSummary as 
(
	Select fp.fragrance_id, STRING_AGG(p.perfumer_name, ', ') as perfumers
	From dbo.FragrancePerfumers as fp
	Join dbo.Perfumers as p
	On fp.perfumer_id = p.perfumer_id
	Group By fp.fragrance_id),
TopNoteSummary as 
(
	Select fn.fragrance_id, STRING_AGG(n.note_name, ', ') as top_note
	From dbo.FragranceNotes as fn
	Join dbo.Notes as n
	On fn.note_id =n.note_id
	Where fn.note_position = 'Top'
	Group By fn.fragrance_id),
MiddleNoteSummary as 
(
	Select fn.fragrance_id, STRING_AGG(n.note_name, ', ') as middle_note
	From dbo.FragranceNotes as fn
	Join dbo.Notes as n
	On fn.note_id =n.note_id
	Where fn.note_position = 'Middle'
	Group By fn.fragrance_id),
BaseNoteSummary as 
(
	Select fn.fragrance_id, STRING_AGG(n.note_name, ', ') as base_note
	From dbo.FragranceNotes as fn
	Join dbo.Notes as n
	On fn.note_id =n.note_id
	Where fn.note_position = 'Base'
	Group By fn.fragrance_id),
LinearNoteSummary as 
(
	Select fn.fragrance_id, STRING_AGG(n.note_name, ', ') as linear_note
	From dbo.FragranceNotes as fn
	Join dbo.Notes as n
	On fn.note_id =n.note_id
	Where fn.note_position = 'Linear'
	Group By fn.fragrance_id),
AccordSummary as 
(
	Select fa.fragrance_id, STRING_AGG(a.accord_name, ', ') as accords
	From dbo.FragranceAccords as fa
	Join dbo.Accords as a
	On fa.accord_id = a.accord_id
	Group By fa.fragrance_id),
SeasonsSummary as
(
	Select fs.fragrance_id, STRING_AGG(s.season_name, ', ') as seasons
	From dbo.FragranceSeasons as fs
	Join dbo.Seasons as s
	On fs.season_id = s.season_id
	Group By fs.fragrance_id),
TimeSummary as
(
	Select ft.fragrance_id, STRING_AGG(t.time_name, ', ') as recommended_time
	From dbo.FragranceTimes as ft
	Join dbo.TimesOfDay as t
	On ft.time_id = t.time_id
	Group By ft.fragrance_id)
Select dna.attribute_name as Attribute, dna.attribute_value as Value
From dbo.Fragrances as f
Join dbo.Brands as b
on f.brand_id = b.brand_id
Left Join PerfumerSummary as ps
on f.fragrance_id = ps.fragrance_id
Left Join TopNoteSummary as tns
on f.fragrance_id = tns.fragrance_id
Left Join MiddleNoteSummary as mns
on f.fragrance_id = mns.fragrance_id
Left Join BaseNoteSummary as bns
on f.fragrance_id = bns.fragrance_id
Left Join LinearNoteSummary as lns
on f.fragrance_id = lns.fragrance_id
Left Join AccordSummary as acs
on f.fragrance_id = acs.fragrance_id
Left Join SeasonsSummary as ss
on f.fragrance_id = ss.fragrance_id
Left Join TimeSummary as ts
on f.fragrance_id = ts.fragrance_id
Cross Apply
(
	Values
		(1, 'Fragrance', Cast(f.fragrance_name as nvarchar(MAX))),
		(2, 'Rank', Cast(f.fragrance_rank as nvarchar(MAX))),
		(3, 'Brand', Cast(b.brand_name as nvarchar(MAX))),
		(4, 'Release Year', Cast(f.release_year as nvarchar(MAX))),
		(5, 'Score', Cast(f.score as nvarchar(MAX))),
		(6, 'Retail Price', Concat('$', Cast(f.retail_price_usd as decimal(10,2)))),
		(7, 'Bottle Size', Concat(f.bottle_size_ml, 'mL')),
		(8, 'Perfumers', Cast(ps.perfumers as nvarchar(MAX))),
		(9, 'Main Accords', Cast(acs.accords as nvarchar(MAX))),
		(10, 'Top Note', Cast(tns.top_note as nvarchar(MAX))),
		(11, 'Middle Note', Cast(mns.middle_note as nvarchar(MAX))),
		(12, 'Base Note', Cast(bns.base_note as nvarchar(MAX))),
		(13, 'Linear Note', Cast(lns.linear_note as nvarchar(MAX))),
		(14, 'Recommended Seasons', Cast(ss.seasons as nvarchar(MAX))),
		(15, 'Recommended Time', Cast(ts.recommended_time as nvarchar(MAX)))
) as dna(attribute_order, attribute_name, attribute_value)
--Where f.fragrance_id = ##
Where f.fragrance_name = 'Acqua di Parma Colonia'
And dna.attribute_value IS NOT NULL
Order By dna.attribute_order;

--Top 10 Brands By Number of Fragrances and show their average score
Select top 10 b.brand_name, count(*) as Fragrance_Count, cast(avg(f.score) as decimal(4,2)) as avg_score
From dbo.Fragrances as f
Join dbo.Brands as b
on f.brand_id = b.brand_id
Group by b.brand_id, b.brand_name
Order by Fragrance_Count desc;

--Most 10 Common Notes
Select top 10 n.note_name, count(*) as Fragrances_Used_In
From dbo.Fragrances as f
Join dbo.FragranceNotes as fn
On f.fragrance_id = fn.fragrance_id
Join dbo.Notes as n
On fn.note_id = n.note_id
Group By n.note_id, n.note_name
Order By Fragrances_Used_In desc;

--Most 10 Common Accords
Select top 10 a.accord_name, count(*) as Fragrances_Used_In
From dbo.Fragrances as f
Join dbo.FragranceAccords as fa
On f.fragrance_id = fa.fragrance_id
Join dbo.Accords as a
On fa.accord_id = a.accord_id
Group By a.accord_id, a.accord_name
Order By Fragrances_Used_In desc;

--Top 10 Perfumers based on their average fragrance scores and contributed to more than 2 fragrances (in the top 500)
Select top 10 p.perfumer_name, count(*) as Fragrances_Contributed,cast(avg(f.score) as decimal(4,2)) as averge_score
From dbo.Fragrances as f
Join dbo.FragrancePerfumers as fp
On f.fragrance_id = fp.fragrance_id	
Join dbo.Perfumers as p
On fp.perfumer_id = p.perfumer_id
Group By p.perfumer_id, p.perfumer_name
Having count(*) > 2
Order by averge_score desc;

--Fragrance Count by Release Year and Average Score
Select release_year, count(*) as Fragrances_released, cast(avg(score) as decimal(4,2)) as average_score
From dbo.Fragrances as f
Group by release_year
Order by release_year;

--Total Count and Average Score By Season
Select s.season_name, count(*) as Num_of_Fragrances, cast(avg(f.score) as decimal(4,2)) as average_score
From dbo.Fragrances as f
Join dbo.FragranceSeasons as fs
On f.fragrance_id = fs.fragrance_id
Join dbo.Seasons as s
On fs.season_id = s.season_id
Group by s.season_id, s.season_name
Order By 
	Case s.season_name
		When 'Spring' Then 1
		When 'Summer' Then 2
		When 'Fall' Then 3
		When 'Winter' Then 4
	End;

--Total Count and Average Score By Time (Day, Night, Day & Night)
With TimeClasssification as
(
	Select f.fragrance_id, f.score,
		Case
			When count(distinct t.time_name) = 2 Then 'Day & Night'
			When Max(Case When t.time_name = 'Day' Then 1 Else 0 End) = 1 Then 'Day'
			When Max(Case When t.time_name = 'Night' Then 1 Else 0 End) = 1 Then 'Night'
		End as time_category
	From dbo.Fragrances as f
	Join dbo.FragranceTimes as ft
	On f.fragrance_id = ft.fragrance_id
	Join dbo.TimesOfDay as t
	On ft.time_id = t.time_id
	Group by f.fragrance_id, f.score)
Select time_category, Count(*) as Num_of_Fragrances, Cast(avg(score) as decimal(4,2)) as average_score
From TimeClasssification
Group By time_category
Order By
	Case time_category
		When 'Day' Then 1
		When 'Night' Then 2
		When 'Day & Night' Then 3
	End;

--Top Rated Fragrances
Select top 10 b.brand_name, f.fragrance_name, f.score
From dbo.Fragrances as f
Join dbo.Brands as b
On f.brand_id = b.brand_id
Group By f.fragrance_id, f.fragrance_name, b.brand_name, f.score
Order by f.score desc;
--Correcting Typos
Update dbo.Fragrances
Set fragrance_name = 'The Most Wanted'
Where fragrance_name = 'The Most Wante';

Update dbo.Notes
Set note_name = 'Turkish Rose'
Where note_name = 'Turkish Ros';

Select note_id, note_name
From dbo.Notes
where note_name In ('Turkish Rose', 'Turkish Ros');




--Query to remove incorrect id 
BEGIN TRANSACTION;

DECLARE @WrongNoteID INT;
DECLARE @CorrectNoteID INT;

SELECT @WrongNoteID = note_id
FROM dbo.Notes
WHERE note_name = 'Jasmin';

SELECT @CorrectNoteID = note_id
FROM dbo.Notes
WHERE note_name = 'Jasmine';

INSERT INTO dbo.FragranceNotes
(
    fragrance_id,
    note_id,
    note_position,
    note_order
)
SELECT
    fn.fragrance_id,
    @CorrectNoteID,
    fn.note_position,
    fn.note_order
FROM dbo.FragranceNotes AS fn
WHERE fn.note_id = @WrongNoteID
  AND NOT EXISTS
  (
      SELECT 1
      FROM dbo.FragranceNotes AS existing
      WHERE existing.fragrance_id = fn.fragrance_id
        AND existing.note_id = @CorrectNoteID
        AND existing.note_position = fn.note_position
  );

DELETE FROM dbo.FragranceNotes
WHERE note_id = @WrongNoteID;

DELETE FROM dbo.Notes
WHERE note_id = @WrongNoteID;

COMMIT TRANSACTION;
--Finish

--Checking notes
SELECT
    f.fragrance_rank,
    f.fragrance_name,
    b.brand_name,
    fn.note_position,
    fn.note_order,
    n.note_name
FROM dbo.Fragrances AS f
JOIN dbo.Brands AS b
    ON f.brand_id = b.brand_id
JOIN dbo.FragranceNotes AS fn
    ON f.fragrance_id = fn.fragrance_id
JOIN dbo.Notes AS n
    ON fn.note_id = n.note_id
WHERE n.note_name = 'Sichuan Pepper'
ORDER BY
    f.fragrance_rank,
    CASE fn.note_position
        WHEN 'Top' THEN 1
        WHEN 'Middle' THEN 2
        WHEN 'Base' THEN 3
        WHEN 'Linear' THEN 4
    END,
    fn.note_order;



Update dbo.Notes
Set note_name = 'Orchid'
Where note_name = 'ORchid';

Update dbo.Notes
Set note_name = 'Resins'
Where note_name = 'Resin';

Update dbo.Notes
Set note_name = 'Lily-of-the-Valley'
Where note_name = 'Lily-of-the-Vally';

Update dbo.Notes
Set note_name = 'Cashmere Wood'
Where note_name = 'Cashere Wood';

Update dbo.Notes
Set note_name = 'Spearmint'
Where note_name = 'Spearmin';

Update dbo.Notes
Set note_name = 'Sichuan Pepper'
Where note_name = 'SIchuan Pepper';

Update dbo.Notes
Set note_name = 'White Chocolcate'
Where note_name = 'Chite Chocolate';

Update dbo.Notes
Set note_name = 'Coriander'
Where note_name = 'Corianger';

Update dbo.Notes
Set note_name = 'Jasmine'
Where note_name = 'Jasmin';


--Seperate Amber Ambrette (Musk Mallow) by removing and then adding
Select *
from dbo.Fragrances as f
join dbo.FragranceNotes as fn
on f.fragrance_id = fn.fragrance_id
join dbo.Notes as n
on fn.note_id = n.note_id
where n.note_name = 'Amber Ambrette (Musk Mallow)'

Select note_id
From dbo.Notes
where note_name = 'Amber Ambrette (Musk Mallow)';

DELETE FROM dbo.FragranceNotes
WHERE fragrance_id = 271
AND note_id = 155;

SELECT note_id, note_name
FROM dbo.Notes
WHERE note_name IN ('Amber', 'Ambrette (Musk Mallow)');

INSERT INTO dbo.FragranceNotes
(
    fragrance_id,
    note_id,
    note_position,
    note_order
)
VALUES
(271, 484, 'Base', 5),
(271, 140, 'Base', 6);


SELECT
    f.fragrance_name,
    fn.note_position,
    fn.note_order,
    n.note_name
FROM dbo.Fragrances AS f
JOIN dbo.FragranceNotes AS fn
    ON f.fragrance_id = fn.fragrance_id
JOIN dbo.Notes AS n
    ON fn.note_id = n.note_id
WHERE f.fragrance_id = 271
ORDER BY
    CASE fn.note_position
        WHEN 'Top' THEN 1
        WHEN 'Middle' THEN 2
        WHEN 'Base' THEN 3
        WHEN 'Linear' THEN 4
    END,
    fn.note_order;

Select * from Notes
where note_name = 'Amber'
Select * from Notes
where note_name = 'Ambrette (Musk Mallow)'
--Finish


--Seperate Styrax. French Labdanum by removing and then adding
Select *
from dbo.Fragrances as f
join dbo.FragranceNotes as fn
on f.fragrance_id = fn.fragrance_id
join dbo.Notes as n
on fn.note_id = n.note_id
where n.note_name = 'Styrax. French Labdanum'

Select note_id
From dbo.Notes
where note_name = 'Styrax. French Labdanum';

DELETE FROM dbo.FragranceNotes
WHERE fragrance_id = 115
AND note_id = 180;

SELECT note_id, note_name
FROM dbo.Notes
WHERE note_name IN ('Styrax. French Labdanum');

INSERT INTO dbo.FragranceNotes
(
    fragrance_id,
    note_id,
    note_position,
    note_order
)
VALUES
(115, 194, 'Base', 6),
(115, 370, 'Base', 7);

-- Shift the notes after French Labdanum forward by one position
UPDATE fn
SET fn.note_order = fn.note_order + 1
FROM dbo.FragranceNotes AS fn
WHERE fn.fragrance_id = 115
  AND fn.note_position = 'Base'
  AND fn.note_order >= 7
  AND fn.note_id <> 370;  -- Exclude French Labdanum

SELECT
    f.fragrance_name,
    fn.note_position,
    fn.note_order,
    n.note_name
FROM dbo.Fragrances AS f
JOIN dbo.FragranceNotes AS fn
    ON f.fragrance_id = fn.fragrance_id
JOIN dbo.Notes AS n
    ON fn.note_id = n.note_id
WHERE f.fragrance_id = 115
ORDER BY
    CASE fn.note_position
        WHEN 'Top' THEN 1
        WHEN 'Middle' THEN 2
        WHEN 'Base' THEN 3
        WHEN 'Linear' THEN 4
    END,
    fn.note_order;


--Seperate Pink Pepperm TObacco by removing and then adding while correcting typo
Select *
from dbo.Fragrances as f
join dbo.FragranceNotes as fn
on f.fragrance_id = fn.fragrance_id
join dbo.Notes as n
on fn.note_id = n.note_id
where n.note_name = 'Pink Pepperm TObacco'

Select note_id
From dbo.Notes
where note_name = 'Pink Pepperm TObacco';

DELETE FROM dbo.FragranceNotes
WHERE fragrance_id = 98
AND note_id = 221;

SELECT note_id, note_name
FROM dbo.Notes
WHERE note_name IN ('Pink Pepperm TObacco');

INSERT INTO dbo.FragranceNotes
(
    fragrance_id,
    note_id,
    note_position,
    note_order
)
VALUES
(98, 20, 'Linear', 6),
(98, 357, 'Linear', 7);

-- Shift the notes after Tobacco forward by one position
UPDATE fn
SET fn.note_order = fn.note_order + 1
FROM dbo.FragranceNotes AS fn
WHERE fn.fragrance_id = 98
  AND fn.note_position = 'Linear'
  AND fn.note_order >= 7
  AND fn.note_id <> 357;  -- Exclude Tobacco

SELECT
    f.fragrance_name,
    fn.note_position,
    fn.note_order,
    n.note_name
FROM dbo.Fragrances AS f
JOIN dbo.FragranceNotes AS fn
    ON f.fragrance_id = fn.fragrance_id
JOIN dbo.Notes AS n
    ON fn.note_id = n.note_id
WHERE f.fragrance_id = 98
ORDER BY
    CASE fn.note_position
        WHEN 'Top' THEN 1
        WHEN 'Middle' THEN 2
        WHEN 'Base' THEN 3
        WHEN 'Linear' THEN 4
    END,
    fn.note_order;


--ID 20
Select * from Notes
where note_name = 'Pink Pepper'
--ID 357
Select * from Notes
where note_name = 'Tobacco'

--Insert White Chocolate into Coromandel Eau de Parfum Chanel
BEGIN TRANSACTION;

DECLARE @WhiteChocolateID INT;

-- Find White Chocolate if it already exists
SELECT @WhiteChocolateID = note_id
FROM dbo.Notes
WHERE note_name = 'White Chocolate';

-- If it does not exist, create it and save its new ID
IF @WhiteChocolateID IS NULL
BEGIN
    INSERT INTO dbo.Notes
    (
        note_name
    )
    VALUES
    (
        'White Chocolate'
    );

    SET @WhiteChocolateID = SCOPE_IDENTITY();
END;

-- Reconnect White Chocolate to Coromandel as Base note order 1
IF NOT EXISTS
(
    SELECT 1
    FROM dbo.FragranceNotes
    WHERE fragrance_id = 99
      AND note_id = @WhiteChocolateID
      AND note_position = 'Base'
)
BEGIN
    INSERT INTO dbo.FragranceNotes
    (
        fragrance_id,
        note_id,
        note_position,
        note_order
    )
    VALUES
    (
        99,
        @WhiteChocolateID,
        'Base',
        1
    );
END;

COMMIT TRANSACTION;

Select *
from Fragrances
where fragrance_name = 'Coromandel Eau de Parfum'


SELECT
    f.fragrance_id,
    f.fragrance_name,
    fn.note_position,
    fn.note_order,
    n.note_id,
    n.note_name
FROM dbo.Fragrances AS f
JOIN dbo.FragranceNotes AS fn
    ON f.fragrance_id = fn.fragrance_id
JOIN dbo.Notes AS n
    ON fn.note_id = n.note_id
WHERE f.fragrance_id = 99
  AND fn.note_position = 'Base'
ORDER BY fn.note_order;


--Insert Coriander into Versus Uomo
-- Restore Coriander to Versus Uomo as Middle note order 5
BEGIN TRANSACTION;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.FragranceNotes
    WHERE fragrance_id = 461
      AND note_id = 327
      AND note_position = 'Middle'
)
BEGIN
    INSERT INTO dbo.FragranceNotes
    (
        fragrance_id,
        note_id,
        note_position,
        note_order
    )
    VALUES
    (
        461,
        327,
        'Middle',
        5
    );
END;

COMMIT TRANSACTION;

--Check
SELECT
    f.fragrance_id,
    f.fragrance_name,
    fn.note_position,
    fn.note_order,
    n.note_id,
    n.note_name
FROM dbo.Fragrances AS f
JOIN dbo.FragranceNotes AS fn
    ON f.fragrance_id = fn.fragrance_id
JOIN dbo.Notes AS n
    ON fn.note_id = n.note_id
WHERE f.fragrance_id = 461
  AND fn.note_position = 'Middle'
ORDER BY fn.note_order;

SELECT
    fragrance_id,
    fragrance_rank,
    fragrance_name
FROM dbo.Fragrances
ORDER BY fragrance_rank;



--Finding single Accord typos, and replacing them
select * 
from dbo.Fragrances as f
join dbo.FragranceAccords as fa
on fa.fragrance_id = f.fragrance_id
join dbo.Accords as a
on a.accord_id = fa.accord_id
where a.accord_name = 'aromatic';

SELECT accord_id, accord_name
FROM dbo.Accords
WHERE accord_name IN ('aromtic', 'aromatic');

BEGIN TRANSACTION;

-- Change relationships from typo accord to correct accord
UPDATE dbo.FragranceAccords
SET accord_id = 18       -- correct
WHERE accord_id = 86;   -- typo

-- Remove the unused typo from the lookup table
DELETE FROM dbo.Accords
WHERE accord_id = 86;	--typo

COMMIT TRANSACTION;

select f.fragrance_name, a.accord_name 
from dbo.Fragrances as f
join dbo.FragranceAccords as fa
on fa.fragrance_id = f.fragrance_id
join dbo.Accords as a
on a.accord_id = fa.accord_id
where f.fragrance_name = 'Rocabar';
--Finish



--Finding Accord typos due to missed delimiter
select * 
from dbo.Fragrances as f
join dbo.FragranceAccords as fa
on fa.fragrance_id = f.fragrance_id
join dbo.Accords as a
on a.accord_id = fa.accord_id
where a.accord_name = 'amberm aromatic';

SELECT accord_id, accord_name
FROM dbo.Accords
WHERE accord_name IN ('amberm aromatic', 'fresh spicy', 'mossy');

--Perform this after removing and correcting
DELETE FROM dbo.Accords
WHERE accord_id = 89;	--incorrect accord_id

BEGIN TRANSACTION;

-- 1. Remove the bad combined accord
DELETE FROM dbo.FragranceAccords
WHERE fragrance_id = 395
  AND accord_id = 2;	--incorrect accord_id


-- 2. Shift the existing accords after position 1 down by one
UPDATE dbo.FragranceAccords
SET accord_order = accord_order + 1
WHERE fragrance_id = 395
  AND accord_order >= 3; --accord position +1


-- 3. Insert the two correct accords
INSERT INTO dbo.FragranceAccords
(
    fragrance_id,
    accord_id,
    accord_order
)
VALUES
(395, 17, 2),   -- fragrance_id, correct accord 1, position
(395, 37, 3);   -- fragrance_id, correct accord 2, position +1


-- 4. Verify before committing
SELECT
    f.fragrance_name,
    fa.accord_order,
    a.accord_id,
    a.accord_name
FROM dbo.FragranceAccords AS fa
JOIN dbo.Fragrances AS f
    ON fa.fragrance_id = f.fragrance_id
JOIN dbo.Accords AS a
    ON fa.accord_id = a.accord_id
WHERE fa.fragrance_id = 395		--fragrance_id
ORDER BY fa.accord_order;

-- If everything looks correct:
COMMIT TRANSACTION;
--Finish 



Select *
fRom Fragrances
where fragrance_name= 'versus uomo';

select *
from Notes
where note_name = 'Jasmin';

Select Top 5 *
from dbo.Fragrances

Select Top 5 *
from dbo.Brands

Select Top 5 *
from dbo.FragrancePerfumers

Select Top 5 *
from dbo.Perfumers
