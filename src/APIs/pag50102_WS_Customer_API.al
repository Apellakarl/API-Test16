page 50102 "DIR WS Customer API"
{
    APIGroup = 'APIs';
    APIPublisher = 'DIrectionsEMEA';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    DelayedInsert = true;
    EntityName = 'WSCustomers';
    EntitySetName = 'WSCustomers';
    ODataKeyFields = Id;
    PageType = API;
    SourceTable = Customer;
    UsageCategory = Administration;


    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No"; "No.")
                {
                    ApplicationArea = All;

                }
                field(Name; Name)
                {
                    ApplicationArea = All;

                }
                field(DateFilter; "Date Filter")
                {
                    ApplicationArea = All;

                }
                field(SalesLCY; "Sales (LCY)")
                {
                    ApplicationArea = All;

                }
            }
        }
    }

}