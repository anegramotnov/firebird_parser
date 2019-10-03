begin

  delete from help_items
   where (item_id = :varpitem_id);

  begin
    delete from help_items
     where (item_id = :varpitem_id)
    returning (parent_id, item_name, item_date, item_state)
    into :vparentid, :vname, :vdate, :vstate;
  end
end