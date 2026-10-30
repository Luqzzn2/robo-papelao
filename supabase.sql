-- Cole tudo isto no Supabase: menu "SQL Editor" > New query > Run

create table if not exists public.avaliacoes (
  id          bigint generated always as identity primary key,
  nome        text     not null check (char_length(nome) between 1 and 60),
  nota        smallint not null check (nota between 1 and 5),
  comentario  text              check (comentario is null or char_length(comentario) <= 300),
  created_at  timestamptz not null default now()
);

-- Segurança: o site (chave pública) só pode LER e INSERIR. Não consegue editar nem apagar.
alter table public.avaliacoes enable row level security;

drop policy if exists "todos podem ver"    on public.avaliacoes;
drop policy if exists "todos podem avaliar" on public.avaliacoes;

create policy "todos podem ver"     on public.avaliacoes for select to anon, authenticated using (true);
create policy "todos podem avaliar" on public.avaliacoes for insert to anon, authenticated with check (true);

grant usage on schema public to anon, authenticated;
grant select, insert on public.avaliacoes to anon, authenticated;
