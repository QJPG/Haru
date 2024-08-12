extends RefCounted

class_name HaruServer

var socket : UDPServer
var proxys : Array[HaruProxy]

var sceneTree : SceneTree

func listen(port : int) -> void:
	socket = UDPServer.new()
	socket.listen(port)

func poll() -> void:
	socket.poll()
	
	if socket.is_connection_available():
		var proxy = HaruProxy.new()
		proxy.socket = socket.take_connection()
		proxy.handshack.readPacketCallback = func(channel : HaruHandshack.PacketChannel, packet : PackedByteArray, sequence : int):
			proxy.handshack.SendData("unr1".to_utf8_buffer())
			proxy.handshack.SendData("unr2".to_utf8_buffer())
			proxy.handshack.SendData("unr3".to_utf8_buffer())
			
			print("[Server] %s" % packet.get_string_from_utf8())
		proxy.handshack.sceneTree = sceneTree
		proxy.handshack.lossSim = true
		proxys.append(proxy)
	
	for proxy in proxys:
		proxy.poll()
