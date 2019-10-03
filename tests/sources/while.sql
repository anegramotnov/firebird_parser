begin
  i = 0;
  while (i < 1000) do
  begin
    suspend;
    i = i + 1;
  end

  execute procedure my_proc(:vardate, :varduration, 'abcd' || :varpostfix)
      returning_values :varstartdate, :varenddate, :varsomethingelse;

  s = 'drop domain mydomain';
  execute statement :s;

  for execute statement 'SELECT NAME FROM BREED'
       on external data source 'LOCALHOST:HORSES'
       with common transaction
       as user 'SYSDBA' password 'masterkey'
       with caller privileges
       into :name
  do
    suspend;

end
