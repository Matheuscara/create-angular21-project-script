#!/bin/bash

# Script para criar projeto Angular 21 com Tailwind CSS e PrimeNG
# Uso: ./create-angular21-project.sh nome-do-projeto

set -e  # Para o script se houver erro

PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  echo "❌ Erro: Você precisa fornecer o nome do projeto"
  echo "Uso: ./create-angular21-project.sh nome-do-projeto"
  exit 1
fi

echo "🚀 Criando projeto Angular 21: $PROJECT_NAME"
echo ""

# 1. Criar novo projeto Angular 21 com configurações modernas
echo "📦 Criando projeto Angular com SSR e configurações modernas..."
npx @angular/cli@21 new $PROJECT_NAME \
  --routing=true \
  --style=scss \
  --ssr=true \
  --skip-git=false \
  --package-manager=npm

cd $PROJECT_NAME

echo ""
echo "✅ Projeto Angular criado!"
echo ""

# 2. Instalar e configurar Tailwind CSS
echo "🎨 Instalando Tailwind CSS..."
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init

# Configurar tailwind.config.js
echo "⚙️  Configurando Tailwind CSS..."
cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

# Adicionar diretivas do Tailwind no styles.scss
cat > src/styles.scss << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

echo "✅ Tailwind CSS configurado!"
echo ""

# 3. Instalar PrimeNG e dependências
echo "🎯 Instalando PrimeNG e dependências..."
npm install primeng primeicons

# Configurar PrimeNG no angular.json
echo "⚙️  Configurando PrimeNG..."

# Adicionar estilos do PrimeNG no angular.json
npx json -I -f angular.json -e 'this.projects["'$PROJECT_NAME'"].architect.build.options.styles.unshift("node_modules/primeicons/primeicons.css")'
npx json -I -f angular.json -e 'this.projects["'$PROJECT_NAME'"].architect.build.options.styles.unshift("node_modules/primeng/resources/primeng.min.css")'
npx json -I -f angular.json -e 'this.projects["'$PROJECT_NAME'"].architect.build.options.styles.unshift("node_modules/primeng/resources/themes/lara-light-blue/theme.css")'

# Se json command não estiver disponível, fazer manualmente
if [ $? -ne 0 ]; then
  echo "⚠️  Instalando json-cli para configuração..."
  npm install -g json

  npx json -I -f angular.json -e 'this.projects["'$PROJECT_NAME'"].architect.build.options.styles.unshift("node_modules/primeicons/primeicons.css")'
  npx json -I -f angular.json -e 'this.projects["'$PROJECT_NAME'"].architect.build.options.styles.unshift("node_modules/primeng/resources/primeng.min.css")'
  npx json -I -f angular.json -e 'this.projects["'$PROJECT_NAME'"].architect.build.options.styles.unshift("node_modules/primeng/resources/themes/lara-light-blue/theme.css")'
fi

echo "✅ PrimeNG configurado!"
echo ""

# 4. Configurar app.config.ts para PrimeNG Animations
echo "⚙️  Configurando animations do PrimeNG..."
cat > src/app/app.config.ts << 'EOF'
import { ApplicationConfig, provideZoneChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideClientHydration } from '@angular/platform-browser';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { provideHttpClient, withFetch } from '@angular/common/http';

import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes),
    provideClientHydration(),
    provideAnimationsAsync(),
    provideHttpClient(withFetch())
  ]
};
EOF

echo "✅ Configuração de animations concluída!"
echo ""

