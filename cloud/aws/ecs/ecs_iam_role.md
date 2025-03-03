# ECS IAM Role

* Container Instance IAM Role
  * ECS on EC2 の場合
    * launch_templateのiam_instance_profile 経由で指定する 
    * Assumeの主体はECS Agent
      * EC2 Instanceの登録に利用

* Task Execution Role
  * EC2,Fargat共通で利用できる ECS Agent用のrole
  * ECS on EC2
    * Assumeの主体はECS Agent
      * ECS AgentはContainer Instance IAM Role と TAsk Execution roleを使い分けているという仮説
      * ECRからのPull
      * Secrets managerやparameter storeへのアクセス

* Task Role
  * Containerのappliationがassumeするrole
