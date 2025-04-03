# Link

## symlink vs hard_link

|  /                | Hard Link           | Symlink                |
|-------------------|---------------------|------------------------|
| 実体              | Orgと同一データ     | 参照しているという情報 |
| inode             | Orgと同じinode      | Org とは別のinode      |
| 削除時            | Orgを消しても残る   | link切れ               |
| Directoryへのlink | 不可                | 可                     |
| filesystemの制約  | 同一fsのみ          | 異なるfsでも可能       |


* hard_link経由で変更するとOrgも変更される
* hard_linkのusecase
  * データを2重にもたないので、効率的なbackupができる
  * atimic な file更新ができる(曖昧)
