begin
  for with assets
   as (select l.f_ak_id, sum(f_al_amount) as f_amount
         from o_asset_line_active l
        where (l.f_as_expiry >= current_date)
          and (l.f_cu_id = :in_cu_id)
        group by l.f_ak_id)
   select assets.f_ak_id, coalesce(ak.f_ak_short, ' ' || ak.f_ak_descr) as f_ak_descr, assets.f_amount
     from assets
          inner join t_asset_kind ak on ak.f_ak_id = assets.f_ak_id
    where assets.f_amount <> 0
      and ak.f_ak_active = 1
      and ((:in_ak_kind is null) or (ak.f_ak_kind = :in_ak_kind))
     into :out_ak_id, :out_ak_descr, :out_ak_amount
  do
    suspend;
end
