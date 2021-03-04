select distinct
    events.event_type,
    (select s.value from events s where s.event_type = last.event_type and s.time < last.time order by s.time desc limit 1) - (select s.value from events s where s.event_type = oldest.event_type and s.time = oldest.time)
from
    events
left join
    (
        select
            event_type, max(time) time
        from
            events
        group by event_type) last on last.event_type = events.event_type
left join        
    (
        select
            event_type, min(time) time
        from
            events
        group by event_type) oldest on oldest.event_type = events.event_type
left join        
    (
        select
            event_type, count(*) total
        from
            events
        group by event_type) total on total.event_type = events.event_type
where
    total.total > 1;
