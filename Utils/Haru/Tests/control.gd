extends Control

var s = HaruServer.new()
var c = HaruProxy.new()

var tr = Thread.new()

func _ready() -> void:
	s.listen(8081)
	s.sceneTree = get_tree()
	
	c.create("127.0.0.1", 8081)
	c.handshack.lossSim = true
	c.handshack.readPacketCallback = func(channel : HaruHandshack.PacketChannel, packet : PackedByteArray, sequence : int):
		if channel == HaruHandshack.PacketChannel.Reliable:
			print("[Client] %s" % packet.get_string_from_utf8())
		else:
			print("[Client] F(%s)" % packet.get_string_from_utf8())
	c.handshack.sceneTree = get_tree()
	
	for i in range(5):
		c.handshack.SendPacket(("%s" % i).to_utf8_buffer())

func _process(delta: float) -> void:
	s.poll()
	c.poll()

func _exit_tree() -> void:
	c.socket.close()
	s.socket.stop()