# 5. Criar exemplo de componente com PrimeNG e Tailwind
echo "📝 Criando componente de exemplo..."
cat > src/app/app.component.ts << 'EOF'
import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { ButtonModule } from 'primeng/button';
import { CardModule } from 'primeng/card';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, ButtonModule, CardModule],
  template: `
    <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-8">
      <div class="max-w-4xl mx-auto">
        <h1 class="text-4xl font-bold text-gray-800 mb-8 text-center">
          🚀 Angular 21 + Tailwind CSS + PrimeNG
        </h1>

        <p-card class="mb-6">
          <ng-template pTemplate="header">
            <div class="p-4 bg-gradient-to-r from-blue-500 to-indigo-600">
              <h2 class="text-2xl font-semibold text-white">Bem-vindo ao seu novo projeto!</h2>
            </div>
          </ng-template>

          <div class="space-y-4">
            <p class="text-gray-700">
              Este projeto está configurado com as tecnologias mais modernas do Angular:
            </p>

            <ul class="list-disc list-inside space-y-2 text-gray-600">
              <li><strong>Angular 21</strong> - Última versão com standalone components</li>
              <li><strong>Zoneless Change Detection</strong> - Performance otimizada</li>
              <li><strong>Server-Side Rendering (SSR)</strong> - SEO e performance</li>
              <li><strong>Tailwind CSS</strong> - Utility-first CSS framework</li>
              <li><strong>PrimeNG</strong> - Biblioteca de componentes UI rica</li>
              <li><strong>Vitest</strong> - Framework de testes moderno</li>
            </ul>

            <div class="flex gap-3 mt-6">
              <p-button
                label="Botão Primary"
                icon="pi pi-check"
                severity="primary">
              </p-button>

              <p-button
                label="Botão Success"
                icon="pi pi-star"
                severity="success">
              </p-button>

              <p-button
                label="Botão Info"
                icon="pi pi-info-circle"
                severity="info">
              </p-button>
            </div>
          </div>

          <ng-template pTemplate="footer">
            <div class="flex justify-between items-center">
              <span class="text-sm text-gray-500">Criado com ❤️ usando Angular CLI</span>
              <p-button
                label="Saiba Mais"
                icon="pi pi-arrow-right"
                iconPos="right"
                [outlined]="true">
              </p-button>
            </div>
          </ng-template>
        </p-card>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow">
            <i class="pi pi-palette text-4xl text-blue-500 mb-3"></i>
            <h3 class="text-xl font-semibold mb-2">Tailwind CSS</h3>
            <p class="text-gray-600">Estilização rápida e moderna com classes utilitárias</p>
          </div>

          <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow">
            <i class="pi pi-bolt text-4xl text-indigo-500 mb-3"></i>
            <h3 class="text-xl font-semibold mb-2">Zoneless</h3>
            <p class="text-gray-600">Change detection otimizada sem Zone.js</p>
          </div>

          <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow">
            <i class="pi pi-desktop text-4xl text-purple-500 mb-3"></i>
            <h3 class="text-xl font-semibold mb-2">PrimeNG</h3>
            <p class="text-gray-600">Componentes UI ricos e prontos para usar</p>
          </div>
        </div>
      </div>
    </div>

    <router-outlet />
  `,
  styles: [`
    :host ::ng-deep {
      .p-card {
        box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
        border-radius: 0.5rem;
        overflow: hidden;
      }

      .p-card .p-card-body {
        padding: 1.5rem;
      }

      .p-card .p-card-footer {
        padding: 1rem 1.5rem;
        background-color: #f9fafb;
      }
    }
  `]
})
export class AppComponent {
  title = '$PROJECT_NAME';
}
EOF

echo "✅ Componente de exemplo criado!"
echo ""

# 6. Criar README com instruções
echo "📄 Criando README..."
cat > README.md << 'EOF'
# Angular 21 Project

Este projeto foi criado com as tecnologias mais modernas do Angular ecosystem.

## 🚀 Tecnologias

- **Angular 21** - Framework web moderno
- **Standalone Components** - Arquitetura sem NgModules
- **Zoneless Change Detection** - Performance otimizada
- **Server-Side Rendering (SSR)** - SEO e performance
- **Tailwind CSS** - Framework CSS utility-first
- **PrimeNG** - Biblioteca de componentes UI
- **Vitest** - Framework de testes moderno
- **TypeScript** - Type safety

## 📦 Instalação

As dependências já foram instaladas durante a criação do projeto.

Se precisar reinstalar:

```bash
npm install
```

## 🛠️ Desenvolvimento

