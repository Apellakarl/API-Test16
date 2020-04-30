report 50120 "DIR WS SOAP Floatrate"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'WS SOAP FLoatrate';
    ProcessingOnly = true;

    trigger OnPreReport()
    var
        Httpclient: HttpClient;
        HttpResponse: HttpResponseMessage;
        Url: text;
        XMLtext: Text;
        XmlReadOptions: XmlReadOptions;
        xmlDoc: XmlDocument;
        XmlNodeList: XmlNodeList;
        XmlNode: XmlNode;
        ExchrateAmt: Decimal;

    begin
        Url := 'http://www.floatrates.com/daily/dkk.xml';

        Httpclient.Get(Url, HttpResponse);
        with HttpResponse do begin
            if not IsSuccessStatusCode then
                Error('Not working - the error was:\\Status Code:%1\\Error %2',
                HttpStatusCode, ReasonPhrase);
            Content.ReadAs(XMLtext);
        end;

        XmlReadOptions.PreserveWhitespace := true;
        XmlDocument.ReadFrom(XMLtext, XmlReadOptions, xmlDoc);
        IF xmldoc.SelectNodes('//channel/item', XmlNodeList) then begin
            foreach xmlnode in xmlnodeList do begin
                if XmlNode.SelectSingleNode('pubDate', XmlNode) then
                    Currencyrate."Starting Date" := ConvertDate(XmlNode.AsXmlElement().InnerText);

                if XmlNode.SelectSingleNode('../targetCurrency', XmlNode) then
                    Currencyrate."Currency Code" := XmlNode.AsXmlElement().InnerText;

                if XmlNode.SelectSingleNode('../inverseRate', XmlNode) then
                    Evaluate(ExchrateAmt, XmlNode.AsXmlElement().InnerText);
                Currencyrate."Relational Exch. Rate Amount" := ExchrateAmt * 100;
                Currencyrate."Exchange Rate Amount" := 100;
                if Currencyrate.Insert() then;
                Currencyrate.Init();

            end;
            if Page.Runmodal(0, Currencyrate) = action::Cancel then;
            //Error('Result: %1', Currencyrate);
        end;

    end;

    var
        Currencyrate: Record "Currency Exchange Rate" temporary;

    local procedure ConvertDate(inDateTxt: Text[50]): Date;
    var
        DayTxt: Text[10];
        MonthTxt: Text[10];
        YearTxt: Text[10];
        DayNo: Integer;
        MonthNo: Integer;
        YearNo: Integer;
        DateTxt: Text[50];

    begin
        //date":"Thu, 27 Sep 2018 00:00:01
        DateTxt := copystr(inDateTxt, strpos(inDateTxt, ',') + 1);
        DateTxt := DelChr(DateTxt, '<', ' ');
        DayTxt := CopyStr(DateTxt, 1, StrPos(DateTxt, ' '));
        DateTxt := copystr(DateTxt, strpos(DateTxt, ' ') + 1);
        MonthTxt := CopyStr(DateTxt, 1, StrPos(DateTxt, ' '));
        DateTxt := copystr(DateTxt, strpos(DateTxt, ' ') + 1);
        YearTxt := CopyStr(DateTxt, 1, StrPos(DateTxt, ' '));
        evaluate(DayNo, DayTxt);
        evaluate(YearNo, YearTxt);
        case lowercase(delchr(MonthTxt, '=', ' ')) of
            'jan':
                MonthNo := 1;
            'feb':
                MonthNo := 2;
            'mar':
                MonthNo := 3;
            'apr':
                MonthNo := 4;
            'may':
                MonthNo := 5;
            'jun':
                MonthNo := 6;
            'jul':
                MonthNo := 7;
            'aug':
                MonthNo := 8;
            'sep':
                MonthNo := 9;
            'oct':
                MonthNo := 10;
            'nov':
                MonthNo := 11;
            'dec':
                MonthNo := 12;
        end;
        exit(DMY2Date(DayNo, MonthNo, YearNo));
    end;
}