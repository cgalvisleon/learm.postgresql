# Temario

## Sesion 1

1. Postgresql definición
2. Docker definición
3. Despliegue de postgresql con Docker
4. Conexión a la base
5. Creación de base de datos
6. Creación de schema
7. Creación de tablas e índices
8. Integridad referencial
9. Insert
10. Delete
11. Insert en bach
12. Funciones
13. Buenas practicas

## Sesion 2

14. Extensiones
15. PG_NOTIFY
16. Variables de sistema
17. Triggers
18. Estrategía de replicación
19. Buenas practicas

## Sesion 3

19. Api rest con Postgres y Go
20. Websockets
21. Buenas practicas

## Despliegue

```
git clone https://celsia-technet@dev.azure.com/celsia-technet/SGO/_git/CELSIA.learm.postgresql postgresql

cd postgresql

```

## Docker

```
docker-compose -f ./docker-compose.yml up -d
docker-compose -f ./docker-compose.yml down
```

## Docker swarm

```
mkdir db
mkdir db/postgres
mkdir pgadmin
docker stack deploy -c docker-compose.yml learm
docker stack rm learm
```

## Access url

```
http://pv30097:5050
```
