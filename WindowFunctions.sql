DECLARE @Data TABLE
(
	ID				INT				IDENTITY(1,1)
	, CostCentre	VARCHAR(20)
	, Subjective	VARCHAR(20)
	, SubDetail		VARCHAR(20)
	, ItemDate		DATETIME2
	, Amount		MONEY
);

INSERT INTO @Data (CostCentre, Subjective, SubDetail, ItemDate, Amount)
VALUES
('ShortTerm', 'Residential', 'External', '20000101', 10.00)
,('ShortTerm', 'Residential', 'External', '20000102', 15.00)
,('LongTerm', 'Residential', 'External', '20000103', 13.00)
,('LongTerm', 'Residential', 'External', '20000104', 14.00)
,('Domestic', 'Non-Residential', 'Internal', '20000105', 20.00)
,('Domestic', 'Non-Residential', 'Internal', '20000106', 25.00)
,('Domestic', 'Non-Residential', 'External', '20000107', 17.00)
,('Domestic', 'Non-Residential', 'External', '20000108', 18.00)
,('DayCare', 'Non-Residential', 'External', '20000109', 12.00)
,('DayCare', 'Non-Residential', 'External', '20000110', 13.00)
;

SELECT
	d.CostCentre
	, d.Subjective
	, d.SubDetail
	, RowNumber					= ROW_NUMBER() OVER (ORDER BY d.CostCentre, d.Subjective, d.SubDetail)
	, [Rank]					= RANK() OVER (ORDER BY d.CostCentre, d.Subjective, d.SubDetail)
	, DenseRank					= DENSE_RANK() OVER (ORDER BY d.CostCentre, d.Subjective, d.SubDetail)
FROM @Data d
ORDER BY d.CostCentre, d.Subjective, d.SubDetail;

SELECT
	d.CostCentre
	, d.Subjective
	, d.SubDetail
	, Partitioned_RowNumber		= ROW_NUMBER() OVER (PARTITION BY d.Subjective ORDER BY d.CostCentre, d.SubDetail)
	, Partitioned_Rank			= RANK() OVER (PARTITION BY d.Subjective ORDER BY d.CostCentre, d.SubDetail)
	, Partitioned_DenseRank		= DENSE_RANK() OVER (PARTITION BY d.Subjective ORDER BY d.CostCentre, d.SubDetail)
FROM @Data d
ORDER BY d.CostCentre, d.Subjective, d.SubDetail;

SELECT
	d.CostCentre
	, d.Subjective
	, d.SubDetail
	, d.ItemDate
	-- Note that if we don't specify what rows to include we get the SUM of all amounts in the group
	, [Sum]						= SUM(d.Amount) OVER (ORDER BY d.CostCentre, d.Subjective, d.SubDetail)
	-- Whereas if we specify to include only those rows up to and including the current row we get a rolling count
	, RollingSum				= SUM(d.Amount) OVER (ORDER BY d.CostCentre, d.Subjective, d.SubDetail ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM @Data d
ORDER BY d.CostCentre, d.Subjective, d.SubDetail, d.ItemDate;