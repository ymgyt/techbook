# CloudShell

* $HOME directoryは一定期間(120日)アクセスがないと削除される仕様
  * AWS Healthで削除通知はきていた
  * Regionがスコープ
    * Tokyo regionでアクセスすれば、Tokyo regionの$HOMEは保持される
