--This script adds constraints to tables

ALTER TABLE tbl_hotel
ADD CONSTRAINT chk_hotel_hotPricePerNight CHECK (hotPricePerNight >= 0);

ALTER TABLE tbl_customer
ADD CONSTRAINT chk_customer_custEmailAddress CHECK (custEmailAddress LIKE '%@%.%');

ALTER TABLE tbl_hotel
ADD CONSTRAINT chk_hotel_hotContactEmail CHECK (hotContactEmail LIKE '%@%.%');

ALTER TABLE tbl_flight
ADD CONSTRAINT chk_flight_fliPrice CHECK (fliPrice > 0);

ALTER TABLE tbl_busroute
ADD CONSTRAINT chk_busroute_busRoutePrice CHECK (busRoutePrice > 0);

ALTER TABLE tbl_package
ADD CONSTRAINT chk_package_packPrice CHECK (packPrice > 0);

ALTER TABLE tbl_package
ADD CONSTRAINT chk_package_packMinCapacity CHECK (packMinCapacity > 0);

ALTER TABLE tbl_package
ADD CONSTRAINT chk_package_packMaxCapacity CHECK (packMaxCapacity > 5);

ALTER TABLE tbl_package
ADD CONSTRAINT chk_package_packCurrentBookings CHECK (packCurrentBookings >= 0 AND packCurrentBookings <= packMaxCapacity);

ALTER TABLE tbl_booking
ADD CONSTRAINT chk_booking_bookDiscountPercent CHECK (bookDiscountPercent >= 0);

ALTER TABLE tbl_booking
ADD CONSTRAINT chk_booking_bookDiscountAmnt CHECK (bookDiscountAmnt >= 0);

ALTER TABLE tbl_booking
ADD CONSTRAINT chk_booking_bookPrice CHECK (bookPrice > 0);