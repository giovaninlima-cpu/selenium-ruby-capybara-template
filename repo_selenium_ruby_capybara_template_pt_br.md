# selenium-ruby-capybara-template

> **Template completo** para você criar rapidamente um repositório no GitHub com **Selenium + Ruby + Capybara + RSpec**, incluindo **GitHub Actions**, **Page Objects**, **ambientes (dev/ci)**, **Docker opcional** e **documentação passo a passo** para quem vai fazer tudo **pela primeira vez** — perfeito para se preparar para **entrevistas de QA**.

---

## 📦 O que vem no template

- Estrutura de projeto Ruby com RSpec
- Capybara com Selenium WebDriver (Chrome e Firefox)
- Page Object Pattern
- Suporte a `.env` (variáveis de ambiente)
- Geração de evidências (screenshots) on-failure
- GitHub Actions (pipeline CI) executando testes em headless
- Suporte opcional a Docker
- Checklists e perguntas de entrevista (QA/QA Automation)

---

## 🗂️ Estrutura de pastas

```text
selenium-ruby-capybara-template/
├─ .github/
│  └─ workflows/
│     └─ ci.yml
├─ .ruby-version
├─ .gitignore
├─ Gemfile
├─ Gemfile.lock (gerado)
├─ README.md
├─ .env.example
├─ docker/
│  └─ Dockerfile
├─ spec/
│  ├─ spec_helper.rb
│  ├─ support/
│  │  ├─ capybara.rb
│  │  ├─ screenshots.rb
│  │  └─ helpers.rb
│  ├─ pages/
│  │  ├─ base_page.rb
│  │  └─ google_home_page.rb
│  └─ features/
│     └─ google_search_spec.rb
```

---

## 🚀 Como criar seu repositório no GitHub (passo a passo)

1) **Crie um novo repositório no GitHub** (público ou privado) com o nome `selenium-ruby-capybara-template`.

2) **Clone localmente**:

```bash
git clone https://github.com/<seu-usuario>/selenium-ruby-capybara-template.git
cd selenium-ruby-capybara-template
```

3) **Crie os arquivos usando este README** (abaixo há o conteúdo de cada arquivo). Você pode:
- Copiar/colar os blocos de código para os arquivos indicados, **ou**
- Usar um editor (VS Code) e salvar cada arquivo conforme a árvore acima.

4) **Commit e push**:

```bash
git add .
git commit -m "feat: template Selenium Ruby Capybara com CI"
git push origin main
```

> Dica: após subir, o GitHub Actions já vai rodar o pipeline `ci.yml` automaticamente.

---

## 🧰 Pré-requisitos (instalação do ambiente)

Escolha seu sistema e siga os passos.

### Windows (com Chocolatey)

1. Instale **Chocolatey** (se ainda não tiver). Procure no site oficial.
2. Instale Ruby e Git:

```powershell
choco install -y ruby git
```

3. Feche e reabra o terminal. Verifique:

```powershell
ruby -v
bundler -v  # se não tiver, instale: gem install bundler
```

4. (Opcional) Instale o Google Chrome e/ou Firefox:

```powershell
choco install -y googlechrome firefox
```

### macOS (Homebrew)

```bash
brew install ruby git
ruby -v
# bundler pode vir junto, senão:
gem install bundler
brew install --cask google-chrome firefox
```

### Linux (Debian/Ubuntu)

```bash
sudo apt update && sudo apt install -y ruby-full build-essential git wget
ruby -v
sudo gem install bundler
sudo apt install -y firefox-esr
# Chrome opcional:
wget -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y /tmp/chrome.deb || sudo apt -f install -y
```

### Drivers (geralmente não precisa instalar manualmente)

- O **Selenium** conversa com o navegador via drivers (ChromeDriver, GeckoDriver). As versões recentes do Selenium já **fazem o download e o gerenciamento automaticamente** (Selenium Manager). Se precisar manualmente, consulte os sites oficiais dos drivers.

