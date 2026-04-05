# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Sultana is a Rails 7.1 app for managing a home-cooking business. It has two faces:
- **Public:** displays the currently active menu (`/`, `/passover_menu`)
- **Admin (authenticated):** full CRUD for orders, customers, items, menus, categories, products, plus a dashboard

Ruby 3.2.2, Rails 7.1.4, PostgreSQL, TailwindCSS (importmap, no Node build step).

## Commands

```bash
./bin/dev                         # Start dev server (Rails + TailwindCSS watcher via Foreman)
bundle exec rspec                 # Run all tests
bundle exec rspec spec/models/    # Run a specific directory
bundle exec rspec spec/models/customer_spec.rb:10  # Run a single test
rails db:migrate                  # Run pending migrations
rails db:reset                    # Drop, create, migrate
rails console                     # Rails REPL
```

TailwindCSS is compiled via `bin/rails tailwindcss:watch` (started automatically by `bin/dev`). There is no `package.json` — JS dependencies use importmap.

## Architecture

### ResourceController pattern

`ResourceController` is the base class for almost every admin controller. It infers the model class and resource name from the controller name (e.g. `ItemsController` → `Item`). It provides standard CRUD actions that render Turbo Stream responses for modal-based interactions, with HTML fallbacks. All controllers in the admin area inherit from it unless they need custom behaviour.

`trusted_params` delegates permitted attributes to `resource_class.table_attributes`, defined in each model.

### ResourceAttributes concern

Models include `ResourceAttributes` to declare:
- `table_attributes` — columns shown in the index table and used for strong params
- `show_attributes` — fields shown in the detail modal
- `associated_collections` — related records displayed in the show modal

### Views / Turbo

All CRUD UI uses shared partials in `app/views/shared/`:
- `_resource_index` / `_resource_table` — index page and the table inside it
- `_new_modal` / `_edit_modal` / `_show_modal` — modal wrappers
- `_modal` — empty modal (used by Turbo to close a modal after success)
- `_flash` — flash messages injected via Turbo Stream

Turbo Stream responses prepend/replace these DOM targets. The modal pattern: open → Turbo replaces `modal_backdrop` with the form partial → submit → Turbo clears the modal and refreshes the table.

### Order lifecycle

Orders use AASM for state transitions: `pending → confirmed → preparing → ready → delivered → paid` (or `cancelled` from most states). Each transition has a corresponding member route (`POST /orders/:id/confirm`, etc.) handled in `OrdersController`.

### Menu display

Only one `Menu` can have `currently_displayed: true` at a time. `Menu#menu_items_for_display` returns items grouped by category in sort order. The public root renders this; the JSON format is consumed externally.

### Caching

`CacheableQueries` (concern included in models) provides `cached_find`, `cached_count`, `cached_where` with a 1-hour Rails cache expiry. `Order` clears its cache via `after_commit :clear_cache`. Used in `DashboardController` for analytics metrics.

## Testing

- RSpec with FactoryBot, Faker, Shoulda Matchers, DatabaseCleaner
- SimpleCov enforces ≥ 90% coverage
- Factories live in `spec/factories/`
- Model specs in `spec/models/`

## Key conventions

- Always consider N+1 queries when adding associations to index views — use `includes` or scopes like `with_prices`
- State transitions on Order must go through AASM events, not direct attribute assignment
- When a new model is added, include `ResourceAttributes` and define `table_attributes`, `show_attributes`, `index_order`, and `associated_collections`
- Okham's razor: prefer the simplest solution that works
