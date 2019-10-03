create or alter procedure calc_num_port (
  num_port integer,
  num_mod  integer,
  id_dsl   integer)
returns (
  calc_port integer)
as
begin
  calc_port = case
                when (:id_dsl = 3) or (:id_dsl = 4) then num_mod * 100 + num_port
                when id_dsl = 5 then case
                                       when num_mod < 7 then num_mod * 100 + num_port
                                       else (:num_mod - 2) * 100 + num_port
                                     end
                when id_dsl = 8 then case
                                       when num_mod < 7 then 201334784 + num_port * 64 + (:num_mod - 1) * 8192
                                       else 201400320 + num_port * 64 + (:num_mod - 9) * 8192
                                     end
                else num_port
              end;
  suspend;
end
