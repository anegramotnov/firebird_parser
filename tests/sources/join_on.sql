begin
  select 1
    from rdb$database
   where exists(select 1
                  from temp_rights t
                       left outer join lang_to_ter lt on (lt.ter_id = t.ter_id)
                       inner join ter_relations tr on tr.p_id = t.ter_id
                             and tr.p_isparent_to_t = 1
                             and t.contract_type_id = 1
                       inner join rights_relation rr on rr.p_id = t.right_id
                             and rr.p_isparent_to_r = 1
                             and t.contract_type_id = 1
                       right outer join temp_rights tt on (tr.t_id = tt.ter_id)
                             and (rr.r_id = tt.right_id)
                             and t.contract_type_id = 1
                             and (t.film_id = tt.film_id)
                             and ((tt.start_date between t.start_date and t.end_date
                             and tt.end_date between t.start_date and t.end_date) or (t.bd = 1) or (tt.start_date >= t.start_date
                             and t.end_date is null) or (t.is_agent = 1
                             and tt.start_date between t.asd and t.aed))
                             and (t.is_exclusive = tt.is_exclusive or t.is_exclusive = 1)
                             and t.release_id = tt.release_id
                             and (z(t.client_id) = 0 or (tt.client_id = t.client_id))
                             and t.lang_id = iif(tt.lang_id = 1
                             and t.lang_id <> 1, lt.lang_id, tt.lang_id)
                 where tt.license_id = :lid
                   and tt.is_fake = 0
                   and t.session_id is null);

end
