SELECT 
T5.name + '.' +T4.name AS TableName,
T1.name AS IndexName,
T3.name AS ColumnName,
T2.key_ordinal,
T2.is_included_column
FROM SYS.indexes AS T1
INNER JOIN SYS.index_columns AS T2 ON T1.object_id = T2.object_id AND T1.index_id = T2.index_id
INNER JOIN SYS.columns AS T3 ON T2.object_id = T3.object_id AND T2.column_id = T3.column_id
INNER JOIN SYS.tables AS T4 ON T1.object_id = T4.object_id
INNER JOIN SYS.schemas AS T5 ON T4.schema_id = T5.schema_id
--WHERE T1.name LIKE 'X%'
ORDER BY TableName