CREATE PROCEDURE procReissueInvoice @invoiceId INT
AS

DECLARE @VendorId INT, @InvoiceNumber VARCHAR(50), @InvoiceTotal MONEY, @PaymentTotal MONEY, @CreditTotal MONEY, @TermsId INT, @InvoiceDueDate SMALLDATETIME, @PaymentDate SMALLDATETIME;
DECLARE @InvoiceExistsCount INT;

SET @InvoiceExistsCount = (SELECT COUNT(*) FROM DBO.Invoices WHERE InvoiceID = @invoiceId);

BEGIN TRY

	BEGIN TRAN MyTransaction	
		
		IF @InvoiceExistsCount <= 0
			THROW 50001, 'No invoice with that id!', 1;

		SET @VendorId = (SELECT VendorId FROM dbo.Invoices WHERE InvoiceID = @invoiceId);
		SET @InvoiceNumber = (SELECT InvoiceNumber FROM dbo.Invoices WHERE InvoiceID = @invoiceId);
		SET @InvoiceTotal = (SELECT InvoiceTotal FROM dbo.Invoices WHERE InvoiceID = @invoiceId);
		SET @PaymentTotal = (SELECT PaymentTotal FROM dbo.Invoices WHERE InvoiceID = @invoiceId);
		SET @CreditTotal = (SELECT CreditTotal FROM dbo.Invoices WHERE InvoiceID = @invoiceId);
		SET @TermsId = (SELECT TermsID FROM dbo.Invoices WHERE InvoiceID = @invoiceId);
		SET @PaymentDate = (SELECT PaymentDate FROM dbo.Invoices WHERE InvoiceID = @invoiceId); 
		SET @InvoiceDueDate = dateadd(dd,360,getdate());


		INSERT INTO dbo.Invoices (VendorID, InvoiceNumber, InvoiceDate, InvoiceTotal, PaymentTotal, CreditTotal, TermsID, InvoiceDueDate, PaymentDate)
		VALUES (@VendorId, @InvoiceNumber, GETDATE(), @InvoiceTotal, @PaymentTotal, @CreditTotal, @TermsId, @InvoiceDueDate, @PaymentDate);

		PRINT 'Identity set to ' + CAST(@@IDENTITY AS VARCHAR);
		PRINT 'OldInvoiceId is ' + CAST(@invoiceId AS VARCHAR);

		UPDATE dbo.InvoiceLineItems
		SET InvoiceID = CAST(@@IDENTITY AS INT)
		WHERE InvoiceID = @invoiceId;

		DELETE FROM dbo.Invoices WHERE InvoiceID = @invoiceId;
		COMMIT TRAN;

END TRY

BEGIN CATCH
	ROLLBACK TRAN MyTransaction;
	PRINT 'ERROR ' + CONVERT(VARCHAR, ERROR_NUMBER(),1) + ' : ' + ERROR_MESSAGE();
END CATCH