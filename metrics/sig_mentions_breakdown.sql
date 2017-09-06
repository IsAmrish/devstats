select
  substring(sig from 13) as sig,
  count(*) as count_value
from
  (
    select substring(
          -- body from '(?:^|\s)+(@kubernetes/sig-[\w\d-]+)(?:-bug|-feature-request|-pr-review|-api-review|-misc|-proposal|-design-proposal|-test-failure)s?(?:$|[^\w\d-]+)'
          -- body from '(?:^|\s)+(?:@kubernetes/sig-[\w\d-]+)(-bug|-feature-request|-pr-review|-api-review|-misc|-proposal|-design-proposal|-test-failure)s?(?:$|[^\w\d-]+)'
          body from '(?:^|\s)+((?:@kubernetes/sig-[\w\d-]+)(?:-bug|-feature-request|-pr-review|-api-review|-misc|-proposal|-design-proposal|-test-failure))s?(?:$|[^\w\d-]+)'
        ) as sig
    from
      gha_texts
    where
      created_at >= '{{from}}'
      and created_at < '{{to}}'
  ) sel
where
  sel.sig is not null
group by
  sel.sig
order by
  count_value desc,
  sel.sig asc;