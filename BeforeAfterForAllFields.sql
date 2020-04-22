SET NOCOUNT ON
CREATE TABLE #cmds (qid INT IDENTITY, q NVARCHAR(max))

INSERT #cmds (q)
SELECT
+ 'INSERT #results (FieldName, OldValue, NewValue)'
+ ' SELECT TOP 1 ''' + WFCON_Prompt + ''''
+ ', CAST(' + FDEF_Name + ' AS NVARCHAR(max))'
+ ', CAST(' + REPLACE(FDEF_Name, 'WFD_', 'WFH_') + ' AS NVARCHAR(max))'
+ ' FROM WFElements JOIN WFHistoryElements on WFD_ID = WFH_OrgID'
+ ' WHERE WFD_ID = 1079'
+ ' ORDER BY WFH_Version'
FROM WFDefinitions JOIN WFConfigurations ON DEF_ID = WFCON_DEFID JOIN WFFieldDefinitions ON FDEF_ID = WFCON_FDEFID
WHERE FDEF_Name IN (SELECT c.name FROM syscolumns c JOIN sysobjects o ON c.id = o.id WHERE o.name = 'WFElements')
AND FDEF_Name NOT LIKE 'WFD_SubElems%'
AND FDEF_Name NOT LIKE 'SEL_System%'
AND FDEF_Name != 'WFD_Tab'
AND FDEF_Name != 'WFD_Group'
AND FDEF_Name != 'SEL_SQLGrid'
AND FDEF_Name != 'SEL_SQLRow'
AND WFCON_Prompt NOT LIKE 'Modify %'
AND WFCON_Prompt NOT LIKE 'SOAP %'
AND WFCON_Prompt != 'Element ID'
AND DEF_ID = 144
ORDER BY WFCON_Prompt

CREATE TABLE #results (FieldName NVARCHAR(max), OldValue NVARCHAR(max), NewValue NVARCHAR(max))
DECLARE @counter int, @total int, @q NVARCHAR(max)
SELECT @counter = 0, @total = COUNT(*) FROM #cmds
WHILE @counter < @total
BEGIN
	SELECT @q = q FROM #cmds WHERE qid = @counter
	EXEC (@q)
	SELECT @counter = @counter + 1
END

SELECT FieldName, OldValue, NewValue 
FROM #results
WHERE OldValue != NewValue
DROP TABLE #results
DROP TABLE #cmds
SET NOCOUNT OFF