---

## 📥 Dependências do projeto

Crie o `Gemfile` (conteúdo abaixo) e depois rode:

```bash
bundle install
```

Se aparecer erro de permissão no Linux/macOS, experimente `bundle config set path 'vendor/bundle'` e depois `bundle install`.

---

## ▶️ Como executar os testes localmente

1) Copie `.env.example` para `.env` e ajuste variáveis se necessário:

```bash
cp .env.example .env  # macOS/Linux
# Windows (PowerShell)
copy .env.example .env
```

2) Rode os testes:

```bash
bundle exec rspec
```

3) Rodar um arquivo específico (exemplo):

```bash
bundle exec rspec spec/features/google_search_spec.rb -f doc
```

4) Visualizar execução não-headless (com browser abrindo):

- Edite `spec/support/capybara.rb` e altere `HEADLESS=true` para `false` **ou** exporte a variável de ambiente:

```bash
# macOS/Linux\ nexport HEADLESS=false
# Windows (PowerShell)
$env:HEADLESS="false"
```

---

## 🧪 Conteúdo dos arquivos

> **Copie cada bloco para o respectivo arquivo** (criando as pastas se necessário).

### `Gemfile`

```ruby
source "https://rubygems.org"

gem "rspec"
gem "capybara"
gem "selenium-webdriver"
gem "webdrivers"   # opcional se quiser gerenciar drivers

gem "dotenv"       # variáveis de ambiente
```

### `.gitignore`

```gitignore
/vendor/
.bundle/
.env
*.log
.DS_Store
coverage/
```

### `.ruby-version`

```text
3.2.2
```

> Use a versão de Ruby que você tiver instalada. Ajuste aqui e no CI.

### `.env.example`

```bash
# Modo headless (true/false)
HEADLESS=true
# Navegador: chrome ou firefox
BROWSER=chrome
# Base URL (seu AUT – Application Under Test)
BASE_URL=https://www.google.com/
```

### `spec/spec_helper.rb`

```ruby
# frozen_string_literal: true

require "rspec"
require "dotenv"
Dotenv.load

Dir[File.join(__dir__, "support", "**", "*.rb")].sort.each { |f| require f }
Dir[File.join(__dir__, "pages", "**", "*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.formatter = :documentation

  # Screenshot automático ao falhar
  config.after(:each) do |example|
    if example.exception
      timestamp = Time.now.strftime("%Y%m%d-%H%M%S")
      name = example.full_description.gsub(/\s+/, "_")
      path = File.join(Dir.pwd, "screenshots", "#{name}-#{timestamp}.png")
      FileUtils.mkdir_p(File.dirname(path))
      Capybara.page.save_screenshot(path)
      puts "\n[INFO] Screenshot salvo em: #{path}"
    end
  end
end
```

### `spec/support/capybara.rb`

```ruby
# frozen_string_literal: true

require "capybara/rspec"
require "selenium-webdriver"

HEADLESS = ENV.fetch("HEADLESS", "true").casecmp?("true")
BROWSER  = ENV.fetch("BROWSER",  "chrome").downcase
BASE_URL = ENV.fetch("BASE_URL", "https://www.google.com/")

Capybara.configure do |config|
  config.default_driver = :selenium
  config.javascript_driver = :selenium
  config.app_host = BASE_URL
  config.default_max_wait_time = 10
end

Capybara.register_driver :selenium do |app|
  case BROWSER
  when "chrome"
    opts = ::Selenium::WebDriver::Chrome::Options.new
    opts.add_argument("--window-size=1366,768")
    opts.add_argument("--disable-gpu")
    opts.add_argument("--no-sandbox")
    opts.add_argument("--disable-dev-shm-usage")
    opts.add_argument("--headless=new") if HEADLESS
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: opts)
  when "firefox"
    opts = ::Selenium::WebDriver::Firefox::Options.new
    opts.add_argument("--width=1366")
    opts.add_argument("--height=768")
    opts.add_argument("-headless") if HEADLESS
    Capybara::Selenium::Driver.new(app, browser: :firefox, options: opts)
  else
    raise "BROWSER inválido: #{BROWSER}. Use chrome ou firefox."
  end
end
```

