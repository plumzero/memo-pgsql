
分区表主要有以下优势:
* 当查询或更新一个分区上的大部分数据时，对分区进行索引扫描代价很大，然而，在分区上使用顺序扫描能提升性能。
* 当需要删除一个分区数据时，通过 DROP TABLE 删除一个分区，远比 DELETE 删除数据高效，特别适用于日志数据场景。
* 由于一个表只能存储在一个表空间上，使用分区表后，可以将分区放到不同的表空间上。
