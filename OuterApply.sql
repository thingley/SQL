DECLARE @Client TABLE
(
	ClientID				INT				IDENTITY(1,1)
	, Forename				VARCHAR(MAX)
	, Surname				VARCHAR(MAX)
	, AssessmentOfficerID	INT
);

INSERT INTO @Client (Forename, Surname, AssessmentOfficerID) VALUES ('Anna', 'Apple', 1), ('Bert', 'Banana', NULL), ('Charlie', 'Cherry', 2);

DECLARE @AssessmentOfficer TABLE
(
	AssessmentOfficerID		INT				IDENTITY(1,1)
	, Forename				VARCHAR(MAX)
	, Surname				VARCHAR(MAX)
);

INSERT INTO @AssessmentOfficer (Forename, Surname) VALUES ('Martin', 'Melon'), ('Orran', 'Orange');

-- NOTE: Bert is excluded because OUTER APPLY behaves like a LEFT JOIN
SELECT
	c.Forename
	, c.Surname
	, AssessmentOfficerName.[Value]
FROM @Client c
OUTER APPLY
(
	SELECT [Value] = a.Forename + ' ' + a.Surname
	FROM @AssessmentOfficer a
	WHERE a.AssessmentOfficerID = c.AssessmentOfficerID
) AssessmentOfficerName;