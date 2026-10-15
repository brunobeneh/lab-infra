# ADR 0001 - Docker sem o grupo `docker`

- **Status:** Aceita
- **Data:** 2026-10-14

## Contexto

O DOCKER01 (Ubuntu Server 24.04, `10.10.10.10`) executa o Docker Engine. Usuarios do grupo `docker` tem acesso direto ao socket do daemon (`/var/run/docker.sock`), o que equivale a privilegio de root no host. Exemplo: `docker run -v /:/host -it ubuntu chroot /host` abre um shell root sobre o disco do host sem pedir senha.

## Decisao

O usuario administrativo **nao** sera adicionado ao grupo `docker`. Todo comando Docker e executado com `sudo`.

## Consequencias

- (+) Toda acao privilegiada exige senha e fica registrada em `/var/log/auth.log`, que sera coletado pelo Splunk (trilha de auditoria).
- (+) Um processo comprometido executando como o usuario nao obtem root silenciosamente via socket.
- (-) Comandos mais longos (`sudo docker ...`).

## Alternativas consideradas

- **Grupo `docker`:** mais pratico, mas concede root sem senha.
- **Docker rootless:** mais robusto, porem exige ajustes de rede e portas; reavaliar na etapa de seguranca do repositorio.
