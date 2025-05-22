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
         ]
      }
   ]
}
```
