extends Node

var portalArray : Array[PortalGridObject]
var blahPortalArray : Array[PortalBlahGridObject]

func _clear_portals():
	portalArray.clear()
	blahPortalArray.clear()

func _find_portal(p : PortalGridObject) -> PortalGridObject:
	for portal : PortalGridObject in portalArray:
		if is_instance_valid(portal) && p != portal:
			return portal
	return null

func _find_blah_portal(p : PortalBlahGridObject) -> PortalBlahGridObject:
	for portal : PortalBlahGridObject in blahPortalArray:
		if is_instance_valid(portal) && p != portal:
			return portal
	return null
