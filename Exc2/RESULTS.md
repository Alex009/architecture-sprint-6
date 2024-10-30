# Результаты работы HPA

`kubectl top pod`:

```shell
NAME                            CPU(cores)   MEMORY(bytes)   
scaletestapp-6bdd4ddf69-684rc   15m          11Mi            
scaletestapp-6bdd4ddf69-85sdg   13m          9Mi             
scaletestapp-6bdd4ddf69-vx2h7   35m          18Mi 
```

`kubectl describe deployment scaletestapp`:

```shell
Name:                   scaletestapp
Namespace:              default
CreationTimestamp:      Sun, 27 Oct 2024 22:43:53 +0700
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 5
Selector:               app=scaletestapp
Replicas:               5 desired | 5 updated | 5 total | 5 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=scaletestapp
  Containers:
   scaletestapp:
    Image:      shestera/scaletestapp
    Port:       8080/TCP
    Host Port:  0/TCP
    Limits:
      cpu:     500m
      memory:  20Mi
    Requests:
      cpu:         250m
      memory:      10Mi
    Liveness:      http-get http://:8080/ delay=15s timeout=1s period=20s #success=1 #failure=3
    Readiness:     http-get http://:8080/ delay=5s timeout=1s period=10s #success=1 #failure=3
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Progressing    True    NewReplicaSetAvailable
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  scaletestapp-58fb69c4b8 (0/0 replicas created), scaletestapp-c859d4df8 (0/0 replicas created)
NewReplicaSet:   scaletestapp-6bdd4ddf69 (5/5 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  43m    deployment-controller  Scaled up replica set scaletestapp-6b984668b5 to 1
  Normal  ScalingReplicaSet  43m    deployment-controller  Scaled down replica set scaletestapp-56b949f889 to 0 from 1
  Normal  ScalingReplicaSet  27m    deployment-controller  Scaled up replica set scaletestapp-58fb69c4b8 to 1
  Normal  ScalingReplicaSet  27m    deployment-controller  Scaled down replica set scaletestapp-6b984668b5 to 0 from 1
  Normal  ScalingReplicaSet  21m    deployment-controller  Scaled up replica set scaletestapp-c859d4df8 to 1
  Normal  ScalingReplicaSet  21m    deployment-controller  Scaled down replica set scaletestapp-58fb69c4b8 to 0 from 1
  Normal  ScalingReplicaSet  2m37s  deployment-controller  Scaled up replica set scaletestapp-6bdd4ddf69 to 1
  Normal  ScalingReplicaSet  2m27s  deployment-controller  Scaled down replica set scaletestapp-c859d4df8 to 0 from 1
  Normal  ScalingReplicaSet  2m12s  deployment-controller  Scaled up replica set scaletestapp-6bdd4ddf69 to 3 from 1
  Normal  ScalingReplicaSet  12s    deployment-controller  Scaled up replica set scaletestapp-6bdd4ddf69 to 5 from 3
```

Видим по событиям, что сначала лимит реплик был поднят до трёх, а через 2 минуты до пяти. В это время продолжалась
работа Locust с RPS 312.
