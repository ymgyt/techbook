# Drive

## 共有ドライブ(Shared Drive)

* Google drive の特別なフォルダ
* 個人ではなくチームの所有となる

* 共有方法
  * ユーザーやグループを共有ドライブのメンバーとして追加する
    * メンバーには、アクセスレベルがある
      * 管理者: なんでもできる
      * コンテンツ管理者: 共有ドライブのメンバー管理や、共有ドライブの削除以外できる
      * 投稿者: ファイルの追加、特定ファイルへのメンバー追加
      * コメント投稿者: 閲覧とコメント
      * 閲覧社: 閲覧のみ
      * [詳細](https://support.google.com/a/users/answer/9310249?sjid=8616892541817436407-NC#1.2)

  * メンバー以外のユーザ
    * 組織の設定で制御できる
    * ファイル、フォルダごとに指定できる


## 共有ドライブとマイドライブの比較


| \-             | 共有ドライブ                                 | マイドライブ           |
|----------------|----------------------------------------------|------------------------|
| ファイルの追加 | 投稿者権限以上をもつ、すべてのメンバー       | 所有ユーザー           |
| 移動           | 権限によって、移動でまたげるスコープが変わる | マイドライブ内で、自由 |
| 共有           | すべてのメンバー                             | 個々のファイルごと     |
| ゴミ箱         | 共有ドライブごとにゴミ箱がある               | 30日後に削除           |

* [共有ドライブとマイドライブの比較](https://support.google.com/a/users/answer/7212025)


## ファイル削除

ファイルが削除される理由

* `empty_trash`
  * The item was deleted from the trash being emptied.
* `individual_delete`
  * The item was deleted individually.
* `owning_shared_drive_delete`
  *The item was deleted because the shared drive that contained the item was deleted.
* `subscription_canceled`
  * The item was deleted because the Google Workspace subscription was canceled.
* `tos_violation`
  * The item was deleted because it violated Google's terms of service.
* `trash_auto_delete`
  * The item was automatically deleted after being in the trash.
* `user_account_delete`
    The item was deleted because the user that owned the item was deleted.


[API Docs](https://developers.google.com/workspace/admin/reports/v1/appendix/activity/drive#delete)
