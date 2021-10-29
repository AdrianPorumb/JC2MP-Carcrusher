-- car crusher script
-- player comes to the crusher checkpoint, if he is not in a vehicle give info SendChatMessage
-- if he is in vehicle take the vehicle (car or boat) and give player money=2x weight of vehicle 
crusher={
	Vector3(6844.786621, 999.863403, -5785.316406	),
	Vector3(7530.724121, 204.094147, 4686.677734    ),
	Vector3(12102.083984, 200.021606, 3879.893066   ),
	Vector3(-7048.081055, 199.897308, -11287.855469 ),
	Vector3(-9320.700195, 504.445984, 3385.886963   ),
	Vector3(-8838.104492, 275.692474, 10135.501953  ),
	Vector3(-10129.070313, 199.336639, -208.842056	),
	Vector3(-10602.500977, 222.493759, -3319.043213 ),
	Vector3(-10646.703125, 199.417068, -2642.890869 ),
	Vector3(-12487.665039, 200.048523, -4431.532715 ),
	Vector3(-12445.024414, 203.064026, -4020.855957 ),
	Vector3(-15298.589844, 203.097595, -2982.180420 ),
	Vector3(-13313.609375, 202.858994, -1039.580078 )							
	}
chktable={}	
function CreatecrusherCheckpoint() -- generates checkpoints
 for k,v in pairs(crusher) do
 local argstable={
text= "CASH FOR RUST", -- this appears only on " Distance text supported in wiki"
type= 7, --  13 Colonel ,16 scorpion red ,28 scorpion white ,29 Black first aid icon,8 first aid 12- cash 30 square 7 	Race finish 
position=v,
activation_box=Vector3(10,10,10),
despawn_on_enter= false,
create_trigger=true,
create_checkpoint=true,
create_indicator= true,
world=DefaultWorld,
}
local pos=Checkpoint.Create(argstable)
pos:SetStreamDistance(200)
 table.insert(chktable,pos)
 -- for k,v in ipairs(chktable) do 
 -- print(k,v:GetId())

-- end
--Stetstreamdist()
end
end

function Stetstreamdist()
for checkpoint in Server:GetCheckpoints() do
if checkpoint:GetStreamDistance()== 100 then return
else
checkpoint:SetStreamDistance(100)
end
end
end
	
function Entercheckpoint(args) -- generates problems with properties script since a function there is triggered at the same time.
local m1="Welcome to CASH FOR RUST. This is where your old car/boat makes money for you "
local m2="Here is your money.Come back any time!"
--print("text load" )
for k,v in ipairs(chktable) do
-- print("for1" )
-- print ("args.checkpoint:GetId() ",args.checkpoint:GetId())
local chkidtable,localchkid= v:GetId(),args.checkpoint:GetId()
-- print ( "chkidtable",v:GetId(),"localchkid", localchkid )
	--if v:GetId() == args.checkpoint:GetId() then 
	if chkidtable == localchkid then 
		if IsValid(args.player) and not args.player:InVehicle() then 
args.player:SendChatMessage(m1,Color.White)
print(args.player ,"had no vehicle")
		elseif IsValid(args.player) and args.player:InVehicle() then
			local massofvehicle =args.player:GetVehicle():GetMass()
			--local typev=args.player:GetVehicle():GetMass()
					--if 
					args.player:SetMoney(args.player:GetMoney()+(2*massofvehicle))
					args.player:SendChatMessage(m2,Color.White)
					args.player:GetVehicle():SetHealth(0.15)
					-- args.player:GetVehicle():Remove()
					print("vehicle bought from",args.player)
	 		end
		end	
	end
end
function Cleanup()
 for k,chk in ipairs(chktable) do
 chk:Remove()
 end
Events:UnsubscribeAll()
end
Events:Subscribe("ModuleLoad",CreatecrusherCheckpoint )
Events:Subscribe("PlayerEnterCheckpoint", Entercheckpoint)
Events:Subscribe("ModuleUnload",Cleanup)