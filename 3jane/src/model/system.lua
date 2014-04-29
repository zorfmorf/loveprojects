
-- The player will always be in a system. 
-- A system has one or more entry/exit nodes
-- A system has zero or more ai nodes
-- A system has programs
-- A system has zero or more terminals used by humans

SYSTEM_STATE_CALM = 0
SYSTEM_STATE_SUSPICIOUS = 0.5
SYSTEM_STATE_ALERT = 1

class "System" {

	travelNodes = {};
	aiNodes = {};
	programs = {};
	terminals = {};
	state = 0.2;
	
	
	__init__ = function(self)
		
		print("Initiating system")
		
		table.insert(self.programs, Program(PSGEN_TYPE_WATCHER))
		table.insert(self.programs, Program(PSGEN_TYPE_ATTACKER))
		table.insert(self.programs, Program(PSGEN_TYPE_DEFENDER))
		
		for i,p in pairs(self.programs) do
			
			p.ps:setPosition( math.random(50, love.graphics.getWidth() - 50), math.random(0, love.graphics.getHeight() - 50) )
			p.ps:start()
		
		end
	
	end
	
}