### `spec/support/helpers.rb`

```ruby
# frozen_string_literal: true

module Helpers
  def fill_and_submit(selector, value)
    find(selector).set(value)
    send_keys(:enter)
  end
end

RSpec.configure { |c| c.include Helpers }
```

### `spec/support/screenshots.rb`

```ruby
# frozen_string_literal: true
# (mantido vazio: a lógica está no spec_helper.rb)
```

### `spec/pages/base_page.rb`

```ruby
# frozen_string_literal: true

class BasePage
  include Capybara::DSL

  def visit_path(path = "/")
    visit(path)
  end
end
```

### `spec/pages/google_home_page.rb`

```ruby
# frozen_string_literal: true

class GoogleHomePage < BasePage
  def search_box
    find("input[name='q']")
  end

  def search_for(term)
    search_box.set(term)
    search_box.send_keys(:enter)
  end

  def results_present?
    has_css?("#search")
  end
end
```

### `spec/features/google_search_spec.rb`

```ruby
# frozen_string_literal: true

require "spec_helper"

describe "Pesquisa no Google", type: :feature do
  it "realiza uma busca simples" do
    page = GoogleHomePage.new
    page.visit_path("/")
    page.search_for("Capybara Ruby")

    expect(page).to be_results_present
  end
end
```

---

## 🤖 GitHub Actions (CI)

Crie o arquivo `.github/workflows/ci.yml`:

```yaml
name: Ruby RSpec CI

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.2'
          bundler-cache: true

      - name: Install system deps (browsers)
        run: |
          sudo apt-get update
          sudo apt-get install -y xvfb
          sudo apt-get install -y firefox-esr
          wget -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
          sudo apt-get install -y /tmp/chrome.deb || sudo apt-get -f install -y

      - name: Set env
        run: |
          cp .env.example .env
          echo "HEADLESS=true" >> .env
          echo "BROWSER=chrome" >> .env

      - name: Run tests (headless)
        run: |
          bundle exec rspec
```

> Observação: `xvfb` é usado para fornecer um display virtual quando necessário.

---

## 🐳 Docker (opcional)

Crie `docker/Dockerfile`:

```dockerfile
FROM ruby:3.2

RUN apt-get update \
    && apt-get install -y wget gnupg2 curl unzip \
    && apt-get install -y firefox-esr \
    && wget -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y /tmp/chrome.deb || apt-get -f install -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY Gemfile Gemfile.lock* /app/
RUN gem install bundler && bundle install
COPY . /app

ENV HEADLESS=true BROWSER=chrome BASE_URL=https://www.google.com/

CMD ["bash", "-lc", "bundle exec rspec"]
```

**Build e run:**

```bash
docker build -t qa-ruby-capybara -f docker/Dockerfile .
docker run --rm qa-ruby-capybara
```

---

## 🧱 Page Objects – boas práticas (resumo)

- Cada página = 1 classe em `spec/pages`.
- Exponha **métodos de ação** (ex.: `search_for`) e **métodos de verificação** (ex.: `results_present?`).
- Evite `sleep`; prefira matchers do Capybara (`has_css?`, `has_text?`).
- Centralize seletores em métodos (fácil manutenção).

---

## 🧷 Variáveis de ambiente

- Use `.env` para configs locais e segredos **não críticos**.
- No GitHub, use **Settings → Secrets and variables → Actions** para segredos.

Exemplos de variáveis úteis:

```
BASE_URL=https://seu-sistema.dev
HEADLESS=true
BROWSER=chrome
USER_EMAIL=qa@example.com
USER_PASSWORD=supersecreto
```

