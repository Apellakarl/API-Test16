report 50121 "DIR WS REST Floatrate"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'WS REST FLoatrate';
    ProcessingOnly = true;

    trigger OnPreReport()
    var
        Httpclient: HttpClient;
        HttpResponse: HttpResponseMessage;
        Url: text;

    begin
        Url := 'http://www.floatrates.com/daily/dkk.json';

        Httpclient.Get(Url, HttpResponse);
        with HttpResponse do begin
            if not IsSuccessStatusCode then
                Error('Not working - the error was:\\Status Code:%1\\Error %2',
                HttpStatusCode, ReasonPhrase);
            Content.ReadAs(Jsontext);
        end;
        JsonText := '[' + JsonText + ']';

        if not jsonArray.ReadFrom(JsonText) then
            Error('Not a json object');
        foreach jsontoken in jsonarray do begin
            jsonObject := jsonToken.AsObject();
            if currency.FindSet() then
                repeat
                    InsertCurrencyRate(currency.Code);
                until currency.Next() = 0;
            if page.RunModal(0, currencyRate) = Action::Cancel then;

        end;
        //Error('Result %1', jsonobject);
        //Error('Result %1', jsontoken);
    end;
    //Error('Result %1', jsonArray);


    var
        JsonText: Text;
        jsonToken: JsonToken;
        jsonValue: JsonValue;
        jsonObject: JsonObject;
        jsonArray: JsonArray;
        currency: Record Currency;
        currencyRate: Record "Currency Exchange Rate" temporary;

    local procedure InsertCurrencyRate(CurrencyCode: Code[10])
    var
        TokenName: text[50];
        LowerCurrCode: Text[50];
        inverseRate: Decimal;
        textRate: Text;
    begin
        currencyRate.Init();
        LowerCurrCode := LowerCase(CurrencyCode);
        IF not jsonobject.get(LowerCurrCode, jsonToken) then
            exit;
        TokenName := '$.' + LowerCurrCode + '.code';
        currencyRate."Currency Code" := FORMAT(SelectJsonToken(jsonObject, TokenName));
        currencyRate."Exchange Rate Amount" := 100;
        TokenName := '$.' + LowerCurrCode + '.inverseRate';
        TextRate := FORMAT(SelectJsonToken(jsonObject, TokenName));
        textrate := ConvertStr(textRate, '.', ',');
        Evaluate(inverseRate, textRate);
        currencyRate."Relational Exch. Rate Amount" := inverseRate * 100;
        TokenName := '$.' + LowerCurrCode + '.date';
        currencyRate."Starting Date" := ConvertDate(format(SelectJsonToken(jsonObject, TokenName)));
        IF currencyRate.insert() then;

    end;

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

    procedure SelectJsonToken(JsonObject: JsonObject; Path: text) JsonToken: JsonToken
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then
            Error('Could not find a token with path %1', Path);
    end;
}