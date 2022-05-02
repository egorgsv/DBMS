SELECT
*
from stops_at
WHERE station_id = 8 AND route_id < 3;

SELECT
/*+ FULL(stops_at) */
*
from stops_at
WHERE station_id = 8 AND route_id < 3;

SELECT
/*+ INDEX(stops_at stops_at_station_idx) */
*
from stops_at
WHERE station_id = 8 AND route_id < 3;

SELECT
/*+ INDEX_COMBINE(stops_at stops_at_station_idx, stops_at_route_idx) */
*
from stops_at
WHERE station_id = 8 AND route_id < 3;
