# lab-infra

Laboratório de SOC (Security Operations Center) construído como **Infraestrutura como Código**.

## Stack

| Função | Ferramenta |
|---|---|
| Virtualização | Hyper-V |
| SIEM | Splunk Enterprise (Docker) |
| SOAR | Splunk SOAR Community Edition |
| Monitoramento | Zabbix + Grafana (Docker) |
| Diretório / políticas | Active Directory + GPO (Windows Server 2025) |
| Automação | Docker Compose, Ansible, Terraform, k3s, Packer |

## Roadmap

- [x] Fase 0 — Inventário e limpeza do lab anterior (Wazuh/TheHive)
- [ ] Fase 1 — Repositório e estrutura
- [ ] Fase 2 — Nó de contêineres + Docker Compose (Splunk, Zabbix, Grafana)
- [ ] Fase 3 — Ingestão de logs (Universal Forwarder, agentes Zabbix)
- [ ] Fase 4 — GPO de auditoria
- [ ] Fase 5 — Splunk SOAR + primeiro playbook
- [ ] Fase 6 — Ansible
- [ ] Fase 7 — Terraform (local)
- [ ] Fase 8 — k3s + Helm
- [ ] Fase 9 — Packer/Vagrant

## Segurança

Nenhum segredo é versionado. Credenciais ficam em arquivos `.env` (ignorados pelo Git); o repositório traz apenas modelos `.env.example`.
