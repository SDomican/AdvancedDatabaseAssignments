SELECT VendorId, Count(VendorId) AS 'No. of Invoices' From dbo.Invoices GROUP BY VendorId;