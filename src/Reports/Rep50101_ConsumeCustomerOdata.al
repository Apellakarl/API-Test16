report 50101 "DIR WS REST Odata"
{
    ApplicationArea = All;
    Caption = 'WS REST Odata';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    trigger OnPreReport()
    var
        Httpclient: HttpClient;
        HttpContent: HttpContent;
        httpHeaders: HttpHeaders;
        HttpRequest: HttpRequestMessage;
        HttpResponse: HttpResponseMessage;
        PasswordText: Text;
        Url: text;
        UserID: Text;

    begin
        UserID := 'USER';
        PasswordText := 'Password!23';

        Url := 'http://navtraining:7047/BC160_Webservice/ODataV4/Company(''CRONUS%20International%20Ltd.'')/WSCUstomerSOAP';

        HttpRequest.SetRequestUri(Url);
        HttpRequest.Method('GET');
        HttpContent.GetHeaders(httpHeaders);

        HttpHeaders.Remove('Content-type');
        httpHeaders.Add('Content-type', 'Json');


    end;
    //Error('Result %1', jsonArray);


    var
        XMLText: Text;


}