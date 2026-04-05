# DEV_PROCESS.md

Development history, rationale, and roadmap for Sultana.

---

## What was built and why

### Foundation (Oct 2024)

Started with standard Rails scaffolding + Devise authentication. Early commits explored a JWT-based API approach, but that was scrapped in favour of a server-rendered Rails app — simpler to maintain for a small single-user admin tool.

Unauthenticated and authenticated routes were split early: the public root shows the menu display; logged-in users land on the dashboard.

### Core domain models

Built out the core data model: `Menu` → `MenuItem` → `Item` → `Recipe` → `Product`, plus `Order` → `OrderItem` → `Customer`.

Key decisions:
- **Price lives on `MenuItem`, not `Item`.** An item's price can differ between menus. `OrderItem` stores a snapshot of the price at order time, decoupled from the menu, so historical orders stay accurate.
- **`currently_displayed` flag on `Menu`.** Only one menu is public at a time. This makes the public endpoint simple (`Menu.find_by(currently_displayed: true)`).
- **AASM for order status.** The order lifecycle (`pending → confirmed → preparing → ready → delivered → paid`) is modelled as a state machine to make valid transitions explicit and prevent invalid state jumps.
- **Products + Recipes for ingredient tracking.** Items have recipes (ingredient lists), recipes reference products. This was put in place to support grocery list generation.

### ResourceController abstraction (mid-development)

Rather than generating repetitive scaffolds, a shared `ResourceController` base class was built. It infers the model and resource name from the controller name and provides CRUD actions with Turbo Stream responses for a modal-based UI. Models expose `table_attributes`, `show_attributes`, and `associated_collections` via the `ResourceAttributes` concern.

This significantly reduced boilerplate — adding a new resource only requires a model, a thin controller, and a form partial.

### Public menu display

Styled the public-facing menu display with TailwindCSS: collapsible categories, is_vegan / is_popular / is_new labels, WhatsApp direct-order button, and an Instagram link. The background succulent image and logo were added for branding.

Localization (NIS currency, Hebrew-friendly layout) was added early.

### Dashboard and caching

Built a dashboard with business metrics: revenue this month, order count, average order value, open orders. A `CacheableQueries` concern was added to avoid expensive queries on every page load (1-hour cache, cleared on Order updates).

### Tests (PR #18)

Added RSpec with FactoryBot, Shoulda Matchers, DatabaseCleaner, and SimpleCov. Coverage threshold set at 90%. Initial specs cover Customer and Category models plus their factories.

### Passover menu (PR #19, Apr 2025)

Added a `/passover_menu` route rendering a dedicated holiday menu view. Adjustments to item flags (is_vegan, is_popular, is_new) and category sort order were made to suit the Passover menu content.

---

## Current state (as of Apr 2025)

- Admin CRUD for: Orders, Customers, Items, Menus, Categories, Products
- Public menu display at `/`
- Passover menu at `/passover_menu`
- Order lifecycle managed via AASM state transitions
- Dashboard with cached analytics
- Basic model specs; integration/controller specs not yet written
- No CI/CD pipeline
- Docker setup exists for production deployment

---

## Planned next

- **Grocery list generation** — `DashboardController#generate_grocery_list` route exists but is not implemented. It should aggregate `Recipe` quantities across confirmed/preparing orders to produce a shopping list.
- **Expand test coverage** — Add controller specs and integration tests to reach the 90% SimpleCov threshold across the full app (currently only model layer is tested).
- **CI/CD** — Set up GitHub Actions to run RSpec and enforce coverage on PRs.
- **Order notifications** — Notify the owner (SMS or email) when a new order is placed, if the system moves toward customer self-ordering.
- **Authorization** — Currently all authenticated users are full admins. If multiple staff members are added, role-based access would be needed.
