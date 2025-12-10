-- ============================================================
-- SCRIPT GIẢ LẬP TRANH CHẤP DEADLOCK - T1
-- ============================================================
use VIET_SPORT
go

--Cài đặt mức độ cô lập thành repeatable read -> giữ khóa trên dữ liệu đến hết giao tác
SET TRANSACTION ISOLATION LEVEL Repeatable Read
go

create or alter proc HuyDatSan @bookingform nvarchar(50), @cancellationID nvarchar(50)
as
begin
	begin transaction
	--Tạo đơn hủy sân
	insert CANCELLATION_FORM values (@cancellationID, GETDATE(), 0, 'Used', 'CRL001', @bookingform)
	--Thay đổi hóa đơn
	update INVOICE  
	set TotalPrice = (select PenaltyPrice from CANCELLATION_FORM where CancelFormID = @cancellationID), 
		CreateTime = GetDate(),
		DiscountID = NULL
	where BookingID = @bookingform
	--Chờ 10 giây (giả lập T2 chen vào đúng ngay giữa 2 hành động)
	print 'Chạy T2 đi!'
	waitfor delay '00:00:10'
	--Thay đổi đơn đặt sân
	update BOOKING_FORM
	set EndTime = GETDATE(),
		Status = 'Cancelled'
	where BookingID = @bookingform
	commit transaction
end
go

exec HuyDatSan 'BKG00171', 'CNF00009' 


