-- ============================================================
-- SCRIPT GIẢ LẬP TRANH CHẤP DEADLOCK - T2
-- ============================================================
use VIET_SPORT
go

--Cài đặt mức độ cô lập thành repeatable read -> giữ khóa trên dữ liệu đến hết giao tác
SET TRANSACTION ISOLATION LEVEL Repeatable Read
go

create or alter proc ThayDoiSanDat @BKGID nvarchar(50), @cID nvarchar(50)
as
begin
	begin transaction
	update BOOKING_FORM
	set courtID = @cID
	where BookingID = @BKGID

	update INVOICE
	set CourtID = @cID
	where BookingID = @BKGID
	commit transaction
end
go
exec ThayDoiSanDat 'BKG00171', 'CEN001'

