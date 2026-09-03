# Vue.js

- MUST use Composition API (NEVER Options API)
- MUST use relative paths for imports (NEVER alias paths like `@/`)
- MUST use `emit` instead of passing functions as props
- SHOULD prefer `ref` over `reactive`
- NEVER use `v-html` (security risk)
- MUST use vue-i18n for text; NEVER hardcode strings in templates (use `$t()`)

# Styling

- MUST style components with **Tailwind utilities only** — NEVER write CSS. No `<style>` / `<style scoped>` block, no per-component `.css` file, no `<style src="...">` import
- MUST convert an existing `<style>` block to utilities when touching that component, rather than extending it
- Repeated utility runs MUST be extracted as a shared **component** (or a `class` string constant) — NEVER as a shared CSS class
- Dynamic / themed values MUST go through design tokens consumed by a utility (`bg-[var(--cell-bg)]`), NEVER a stylesheet rule
- If something genuinely cannot be a utility (`@keyframes`, `:deep()` into injected markup), MUST put it in the **Tailwind theme or one global stylesheet** with a one-line reason — NEVER in a component
- Why: shared CSS silently stops applying when a component's template has a **fragment root** — Vue gives the parent's scope id to a single root element only, so scoped rules match nothing and the element falls back to browser defaults (mulmoterminal #787). Utilities are global and have no such failure mode