---

## 🖼️ Evidências (screenshots)

- Ao falhar um teste, um screenshot é salvo na pasta `./screenshots` com timestamp.
- Para capturar sempre, adicione manualmente onde quiser: `page.save_screenshot('path.png')`.

---

## 🔎 Dicas para entrevista de QA/Automation

**Fale sobre:**
- Por que escolheu **Ruby + Capybara** (DSL expressiva, comunidade forte, rápido para prototipar).
- **Estratégia de testes**: pirâmide, riscos, testes e2e vs. integração vs. unitários.
- **Estabilidade**: espera explícita/implícita do Capybara, selectors resilientes (data-*), retry.
- **Pipeline CI**: execução headless, paralelismo, reports, artifacts (screenshots).
- **Page Objects** e separação de responsabilidades.
- **Configuração por ambiente** (dev, staging, prod) via variáveis.

**Perguntas comuns:**
- Diferença entre **Selenium** e **Capybara**?
- Como evitar **flaky tests**?
- O que é **headless** e quando usar?
- Como você **estruturaria** um projeto de automação do zero?
- Estratégias para **dados de teste** (fixtures, factories, mocks).

**Desafios práticos** que podem aparecer:
- Automatizar login e uma busca simples.
- Validar elementos dinâmicos com `has_css?` / `has_text?`.
- Configurar teste para rodar no **CI**.

---

## 🧪 Próximos passos (exercícios)

1. Trocar `BASE_URL` para um site de treinamento (ex.: demoqa, saucedemo) e criar 2 novos Page Objects.
2. Adicionar `rubocop` (lint) e `parallel_tests` (paralelismo) ao Gemfile e pipeline.
3. Subir **relatórios HTML** (ex.: `rspec_junit_formatter` ou `report_builder`) como artifact do Actions.
4. Configurar execução **por tag** (ex.: `rspec --tag @smoke`).

---

## 🆘 Problemas comuns & soluções rápidas

- **Navegador não abre/headless falha**: verifique versão do Ruby, drivers e flags `--no-sandbox --disable-dev-shm-usage` no Chrome.
- **Element not found**: aumente `default_max_wait_time` e use seletores mais estáveis.
- **Timeout em CI**: verifique instalação do Chrome/Firefox e habilite `xvfb`.
- **Incompatibilidade de versões**: atualize `selenium-webdriver` e o navegador.

---

## 📤 Publicando seu repo

1. Confirme o pipeline passando no GitHub Actions.
2. Adicione uma descrição clara e tags: `selenium`, `ruby`, `capybara`, `qa`, `automation`, `rspec`.
3. Ative **Branch Protection** (opcional) e badges de status do Actions.

Badge (adicione no topo do README após o primeiro push):

```markdown
![CI](https://github.com/<seu-usuario>/selenium-ruby-capybara-template/actions/workflows/ci.yml/badge.svg)
```

---

## 📚 Referências úteis

- Documentação do RSpec, Capybara e Selenium (busque pelos sites oficiais)
- GitHub Actions – `ruby/setup-ruby`

---

## ✅ Checklist final para entrevista

- [ ] Projeto roda localmente (Chrome e Firefox) com `bundle exec rspec`
- [ ] Pipeline GitHub Actions verde
- [ ] Page Objects criados e bem organizados
- [ ] Screenshots on-failure funcionando
- [ ] Explicar escolhas técnicas e trade-offs
- [ ] Ter 2–3 cenários de teste demo (CRUD simples ou busca/login)

---

> **Pronto!** Com este template você consegue **criar, subir e demonstrar** um projeto de automação web em Ruby/Capybara de ponta a ponta. Ajuste o `BASE_URL` para o sistema que você quer demonstrar na entrevista e inclua cenários que contem a história do seu **raciocínio de QA** (riscos, cobertura, estabilidade). Boa sorte! 🎯

