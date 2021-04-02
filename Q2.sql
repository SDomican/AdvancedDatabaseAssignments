USE [S00209029]
GO

CREATE TRIGGER Archive_old_Terms 
ON dbo.Vendors
AFTER UPDATE
AS
	IF UPDATE (DefaultTermsId)
	BEGIN

		DECLARE @vendor_id INT, @old_termsID INT, @new_termsId INT, @change_date SMALLDATETIME; 

		SELECT
		@new_termsID = DefaultTermsID
		FROM INSERTED;

		SET @change_date = GETDATE();

		SELECT @old_termsID = DefaultTermsID, @vendor_id = VendorID 
		FROM deleted;


		INSERT INTO dbo.vendorsTermsArchive(vendorID, oldtermsID, newTermsID, changeDate)
		VALUES (@vendor_id, @old_termsID, @new_termsId, @change_date);


	END
GO