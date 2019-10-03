create procedure "My_Test_Procedure"
as
begin
  update or insert into help_items (item_id, item_parent_id, item_title, item_title_ru, item_order, item_create_date,
                                    item_modify_date, item_type, item_file_name, item_need_modify)
  values (2, 1, 'Tools', null, 700, '2001-12-01 01:19:47', '2002-05-05 20:09:10', 1, 'IB Expert\Tools\Index.html', 1)
  matching (item_id);

  insert into adressen ("AdrTyp", "AdrNr", "Kuerzel", "Name1", "Name2", "Name3", "Name4", "Name5", "Strasse", "Plz",
                        "Ort", "PfPlz", "Postfach", "AnredeNr", "Telefon", "Telefax", "AutoTel", "Geburtstag",
                        "NationNr", "AdrArtNr", "Nummer", "TelefonNr", "Bank", "Konto", blz, "SkontoSatz", "SkontoTage",
                        "NettoTage", "Mahnsperre", "Liefersperre", "Euro", "AnzahlDrucke", "UstIdNr", "KundenNr",
                        "Aenderung", "AenderungNr", "Bearbeiternr", "Info", "Verteilerliste", "Boersenmitgliedsnummer",
                        "Ilnsender", "Ilnempfaenger", "Wildcard", "X400Matchcode", "Betreff", "RabattGP", "RabattVO",
                        "Valutatage", "Rabatt", "Preiskz", "Preisst", "MwStKz", "DrPfl", "Email", "HomePage",
                        "Schutzgebiet", "PflPass", "Sammeldruck", "PreiseAufLiefsch", "Kundeseit", "Kredit",
                        "Kreditvers", "TextInfo", "Referenz", "Pflege", "Pflegeseit", "Pflegegekuendigt",
                        "BdBMitgliedsnummer", "Bauleiter", "ZahlungsArt", "Bild", "Brief", "UstFreiBis", "SteuerNr",
                        "Bauleistender", "Aufbewahrung", bic, iban, "Niederlassung", "Konzern", "Region", "Bundesland")
  values (:"varpAdrTyp", :"varpAdrNr", :"varpKuerzel", :"varpName1", :"varpName2", :"varpName3", :"varpName4",
          :"varpName5", :"varpStrasse", :"varpPlz", :"varpOrt", :"varpPfPlz", :"varpPostfach", :"varpAnredeNr",
          :"varpTelefon", :"varpTelefax", :"varpAutoTel", :"varpGeburtstag", :"varpNationNr", :"varpAdrArtNr",
          :"varpNummer", :"varpTelefonNr", :"varpBank", :"varpKonto", :varpblz, :"varpSkontoSatz", :"varpSkontoTage",
          :"varpNettoTage", :"varpMahnsperre", :"varpLiefersperre", :"varpEuro", :"varpAnzahlDrucke", :"varpUstIdNr",
          :"varpKundenNr", :"varpAenderung", :"varpAenderungNr", :"varpBearbeiternr", :"varpInfo",
          :"varpVerteilerliste", :"varpBoersenmitgliedsnummer", :"varpIlnsender", :"varpIlnempfaenger", :"varpWildcard",
          :"varpX400Matchcode", :"varpBetreff", :"varpRabattGP", :"varpRabattVO", :"varpValutatage", :"varpRabatt",
          :"varpPreiskz", :"varpPreisst", :"varpMwStKz", :"varpDrPfl", :"varpEmail", :"varpHomePage",
          :"varpSchutzgebiet", :"varpPflPass", :"varpSammeldruck", :"varpPreiseAufLiefsch", :"varpKundeseit",
          :"varpKredit", :"varpKreditvers", :"varpTextInfo", :"varpReferenz", :"varpPflege", :"varpPflegeseit",
          :"varpPflegegekuendigt", :"varpBdBMitgliedsnummer", :"varpBauleiter", :"varpZahlungsArt", :"varpBild",
          :"varpBrief", :"varpUstFreiBis", :"varpSteuerNr", :"varpBauleistender", :"varpAufbewahrung", :varpbic,
          :varpiban, :"varpNiederlassung", :"varpKonzern", :"varpRegion", :"varpBundesland")
  returning ("AdrTyp", "AdrNr", "Kuerzel", "Name1", "Name2", "Name3", "Name4", "Name5", "Strasse", "Plz", "Ort",
             "PfPlz", "Postfach", "AnredeNr", "Telefon", "Telefax", "AutoTel", "Geburtstag", "NationNr", "AdrArtNr",
             "Nummer", "TelefonNr", "Bank", "Konto", blz, "SkontoSatz", "SkontoTage", "NettoTage", "Mahnsperre",
             "Liefersperre", "Euro", "AnzahlDrucke", "UstIdNr", "KundenNr", "Aenderung", "AenderungNr", "Bearbeiternr",
             "Info", "Verteilerliste", "Boersenmitgliedsnummer", "Ilnsender", "Ilnempfaenger", "Wildcard",
             "X400Matchcode", "Betreff", "RabattGP", "RabattVO", "Valutatage", "Rabatt", "Preiskz", "Preisst", "MwStKz",
             "DrPfl", "Email", "HomePage", "Schutzgebiet", "PflPass", "Sammeldruck", "PreiseAufLiefsch", "Kundeseit",
             "Kredit", "Kreditvers", "TextInfo", "Referenz", "Pflege", "Pflegeseit", "Pflegegekuendigt",
             "BdBMitgliedsnummer", "Bauleiter", "ZahlungsArt", "Bild", "Brief", "UstFreiBis", "SteuerNr",
             "Bauleistender", "Aufbewahrung", bic, iban, "Niederlassung", "Konzern", "Region", "Bundesland")
  into :"varpAdrTyp", :"varpAdrNr", :"varpKuerzel", :"varpName1", :"varpName2", :"varpName3", :"varpName4",
       :"varpName5", :"varpStrasse", :"varpPlz", :"varpOrt", :"varpPfPlz", :"varpPostfach", :"varpAnredeNr",
       :"varpTelefon", :"varpTelefax", :"varpAutoTel", :"varpGeburtstag", :"varpNationNr", :"varpAdrArtNr",
       :"varpNummer", :"varpTelefonNr", :"varpBank", :"varpKonto", :varpblz, :"varpSkontoSatz", :"varpSkontoTage",
       :"varpNettoTage", :"varpMahnsperre", :"varpLiefersperre", :"varpEuro", :"varpAnzahlDrucke", :"varpUstIdNr",
       :"varpKundenNr", :"varpAenderung", :"varpAenderungNr", :"varpBearbeiternr", :"varpInfo", :"varpVerteilerliste",
       :"varpBoersenmitgliedsnummer", :"varpIlnsender", :"varpIlnempfaenger", :"varpWildcard", :"varpX400Matchcode",
       :"varpBetreff", :"varpRabattGP", :"varpRabattVO", :"varpValutatage", :"varpRabatt", :"varpPreiskz",
       :"varpPreisst", :"varpMwStKz", :"varpDrPfl", :"varpEmail", :"varpHomePage", :"varpSchutzgebiet", :"varpPflPass",
       :"varpSammeldruck", :"varpPreiseAufLiefsch", :"varpKundeseit", :"varpKredit", :"varpKreditvers", :"varpTextInfo",
       :"varpReferenz", :"varpPflege", :"varpPflegeseit", :"varpPflegegekuendigt", :"varpBdBMitgliedsnummer",
       :"varpBauleiter", :"varpZahlungsArt", :"varpBild", :"varpBrief", :"varpUstFreiBis", :"varpSteuerNr",
       :"varpBauleistender", :"varpAufbewahrung", :varpbic, :varpiban, :"varpNiederlassung", :"varpKonzern",
       :"varpRegion", :"varpBundesland";
end