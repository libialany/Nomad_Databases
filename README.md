# Nomad_Databases

Orchestrate postgres containers with nomad and traefik using nomad.

I wanted to create a project based on this one [Infinite Databases with Nomad and Traefik](https://thekevinwang.com/2023/09/24/infinite-dbs-with-nomad), I had to repair that project because there were incorrect parameters.

nomad:

```
Nomad v1.7.2
BuildDate ......
Revision ....
```

start traefik:

`nomad job run -var="token=zxcsdfsdf34534frvfd" traefik.nomad.hcl`

start postgres:

`nomad job run -var-file="dev.vars"  <postgres>.nomad.hcl`

start dynamic postgres:

`bash test.sh`

If you want to instantiate more database change this parameter:

`new_word="NEW_WORD"`

verify your ip:

`psql postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${NAME_CONTAINER_DATABASE}.${DOMAIN}/${POSTGRES_DB_NAME}?sslmode=require`

> IMPORTANT: Setting sslmode=require for Traefik configuration. Without this setting, Traefik may function solely as a load balancer, the isolation of databases with sslmode=require.