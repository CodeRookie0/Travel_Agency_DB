--This script creates indexes on various columns in the "Travel Agency" database tables.

CREATE INDEX idx_continent_contName ON tbl_continent (contName);

CREATE INDEX idx_country_contId ON tbl_country (contId);
CREATE INDEX idx_country_ctryName ON tbl_country (ctryName);

CREATE INDEX idx_city_ctryId ON tbl_city (ctryId);

CREATE INDEX idx_address_addrCityId ON tbl_address (addrCityId);

CREATE INDEX idx_customer_custAddrId ON tbl_customer (custAddrId);

CREATE INDEX idx_guide_guideCityId ON tbl_guide (guideCityId);

CREATE INDEX idx_hotel_hotAddrId ON tbl_hotel (hotAddrId);

CREATE INDEX idx_flight_fliStartCityId ON tbl_flight (fliStartCityId);
CREATE INDEX idx_flight_fliEndCityId ON tbl_flight (fliEndCityId);
CREATE INDEX idx_flight_fliStartTime ON tbl_flight (fliStartTime);
CREATE INDEX idx_flight_fliEndTime ON tbl_flight (fliEndTime);

CREATE INDEX idx_busRoute_busRouteStartCity ON tbl_busroute (busRouteStartCityId);
CREATE INDEX idx_busRoute_busRouteEndCity ON tbl_busroute (busRouteEndCityId);
CREATE INDEX idx_busRoute_busRouteStartTime ON tbl_busroute (busRouteStartTime);
CREATE INDEX idx_busRoute_busRouteEndTime ON tbl_busroute (busRouteEndTime);

CREATE INDEX idx_package_packOutboundFlightId ON tbl_package (packOutboundFlightId);
CREATE INDEX idx_package_packReturnFlightId ON tbl_package (packReturnFlightId);
CREATE INDEX idx_package_packOutboundBusRouteId ON tbl_package (packOutboundBusRouteId);
CREATE INDEX idx_package_packReturnBusRouteId ON tbl_package (packReturnBusRouteId);

CREATE INDEX idx_booking_bookCustId ON tbl_booking (bookCustId);
CREATE INDEX idx_booking_bookPackageId ON tbl_booking (bookPackageId);
CREATE INDEX idx_booking_bookDiscountPercent ON tbl_booking (bookDiscountPercent);
CREATE INDEX idx_booking_bookDiscountAmnt ON tbl_booking (bookDiscountAmnt);
CREATE INDEX idx_booking_bookPrice ON tbl_booking (bookPrice);