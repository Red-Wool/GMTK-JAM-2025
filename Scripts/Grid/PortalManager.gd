extends Node

var portalArray : Array[PortalGridObject]

func _clear_portals():
	portalArray.clear()

func _find_portal(p : PortalGridObject) -> PortalGridObject:
	for portal : PortalGridObject in portalArray:
		if p != portal:
			return portal
	return null
