# Proyecto de Automatización — DemoBlaze

Proyecto de pruebas automatizadas para el sitio [DemoBlaze](https://www.demoblaze.com) utilizando **Cucumber + Ruby + Capybara + Selenium**.

## Stack

| Herramienta | Versión |
|-------------|---------|
| cucumber-ruby | 9.2.1 |
| Ruby | 3.0.2 |
| Plataforma | mingw32 (Windows) |
| Capybara | — |
| Selenium WebDriver | — |

## Estructura del proyecto

```
features/
├── signup.feature              # Escenarios de registro y login
├── step_definitions/
│   └── signup_steps.rb         # Steps en Ruby
└── support/
    └── env.rb                  # Configuración de Capybara + hooks
reports/                        # Reports HTML generados (gitignored)
.run_once/                      # Marcadores de ejecución única (gitignored)
.gitignore
README.md
```

## Setup

Instalá las dependencias:

```bash
gem install bundler
bundle install
```

Si no tenés `Gemfile`, crealo:

```ruby
source 'https://rubygems.org'

gem 'cucumber'
gem 'capybara'
gem 'selenium-webdriver'
gem 'capybara-screenshot'
gem 'rspec'
```

## Ejecución

### Todos los escenarios

```bash
cucumber features/signup.feature -f html -o reports/report.html
```

### Por tag

```bash
# Smoke tests (registro + login exitoso)
cucumber --tags @smoke -f html -o reports/smoke.html

# Regresión completa (login fallido, usuario existente)
cucumber --tags @regression -f html -o reports/regression.html

# Solo escenarios de login
cucumber --tags @login -f html -o reports/login.html

# Solo escenarios de signup
cucumber --tags @signup -f html -o reports/signup.html

# Solo flujos positivos
cucumber --tags @positive -f html -o reports/positive.html

# Solo flujos negativos
cucumber --tags @negative -f html -o reports/negative.html

# Excluir escenarios de una sola ejecución
cucumber --tags "not @first_run_only" -f html -o reports/rest.html

# Múltiples tags (smoke + regression = todo)
cucumber --tags "@smoke or @regression" -f html -o reports/all.html
```

### Ver en consola (sin reporte HTML)

```bash
cucumber features/signup.feature
```

## Tags

| Tag | Tipo | Propósito |
|-----|------|-----------|
| `@smoke` | Nivel | Escenarios críticos que deben pasar siempre |
| `@regression` | Nivel | Suite completa de regresión |
| `@positive` | Tipo | Flujo feliz (happy path) |
| `@negative` | Tipo | Flujo de error o bordes |
| `@signup` | Módulo | Registro de usuario |
| `@login` | Módulo | Inicio de sesión |
| `@first_run_only` | Estado | Se ejecuta UNA sola vez (usa marcador en `.run_once/`) |

Los tags se combinan. Un escenario puede tener varios:

```gherkin
@smoke @positive @signup @first_run_only
Scenario: Registro exitoso con validación mediante login
```

## Escenarios incluidos

| # | Escenario | Tags |
|---|-----------|------|
| 1 | Registro exitoso → login y verificación | `@smoke @positive @signup @first_run_only` |
| 2 | Login con contraseña incorrecta | `@regression @negative @login` |
| 3 | Registro con usuario ya existente | `@regression @negative @signup` |

## Notas

- **`@first_run_only`**: Crea un archivo marcador en `.run_once/` luego de ejecutarse. En corridas posteriores el escenario se saltea automáticamente. Para resetear: borrá la carpeta `.run_once/`.
- **DemoBlaze** tiene persistencia limitada. El registro funciona una sola vez por usuario. Por eso el escenario 1 usa `@first_run_only` y el escenario 3 valida que al intentar de nuevo salte el error "This user already exist."
- Los reports HTML se guardan en `reports/`. Asegurate que la carpeta exista antes de ejecutar:
  ```bash
  New-Item -ItemType Directory -Path reports -Force
  ```
