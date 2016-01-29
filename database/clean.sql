select e.*
from image e
join _state s on s.id = e.id_state
where s.id_terminated is not null;

select e.*
from item e
join _state s on s.id = e.id_state
where s.id_terminated is not null;

select e.*
from itemset e
join _state s on s.id = e.id_state
where s.id_terminated is not null;

select e.*
from site e
join _state s on s.id = e.id_state
where s.id_terminated is not null;

select e.*
from settings_a e
join _state s on s.id = e.id_state
where s.id_terminated is not null;

select e.*
from settings_b e
join _state s on s.id = e.id_state
where s.id_terminated is not null;

select e.*
from settings_c e
join _state s on s.id = e.id_state
where s.id_terminated is not null;

select s.*
from _state s
where s.id_terminated is not null;

select a.*
from _audit a
where true
  and a.id not in(select id_created from _state)
  and a.id not in(select id_published from _state)
  and a.id not in(select id_terminated from _state);