# IAC-TERRAFORM-AWS

Este é um projeto de estudos sobre **Infrastructure as Code (IaC)** utilizando **Terraform**, **AWS** e **GitHub Actions**, demonstrando como automatizar o provisionamento de recursos em nuvem de forma simples, mas seguindo conceitos amplamente utilizados no mercado.

---

## Status atual

- [x] Inicialização do projeto  
- [x] Configuração do provider da AWS (`providers.tf`)  
- [x] Criação automática de bucket S3 via Terraform  
- [x] Configuração de **Static Website Hosting** no S3  
- [x] Ajuste de permissões públicas para servir conteúdo estático  
- [x] Automação do `terraform init` e `terraform apply` via **GitHub Actions**  
- [x] Sanitização de nomes de buckets a partir de títulos de issues  
- [x] Comentário automático na issue com o status do deploy  

---

## Objetivo

Demonstrar na prática como unir **Terraform** e **GitHub Actions** para:

- Provisionar recursos na **AWS** de forma declarativa.  
- Automatizar o ciclo de infraestrutura diretamente a partir de ações no GitHub.  
- Evitar execução manual de comandos Terraform localmente.  
- Garantir consistência e repetibilidade na criação de recursos.  

---

## Recursos provisionados

- **Bucket S3**  
  - Nome dinâmico baseado no título da issue no GitHub.  
  - Configuração para **hospedagem de site estático** (`index.html` como página inicial e de erro).  
  - ACL pública de leitura.  
  - Política pública permitindo `s3:GetObject` para qualquer usuário.  
  - Desbloqueio de restrições de acesso público no nível da conta e do bucket.

---

## Fluxo de automação com GitHub Actions

1. **Abertura de uma issue** no repositório com título iniciando por `front`.  
2. O workflow:
   - Extrai e sanitiza o nome do bucket a partir do título.  
   - Configura credenciais da AWS usando secrets do repositório.  
   - Executa `terraform init` e `terraform apply` no diretório do módulo.  
   - Cria o bucket S3 e aplica todas as configurações necessárias.  
3. **Comentário automático** na issue confirmando o sucesso da criação.  

---

## Tecnologias utilizadas

- **Terraform** `>= 1.x`  
- **AWS S3**  
- **GitHub Actions** para CI/CD de infraestrutura  
- **AWS CLI** (opcional para debug e inspeção de recursos)  

---

## Estrutura do projeto

```plaintext
.
├── terraform/
│   └── s3-bucket-static/
│       ├── main.tf           # Recursos AWS (S3, ACL, Policy, Website Config)
│       ├── variables.tf      # Variáveis do módulo
│       ├── providers.tf      # Provider AWS
│       └── outputs.tf        # Saídas do módulo (opcional)
├── .github/
│   └── workflows/
│       └── create-s3-site.yml  # Workflow GitHub Actions
├── .gitignore                # Ignora state files, cache e variáveis sensíveis
└── README.md
