CREATE PROCEDURE fnCountVendorInvoices @SearchVendorId INT
AS

DECLARE @Result INT;
DECLARE @VendorExistsCount INT;
DECLARE @VendorExistsBoolean BIT = 0;

BEGIN TRY

	SET @VendorExistsCount = (SELECT COUNT(*) FROM DBO.Vendors WHERE VendorID = @SearchVendorId);

	IF(@VendorExistsCount > 0)
		SET @VendorExistsBoolean = 1;

	EXEC @Result = dbo.fnCountVendorInvoices 
	@VendorId  = @SearchVendorId;

	IF(@Result > 0)
		PRINT CAST(@Result AS VARCHAR) + ' Invoices.';

	ELSE IF(@VendorExistsBoolean = 1)
		PRINT 'No Invoices!';
	
	ELSE
		THROW 50001, 'Vendor not found', 1;

END TRY

BEGIN CATCH
	PRINT 'ERROR ' + CONVERT(VARCHAR, ERROR_NUMBER(),1) + ' : ' + ERROR_MESSAGE();
END CATCH