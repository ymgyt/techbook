# Reports API

* 分類としてはGoogle Admin API
* [Admin SDK API Reference](https://developers.google.com/admin-sdk/reports/reference/rest/v1/activities/list#ApplicationName)
  * queryやresponseの詳細情報
  * [Drive Audit Activity Events](https://developers.google.com/admin-sdk/reports/v1/appendix/activity/drive)

* [API OAuth Scope一覧](https://developers.google.com/identity/protocols/oauth2/scopes)
* 2種類のreportがある
  * Activity
  * Usage

* [Service Accountからaccess token取得してリクエストするまで](https://developers.google.com/identity/protocols/oauth2/service-account#httprest)

## Memo

https://developers.google.com/admin-sdk/reports/v1/quickstart/go?hl=ja
https://developers.google.com/admin-sdk/reports/v1/guides/manage-audit-drive?hl=ja
https://developers.google.com/admin-sdk/reports/v1/appendix/activity/drive?hl=ja
https://support.google.com/a/answer/4579696?hl=ja#zippy=%2C%E3%83%87%E3%83%BC%E3%82%BF%E3%82%92%E5%88%A9%E7%94%A8%E3%81%A7%E3%81%8D%E3%82%8B%E6%9C%9F%E9%96%93%2C%E8%AA%BF%E6%9F%BB%E3%81%AE%E3%83%AA%E3%82%B9%E3%83%88%E3%82%92%E8%A1%A8%E7%A4%BA%E3%81%99%E3%82%8B

## Scope

* [choose Reports API scopes](https://developers.google.com/admin-sdk/reports/auth)

* `https://www.googleapis.com/auth/admin.reports.audit.readonly`:	View audit reports for your Google Workspace domain

* `https://www.googleapis.com/auth/admin.reports.usage.readonly`:	View usage reports for your Google Workspace domain


## 利用手順

1. GCP Project 作成
2. API > Googls Admin SDK API を有効化
3. Service Account 作成
  * Key を生成して控えておく
4. 
