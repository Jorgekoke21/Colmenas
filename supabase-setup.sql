-- Ejecuta este SQL en Supabase > SQL Editor.
-- Después crea en Authentication > Users el usuario que podrá pulsar Guardar.

create table if not exists public.varroa_public_state (
  id text primary key,
  payload jsonb not null,
  source_file text,
  updated_at timestamptz not null default now(),
  constraint varroa_public_state_singleton check (id = 'default')
);

alter table public.varroa_public_state enable row level security;

grant select on table public.varroa_public_state to anon, authenticated;
grant insert, update on table public.varroa_public_state to authenticated;

drop policy if exists "Public can read the published varroa state" on public.varroa_public_state;
create policy "Public can read the published varroa state"
  on public.varroa_public_state
  for select
  to anon, authenticated
  using (id = 'default');

drop policy if exists "Signed-in owner can publish the varroa state" on public.varroa_public_state;
create policy "Signed-in owner can publish the varroa state"
  on public.varroa_public_state
  for insert
  to authenticated
  with check (id = 'default');

drop policy if exists "Signed-in owner can update the varroa state" on public.varroa_public_state;
create policy "Signed-in owner can update the varroa state"
  on public.varroa_public_state
  for update
  to authenticated
  using (id = 'default')
  with check (id = 'default');