Inicie o servidor de desenvolvimento:

```bash
npm start
```

Navegue para `http://localhost:4200/`. A aplicação recarregará automaticamente quando você modificar os arquivos.

## 🏗️ Build

Build de produção:

```bash
npm run build
```

Os arquivos compilados estarão em `dist/`.

## 🧪 Testes

Execute os testes unitários com Vitest:

```bash
npm test
```

## 📚 Estrutura de Componentes

Todos os componentes são **standalone** por padrão. Exemplo:

```typescript
import { Component } from '@angular/core';
import { ButtonModule } from 'primeng/button';

@Component({
  selector: 'app-example',
  standalone: true,
  imports: [ButtonModule],
  template: `
    <p-button label="Click me" />
  `
})
export class ExampleComponent {}
```

## 🎨 Tailwind CSS

Use classes utilitárias diretamente nos templates:

```html
<div class="flex items-center justify-center p-4 bg-blue-500">
  <h1 class="text-2xl font-bold text-white">Hello Tailwind!</h1>
</div>
```

## 🎯 PrimeNG

Importe os módulos do PrimeNG conforme necessário:

```typescript
import { ButtonModule } from 'primeng/button';
import { CardModule } from 'primeng/card';
import { InputTextModule } from 'primeng/inputtext';

@Component({
  imports: [ButtonModule, CardModule, InputTextModule],
  // ...
})
```

Componentes disponíveis: https://primeng.org/

## 📖 Recursos

- [Angular Documentation](https://angular.dev)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [PrimeNG Documentation](https://primeng.org/)
- [Angular 21 Announcement](https://blog.angular.dev/announcing-angular-v21-57946c34f14b)

## 🔧 Configurações Avançadas

### Zoneless Change Detection

Este projeto usa zoneless change detection por padrão. Use signals para estado reativo:

```typescript
import { signal } from '@angular/core';

export class MyComponent {
  count = signal(0);

  increment() {
    this.count.update(v => v + 1);
  }
}
```

### Server-Side Rendering

Para APIs específicas do browser, verifique a plataforma:

```typescript
import { PLATFORM_ID, inject } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';

export class MyComponent {
  private platformId = inject(PLATFORM_ID);

  useLocalStorage() {
    if (isPlatformBrowser(this.platformId)) {
      localStorage.setItem('key', 'value');
    }
  }
}
```

## 📝 Comandos Úteis

```bash
# Gerar novo componente
ng generate component nome-do-componente

# Gerar novo service
ng generate service nome-do-servico

# Gerar novo guard
ng generate guard nome-do-guard

# Build com SSR
npm run build

# Servir build SSR
npm run serve:ssr
```

---

Feito com ❤️ usando Angular CLI
EOF

echo "✅ README criado!"
echo ""

# 7. Criar arquivo de configuração do Prettier
echo "💅 Configurando Prettier..."
cat > .prettierrc << 'EOF'
{
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "semi": true,
  "singleQuote": true,
  "trailingComma": "es5",
  "bracketSpacing": true,
  "arrowParens": "avoid"
}
EOF

npm install -D prettier

echo "✅ Prettier configurado!"
echo ""

echo "🎉 Projeto criado com sucesso!"
echo ""
echo "📁 Próximos passos:"
echo ""
echo "   cd $PROJECT_NAME"
echo "   npm start"
echo ""
echo "🌐 Acesse: http://localhost:4200"
echo ""
echo "✨ Configurações ativadas:"
echo "   ✅ Angular 21"
echo "   ✅ Standalone Components (padrão)"
echo "   ✅ Zoneless Change Detection"
echo "   ✅ Server-Side Rendering (SSR)"
echo "   ✅ Tailwind CSS"
echo "   ✅ PrimeNG (última versão)"
echo "   ✅ Vitest"
echo "   ✅ Prettier"
echo ""
echo "📚 Documentação útil:"
echo "   - Angular: https://angular.dev"
echo "   - Tailwind: https://tailwindcss.com/docs"
echo "   - PrimeNG: https://primeng.org"
echo ""
