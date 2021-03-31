CREATE FUNCTION dbo.fnEarliestUnpaidDate (@VendorID INT)
RETURNS DATETIME AS
BEGIN

	DECLARE @Return_Value DATETIME;

	SET @Return_Value = (SELECT MIN(Invoices.InvoiceDate) FROM dbo.Invoices
	LEFT JOIN Vendors ON dbo.Invoices.VendorID = Vendors.VendorID
	WHERE Vendors.VendorID = @VendorID AND (Invoices.InvoiceTotal - Invoices.PaymentTotal) > 0);

RETURN @Return_Value;

END;