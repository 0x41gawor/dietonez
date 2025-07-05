# Run

```sh
npm run dev -- --host
```

## Sturktura plików
```markdown
src/
├── assets/                 # statyczne zasoby (ikony, obrazy, czcionki, itp.)
├── components/             # komponenty współdzielone (Button, Table, Input, itd.)
├── features/               # główne funkcje aplikacji (z widokami i logiką)
│   ├── ingredients/        # PW.1
│   │   ├── views/          # widoki routowalne (np. IngredientsPage.vue)
│   │   ├── components/     # komponenty lokalne (np. IngredientTable.vue)
│   │   ├── composables/    # logika zarządzania stanem lub API
│   │   └── types.ts        # typy specyficzne dla składników
│   ├── dishes/             # PW.2
│   ├── diets/              # PW.3
│   └── context/            # PW.4 - bieżący dzień/dieta
├── router/
│   └── index.ts            # definicje routów
├── api/
│   ├── client.ts           # wrapper na fetch / axios z bazowym adresem
│   ├── ingredients.ts      # konkretne wywołania API
│   ├── dishes.ts
│   └── ...
├── types/                  # wspólne typy DTO z backendu (z OpenAPI)
├── utils/                  # funkcje pomocnicze, np. formatowanie
├── style/
│   ├── style.css           # globalny CSS (ten co już mamy)
│   └── variables.css       # opcjonalnie podział zmiennych
├── App.vue
├── main.ts
└── shims-vue.d.ts          # (do TypeScripta, jeśli potrzebne)
```