
*阅读比思考困难，记忆是痛苦的根源。*

### 版本

postgresql-13.3


### 内容

- [安装与配置](ch01)
  - [安装与介绍](ch01/01_安装与介绍.md)
  - [实例创建与使用](ch01/02_实例创建与使用.md)
  - [数据库配置基础](ch01/03_数据库配置基础.md)
  - [连接和创建数据库](ch01/04_连接和创建数据库.md)
  - [连接数据库选项](ch01/05_连接数据库选项.md)
  - [定制维护脚本](ch01/06_定制维护脚本.md)
  - [元命令](ch01/07_元命令.md)
- [体系结构](ch02)
  - [逻辑与物理存储结构](ch02/01_逻辑与物理存储结构.md)
  - [进程结构](ch02/02_进程结构.md)
  - [内存结构](ch02/03_内存结构.md)
  - [执行过程](ch02/04_执行过程.md)
- [数据类型](ch03)
  - [数字类型](ch03/01_数字类型.md)
  - [字符类型](ch03/02_字符类型.md)
  - [时间日期类型](ch03/03_时间日期类型.md)
  - [布尔类型](ch03/04_布尔类型.md)
  - [网络地址类型](ch03/05_网络地址类型.md)
  - [数组类型](ch03/06_数组类型.md)
  - [范围类型](ch03/07_范围类型.md)
  - [json/jsonb类型](ch03/08_json_jsonb类型.md)
  - [数据类型转换](ch03/09_数据类型转换.md)
- [SQL高级特性](ch04)
  - [WITH查询](ch04/01_with查询.md)
  - [批量插入](ch04/02_批量插入.md)
  - [返回修改的数据](ch04/03_返回修改的数据.md)
  - [UPSERT](ch04/04_UPSERT.md)
  - [数据抽样](ch04/05_数据抽样.md)
  - [聚合函数](ch04/06_聚合函数.md)
- [并行查询](ch05)
  - [配置参数](ch05/01_配置参数.md)
  - [并行扫描](ch05/02_并行扫描.md)
  - [并行聚合](ch05/03_并行聚合.md)
- [事务与并发控制](ch06)
  - [事务概念](ch06/01_事务概念.md)
  - [事务隔离级别](ch06/02_事务隔离级别.md)
  - [并发控制](ch06/03_并发控制.md)
- [传统分区表](ch07)
  - [继承的概念](ch07/01_继承的概念.md)
  - [创建和使用](ch07/02_创建和使用.md)
  - [添加删除分区](ch07/03_添加删除分区.md)
  - [使用注意](ch07/04_使用注意.md)
- [内置分区表](ch08)
  - [创建和使用](ch08/01_创建和使用.md)
  - [添加删除分区](ch08/02_添加删除分区.md)
  - [使用注意](ch08/03_使用注意.md)
- [性能优化](ch09)
  - [操作系统优化](ch09/01_操作系统优化.md)
  - [配置参数调优](ch09/02_配置参数调优.md)
  - [统计信息调优](ch09/03_统计信息调优.md)
- [备份与恢复](ch13)
  - [SQL转储](ch13/01_SQL转储.md)
  - [WAL归档](ch13/02_WAL归档.md)
  - [恢复到最近时间点](ch13/66_恢复到最近时间点.md)
  - [恢复到指定时间点](ch13/67_恢复到指定时间点.md)
- [脚本编写](ch16)
  - [plpgsql](ch16/01_plpgsql.md)
  - [plperl](ch16/02_plperl.md)
  - [踩坑](ch16/03_踩坑.md)
- [测试](ch17)
  - [垃圾回收](ch17/01_垃圾回收.md)
  - [表级锁](ch17/02_表级锁.md)

### 语句

测试在 PostgreSQL-13.1 下进行。

- [DDL篇](ddl)
- [DML篇](dml)
- [DCL篇](dcl)

### 记录

- [问题记录](问题记录.md)
- [运维记录](运维记录.md)
- [函数记录](函数记录.md)

### 参考

- [代码](https://github.com/go-pg/pg/issues/1726)
- [代码二](https://github.com/go-pg/pg/issues/1642)
- [代码三](https://github.com/go-pg/pg/issues/1452)
