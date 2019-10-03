begin
  update help_items
     set item_parent_id = :varpitem_parent_id,
         item_title = :varpitem_title,
         item_title_ru = :varpitem_title_ru,
         item_order = :varpitem_order,
         item_data = :varpitem_data,
         item_data_ru = :varpitem_data_ru,
         item_create_date = :varpitem_create_date,
         item_modify_date = :varpitem_modify_date,
         item_type = :varpitem_type,
         item_file_name = :varpitem_file_name,
         item_need_modify = :varpitem_need_modify
   where (item_id = :varpitem_id) or (item_id in (41111, 78792, 4362, 61494, 283, 29265, 53254, 47214, 16703, 47096,
                                                  1922, 64105, 4281, 51287, 55365, 64736, 62973, 27398, 19081, 57876,
                                                  49605, 908, 44010, 21513, 58723, 20324, 54624, 78925, 3026, 68127,
                                                  60327, 33428, 14429, 13032, 50833, 334, 82735, 638, 141, 2243,
                                                  14244, 57044, 3648, 66953, 2756, 46963, 264, 46365, 21469, 7169,
                                                  52772))
  returning (item_id, item_title)
  into :itemid, :itemtitle;
end
