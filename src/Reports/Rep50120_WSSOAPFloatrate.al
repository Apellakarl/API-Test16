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
    begin
        Url := 'http://www.floatrates.com/daily/dkk.xml';

        Httpclient.Get(Url, HttpResponse);
        with HttpResponse do begin
            if not IsSuccessStatusCode then
                Error('Not working - the error was:\\Status Code:%1\\Error %2',
                HttpStatusCode, ReasonPhrase);
            Content.ReadAs(XMLtext);
        end;

        Error('Reslunt %1', XMLtext);

    end;
}