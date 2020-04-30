page 50102 "DIR WS Customer API"
{
    PageType = API;
    APIPublisher = 'DIrectionsEMEA';
    APIGroup = 'APIs';
    APIVersion = 'v1.0';
    EntityName = 'WSCustomers';
    EntitySetName = 'WSCustomers';
    ApplicationArea = All;
    UsageCategory = Administration;
    DelayedInsert = true;
    ODataKeyFields = Id;
    SourceTable = Customer;


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