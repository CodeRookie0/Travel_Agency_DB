/*--------------------------------------------------------------------------------------
View Name: vw_package_details
--------------------------------------------------------------------------------------
Output Description:
- Id: The unique identifier of the package.
- Title: The title of the package.
- Description: The description of the package.
- Destination: The destination city of the package.
- HotelName: The name of the hotel included in the package.
- Duration: The duration of the package.
- Price: The price of the package.
- StartDate: The start date of the package.
- EndDate: The end date of the package.
- OutboundFlightId: The outbound flight ID included in the package.
- ReturnFlightId: The return flight ID included in the package.
- OutboundBusRouteId: The outbound bus route ID included in the package.
- ReturnBusRouteId: The return bus route ID included in the package.
- GuideId: The guide ID included in the package.
--------------------------------------------------------------------------------------
Example Invocation:

USE TRAVEL_AGENCY
GO
SELECT * FROM vw_package_details;
--------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO

CREATE OR ALTER VIEW vw_package_details AS
SELECT p.packId AS Id, p.packTitle AS Title, p.packDescription AS Description, c.cityName AS Destination, h.hotName AS HotelName, p.packDuration AS Duration, p.packPrice AS Price, p.packStartDate AS StartDate, p.packEndDate AS EndDate, ouf.fliId AS OutboundFlightId, rf.fliId AS ReturnFlightId, ob.busRouteId AS OutboundBusRouteId, rb.busRouteId AS ReturnBusRouteId, g.guideId AS GuideId
FROM tbl_package p
INNER JOIN tbl_city c ON p.packCityId = c.cityId
INNER JOIN tbl_hotel h ON p.packHotId = h.hotId
LEFT JOIN tbl_flight ouf ON p.packOutboundFlightId = ouf.fliId
LEFT JOIN tbl_flight rf ON p.packReturnFlightId = rf.fliId
LEFT JOIN tbl_busroute ob ON p.packOutboundBusRouteId = ob.busRouteId
LEFT JOIN tbl_busroute rb ON p.packReturnBusRouteId = rb.busRouteId
INNER JOIN tbl_guide g ON p.packGuideId = g.guideId;