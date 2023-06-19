# jab

Simple game that will have:
- generated worlds, so each time is a new experience
- objects that can be broken down into resources
- add some sort of combat abilities
- allow for multiplayers via a client/server
	
The order in which things need to be developed is:
- [ ] a class to procedurally generate worlds given a set of tiles 
   representing different types of world landscape. We ideally should spend
   time making sure its consistently generating playable maps.
- [ ] add in a single character and build in movement mechanics.
- [ ] work on making certain generated items to be interactable. 
   Like trees/rocks being breakable for resources.
- [ ] build an inventory system.
- [ ] build a build system based on amount of resources.
- [ ] work on a menu that allows you to select "Single Player" or "Online".
- [ ] build out "Multiplayer Networking". I think the generated world would 
   happen on the server and read by the clients.
- [ ] once the bugs are flushed out with the networking, we need to make some
   sort of enemies or things to fight.
	
