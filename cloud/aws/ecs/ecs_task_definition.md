# ECS Task Definition

```json5
{
   // Taskの名前
   "family": "opsbot",
   // Task全体のCPU割当
   "cpu": "512",
   // Task全体の割当メモリ(MiB)
   "memory": "1024",

   // ECS Agentに割り当てるrole
   "executionRoleArn": "arn:aws:iam::238523969192:role/EcsTaskExecutionRole",
   // containerがassumeするrole
   "taskRoleArn": "arn:aws:iam::238523969192:role/EcsOpsbot",

   "networkMode": "awsvpc",

   // Fargateを利用
   "requiresCompatibilities": [
      "FARGATE"
   ],
   // Volume設定
   "volumes": [ ],
   // Container定義
   "containerDefinitions": [
      {
         "name": "front",
         // 環境変数
         "environment": [
            {
               "name": "AWS_REGION",
               "value": "ap-northeast-1"
            },
            {
               "name": "ENVIRONMENT",
               "value": "production"
            },
            {
               "name": "OPSBOT_BIND_ADDR",
               "value": "0.0.0.0"
            },
            {
               "name": "OPSBOT_BIND_PORT",
               "value": "8080"
            },
            {
               "name": "OPSBOT_RENOVATE_EVENT_DISPATCH_REPO",
               "value": "arkedge/renovate-wrapper"
            },
            {
               "name": "RUST_LOG",
               "value": "info,opsbot=debug,octocrab=debug"
            },
            {
               "name": "ZO_TELEMETRY",
               "value": "false"
            }
         ],
         "essential": true,
         "image": "238523969192.dkr.ecr.ap-northeast-1.amazonaws.com/opsbot:latest",
         "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
               "awslogs-create-group": "true",
               "awslogs-group": "opsbot",
               "awslogs-region": "ap-northeast-1",
               "awslogs-stream-prefix": "opsbot",
               "max-buffer-size": "5m",
               "mode": "non-blocking"
            }
         },
         "portMappings": [
            {
               // networkMode=awsvpcではhostPortは無視される
               // containerがlistenするport
               "containerPort": 8080,
               "protocol": "tcp" // tcp | udp
            }
         ],
         "secrets": [
            {
               "name": "mysecret",
               "valueFrom": "arn:aws:ssm:REGION:ACCOUNT_ID:parameter/foo/bar"
            }
         ],
         // HealthCheck
         "healthCheck": {
            "command": [
               "CMD-SHELL",
               "curl -f http://localhost || exit 1"
            ],
            // 5 - 300 secnds
            "interval": 30,
            // 2 - 60 seconds
            "timeout": 5,
            // 1 - 10
            "retries": 3,
            // container起動時のhealth check猶予時間
            // 0 - 300 seconds
            // 猶予時間内に成功したら成功判定
            "startPeriod": 30,
         },
      }
   ]
}
```

## Container definitions

### Healthcheck

* contaienr内で実行されるhealth check
* ALBのhealthcheckとは別でECSのhealthとして管理される
* essential containerでhealth checkが失敗すると、taskが失敗とみなされる
  * 複数ある場合の判定はdoc参照
  * https://docs.aws.amazon.com/AmazonECS/latest/developerguide/healthcheck.html
* `CMD`: 直接実行される
* `CMD-SHELL`: containerのdefault shellで実行される
* exit code 0が成功とみなされる

```json
{
"containerDefinitions": [
   "healthCheck": {
      "command": [
         "CMD-SHELL",
         "curl -f http://localhost:8080/health || exit 1"
      ]
   }
]
}
```

## Volumes

```json
{
   "containerDefinitions": [
      {
         "mountPoints": [
            {
               "sourceVolume": "volume-name",
               "containerPath": "/mount/efs",
               "readOnly": false,
            }
         ]
      }
   ]
   "volumes": [
      {
         "name": "volume-name",
         "efsVolumeConfiguration": {
            
         }
      }
   ]
}

```
