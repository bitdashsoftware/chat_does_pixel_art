class_name ServerNode
extends Node

var server := UDPServer.new()
var peers = []

func _ready():
	print("Attempting to connect")
	server.listen(4242)
	
	
signal pixelChange

func _process(delta):
	server.poll() # Important!
	if server.is_connection_available():
		var peer: PacketPeerUDP = server.take_connection()
		var packet = peer.get_packet()
		print("Received data: %s" % [packet.get_string_from_utf8()])
		processInput(packet.get_string_from_utf8())

		# Reply so it knows we received the message.
		peer.put_packet(packet)
		# Keep a reference so we can keep contacting the remote peer.
		peers.append(peer)

	for i in range(0, peers.size()):
		pass # Do something with the connected peers.


func processInput(input: String):
	
	var differentVals = input.split(" ")
	print(differentVals)
	
	pixelChange.emit(int(differentVals[0]), int(differentVals[1]), int(differentVals[2]))
	
	
	
