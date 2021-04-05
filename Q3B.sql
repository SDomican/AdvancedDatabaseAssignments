CREATE FUNCTION dbo.fnCountVendorInvoices (@VendorId INT)
RETURNS INT AS
BEGIN

	DECLARE @Return_Value INT;

	SET @Return_Value = (SELECT Count(VendorId) AS 'No. of Invoices'  FROM dbo.Invoices WHERE VendorID = @VendorId GROUP BY VendorId);

	RETURN @Return_Value;
END;

