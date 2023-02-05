# Tips

## 外部キー制約を一時的に無効化する

local等でdummy dataいれるときに便利。

```sql
-- 外部キー制約を無効化
SET FOREIGN_KEY_CHECKS = 0

-- INSERT SQL

-- 外部キー制約を有効化
SET FOREIGN_KEY_CHECKS = 1
```
