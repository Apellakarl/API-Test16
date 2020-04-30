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
        Jsontext: Text;
    begin
        Url := 'http://www.floatrates.com/daily/dkk.json';

        Httpclient.Get(Url, HttpResponse);
        with HttpResponse do begin
            if not IsSuccessStatusCode then
                Error('Not working - the error was:\\Status Code:%1\\Error %2',
                HttpStatusCode, ReasonPhrase);
            Content.ReadAs(Jsontext);
        end;

        Error('Result %1', Jsontext);

    end;
}