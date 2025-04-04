
 # LGF Ped Bone Tool
 
 This tool is designed only for `development` purposes.
 It allows developers to debug PEDs by attaching objects to specific bones, viewing real-time damage information, and inspecting bone structures.
 It is not intended for roleplay servers or gameplay use — strictly a utility for developers working on `PEDs`, `animations`, or `combat systems` or `other Stuff`.
 
 ![image](https://github.com/user-attachments/assets/3d1d1218-5a9b-43a5-b96d-751e6e57ac14)
 
 
 # getAvailableBones
 This export retrieves the list of available bones used for debugging `PEDs`. It returns a deep clone of the bone data to prevent external modification.
 
 ```lua
 ---@return table -- Deep clone of the bones data
 exports.LGF_PedBoneTool:getAvailableBones()
 ```
 # isToolBusy
 
 This functions checks if the Bone Tool is currently being used (if the panel is open or not).
 
 
 ### Using the export function:
 ```lua
 ---@return Type: boolean (true if the Bone Tool is busy, false otherwise)
 exports.LGF_PedBoneTool:isBoneToolBusy()
 ```
 ### Using the local state var:
 ```lua
 ---@return Type: boolean (true if the Bone Tool is busy, false otherwise)
 LocalPlayer.state.boneToolBusy
 ```
