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
end
