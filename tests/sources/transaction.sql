begin
  open mycursor;
  fetch mycursor
  into :myvar1, :myvar2, :myvar3, :myvar4, :myvar5, :myvar6, :myvar7, :myvar8, :myvar9, :myvar10, :myvar11, :myvar12,
       :myvar13, :myvar14, :myvar15;
  close mycursor;

  when any do
  begin
    in autonomous transaction do
    begin
      insert into log(logdate, msg)
      values (current_timestamp, 'Wrong operation. ' || current_user);
    end
    exception wrong_oper;
  end

  when sqlcode -413, sqlcode -314, sqlcode -802 do
    yearmonth = null;
end
