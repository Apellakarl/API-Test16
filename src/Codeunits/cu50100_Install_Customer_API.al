codeunit 50100 "DIR Install API Test"
{
    Subtype = Install;
    trigger OnInstallAppPerCompany()
    var
        WebSrviceManagement: Codeunit "Web Service Management";
        ObjectType: Option "TableData","Table",,"Report",,"Codeunit","XMLport","MenuSuite","Page","Query","System","FieldNumber";
    begin
        WebSrviceManagement.CreateTenantWebService(ObjectType::Page, page::"DIR WS Customer SOAP", 'WSCUstomerSOAP', true);
        WebSrviceManagement.CreateTenantWebService(ObjectType::Page, page::"DIR WS Customer Odata", 'WSCUstomerOdata', true);
        WebSrviceManagement.CreateTenantWebService(ObjectType::Page, page::"DIR WS Customer API", 'WSCUstomerAPI', true);
    end;

}