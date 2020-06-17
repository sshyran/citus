SET citus.shard_count TO 4;
SET citus.shard_replication_factor TO 1;

CREATE TABLE dist_table (id INT, a INT, b TEXT);
SELECT create_distributed_table('dist_table', 'id');
INSERT INTO dist_table VALUES (1, 2, 'abc'), (2, 3, 'abcd'), (1, 3, 'abc');

SELECT logicalrelid FROM pg_dist_partition WHERE logicalrelid = 'dist_table'::regclass;
SELECT run_command_on_workers($$SELECT COUNT(*) FROM pg_catalog.pg_class WHERE relname LIKE 'dist\_table\_%'$$);
SELECT * FROM dist_table ORDER BY 1, 2, 3;

SELECT undistribute_table('dist_table');

SELECT logicalrelid FROM pg_dist_partition WHERE logicalrelid = 'dist_table'::regclass;
SELECT run_command_on_workers($$SELECT COUNT(*) FROM pg_catalog.pg_class WHERE relname LIKE 'dist\_table\_%'$$);
SELECT * FROM dist_table ORDER BY 1, 2, 3;

DROP TABLE dist_table;

-- test indexes
CREATE TABLE dist_table (id INT, a INT, b TEXT);
SELECT create_distributed_table('dist_table', 'id');
INSERT INTO dist_table VALUES (1, 2, 'abc'), (2, 3, 'abcd'), (1, 3, 'abc');

CREATE INDEX index1 ON dist_table (id);
SELECT * FROM pg_indexes WHERE tablename = 'dist_table';

SELECT undistribute_table('dist_table');

SELECT * FROM pg_indexes WHERE tablename = 'dist_table';

DROP TABLE dist_table;

-- test tables with references
CREATE TABLE referenced_table (id INT PRIMARY KEY, a INT, b TEXT);
SELECT create_distributed_table('referenced_table', 'id');
INSERT INTO referenced_table VALUES (1, 2, 'abc'), (2, 3, 'abcd'), (4, 3, 'abc');

CREATE TABLE referencing_table (id INT REFERENCES referenced_table (id), a INT, b TEXT);
SELECT create_distributed_table('referencing_table', 'id');
INSERT INTO referencing_table VALUES (4, 6, 'cba'), (1, 1, 'dcba'), (2, 3, 'aaa');

SELECT undistribute_table('referenced_table');
SELECT undistribute_table('referencing_table');

DROP TABLE referenced_table, referencing_table;
