begin
  merge into notif2get nc
  using (select orderid, userid, notifcnt
           from notif2get
          where orderid = :ordid) ny
  on (ny.orderid = nc.orderid)
  when matched then
      update set userid = :curuser,
                 notifcnt = coalesce(ny.notifcnt, 0) + 1
  when not matched then
      insert (orderid, userid, notifcnt)
      values (ny.orderid, :curuser, 1);
end