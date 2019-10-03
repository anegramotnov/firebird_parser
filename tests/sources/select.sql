create or alter procedure mail_label (
  cust_no integer)
returns (
  line1 char(40),
  line2 char(40),
  line3 char(40),
  line4 char(40),
  line5 char(40),
  line6 char(40))
as
 declare variable customer   varchar(25);
 declare variable first_name varchar(15);
 declare variable last_name  varchar(20);
 declare variable addr1      varchar(30);
 declare variable addr2      varchar(30);
 declare variable city       varchar(25);
 declare variable state      varchar(15);
 declare variable country    varchar(15);
 declare variable postcode   varchar(12);
 declare variable cnt        integer;
 declare c_cursor   cursor for (
   select rdb$relation_id
     from rdb$database
    where rdb$security_class not in (select rdb$function_name
                                       from rdb$filters));
begin
  line1 = '';
  line2 = '';
  line3 = '';
  line4 = '';
  line5 = '';
  line6 = '';

  select first (10 + :cnt) skip 10 distinct customer, contact_first, contact_last, address_line1, address_line2, city,
                                            state_province, country, postal_code
    from customer
   where cust_no = :cust_no
   order by country, postal_code, customer
    into :customer, :first_name, :last_name, :addr1, :addr2, :city, :state, :country, :postcode;

  if (customer is not null) then
    line1 = customer;
  if (first_name is not null) then
    line2 = first_name || ' ' || last_name;
  else
    line2 = last_name;
  if (addr1 is not null) then
    line3 = addr1;
  if (addr2 is not null) then
    line4 = addr2;

  if (country = 'USA') then
  begin
    if (city is not null) then
      line5 = city || ', ' || state || '  ' || postcode;
    else
      line5 = state || '  ' || postcode;
  end
  else
  begin
    if (city is not null) then
      line5 = city || ', ' || state;
    else
      line5 = state;
    line6 = country || '    ' || postcode;
  end

  suspend;
end