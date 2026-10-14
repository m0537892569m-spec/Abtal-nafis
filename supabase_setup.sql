-- Run once in Supabase SQL Editor. Review existing policies before running.
create table if not exists public.nafis_questions (
 id uuid primary key default gen_random_uuid(),
 grade text not null check (grade in ('third','sixth','middle')),
 subject text not null, skill text default '', question text not null,
 options jsonb not null, correct_answer integer not null check (correct_answer between 0 and 3),
 approved boolean not null default false, attachment_url text,
 created_at timestamptz not null default now()
);
alter table public.nafis_questions enable row level security;
drop policy if exists nafis_public_approved_read on public.nafis_questions;
create policy nafis_public_approved_read on public.nafis_questions for select to anon using (approved = true);
drop policy if exists nafis_teacher_read on public.nafis_questions;
create policy nafis_teacher_read on public.nafis_questions for select to authenticated using (true);
drop policy if exists nafis_teacher_insert on public.nafis_questions;
create policy nafis_teacher_insert on public.nafis_questions for insert to authenticated with check (true);
drop policy if exists nafis_teacher_update on public.nafis_questions;
create policy nafis_teacher_update on public.nafis_questions for update to authenticated using (true) with check (true);
drop policy if exists nafis_teacher_delete on public.nafis_questions;
create policy nafis_teacher_delete on public.nafis_questions for delete to authenticated using (true);
-- Optional attachments bucket. Private access rules should be configured separately.
