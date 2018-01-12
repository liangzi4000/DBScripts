CREATE TABLE #temp (
  table_name sysname,
  row_count int,
  reserved_size varchar(50),
  data_size varchar(50),
  index_size varchar(50),
  unused_size varchar(50)
)
SET NOCOUNT ON
INSERT #temp
EXEC sp_msforeachtable 'sp_spaceused ''?'''
SELECT
  a.table_name,
  a.row_count,
  COUNT(*) AS col_count,
  a.data_size
FROM #temp a
INNER JOIN information_schema.columns b
  ON a.table_name COLLATE database_default
  = b.table_name COLLATE database_default
GROUP BY a.table_name,
         a.row_count,
         a.data_size
ORDER BY CAST(REPLACE(a.data_size, ' KB', '') AS integer) DESC
DROP TABLE #temp