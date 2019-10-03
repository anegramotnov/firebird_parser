begin
  merge into temp_collect t1
  using (select distinct t.ter_id, t.right_id, t.start_date, t.end_date, t.is_exclusive, t.contract_id, t.is_fake,
                         t.lang_id, t.release_id, t.client_id, t.is_agent, t.bd, t.asd, t.aed, t.agent_end_date
           from (select t.ter_id, t.right_id, t.start_date, t.end_date, t.is_exclusive, l.contract_id, t.is_fake,
                        t.lang_id, t.release_id, t.client_id, t.is_agent, t.bd, t.asd, t.aed, t.agent_end_date
                   from temp_rights t
                        inner join licenses l on l.license_id = t.license_id
                        left outer join temp_rights_temp tt on tt.ter_id = t.ter_id
                              and tt.right_id = t.right_id
                              and tt.lang_id = t.lang_id
                              and tt.contract_type_id = 2
                              and (t.client_id = tt.client_id or t.client_id is null)
                  where t.film_id = :fid
                    and t.contract_type_id = 1
                    and ((t.is_exclusive = 1) or (:is_exclusive in (0, 2)))
                    and tt.session_id is null
                 union all
                 select distinct t.ter_id, t.right_id, t.start_date, t.end_date, t.is_exclusive, l.contract_id,
                                 t.is_fake, t.lang_id, t.release_id, t.client_id, t.is_agent, t.bd, t.asd, t.aed,
                                 t.agent_end_date
                   from temp_rights_temp t
                        inner join licenses l on l.license_id = t.license_id
                        inner join temp_rights_temp tt on tt.film_id = t.film_id
                              and tt.ter_id = t.ter_id
                              and tt.right_id = t.right_id
                              and tt.lang_id = t.lang_id
                              and tt.contract_type_id = 2
                              and (t.client_id = tt.client_id or t.client_id is null)
                  where t.film_id = :fid
                    and t.contract_type_id = 1
                    and ((t.is_exclusive = 1) or (:is_exclusive in (0, 2)))) t) as t
  on t.ter_id = t1.ter_id and
     t1.right_id = t.right_id and
     ((t.start_date <= iif(t1.is_agent = 1, t1.aed, t1.end_date) and
     iif(t.is_agent = 1, t.aed, t.end_date) >= t1.start_date) or (t1.start_date <= iif(t.is_agent = 1, t.aed, t.end_date) and
     iif(t1.is_agent = 1, t1.aed, t1.end_date) >= t.start_date)) and
     (t1.contract_id = t.contract_id) and
     t1.is_exclusive = t.is_exclusive and
     t1.is_fake = t.is_fake and
     t.lang_id = t1.lang_id and
     (z(t1.client_id) = z(t.client_id)) and
     t.release_id = t1.release_id and
     t.is_agent = t1.is_agent and
     t.bd = t1.bd
  when matched then
      update set start_date = iif(t1.start_date < t.start_date, t1.start_date, t.start_date),
                 end_date = iif(iif(t1.is_agent = 1, t1.aed, t1.end_date) < iif(t.is_agent = 1, t.aed, t.end_date), iif(t.is_agent = 1, t.aed, t.end_date), iif(t1.is_agent = 1, t1.aed, t1.end_date))
  when not matched then
      insert (start_date, end_date, ter_id, right_id, is_exclusive, step, contract_id, is_fake, lang_id, release_id,
              client_id, is_agent, asd, aed, bd, agent_end_date)
      values (t.start_date, iif(t.is_agent = 1 and t.end_date is null, t.aed, t.end_date), t.ter_id, t.right_id,
              t.is_exclusive, 1, iif(:add_contract = 1, t.contract_id, 0), t.is_fake, t.lang_id, t.release_id,
              t.client_id, t.is_agent, t.asd, t.aed, t.bd, t.agent_end_date);

end
