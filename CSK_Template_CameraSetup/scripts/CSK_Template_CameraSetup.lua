--MIT License
--
--Copyright (c) 2023 SICK AG
--
--Permission is hereby granted, free of charge, to any person obtaining a copy
--of this software and associated documentation files (the "Software"), to deal
--in the Software without restriction, including without limitation the rights
--to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--copies of the Software, and to permit persons to whom the Software is
--furnished to do so, subject to the following conditions:
--
--The above copyright notice and this permission notice shall be included in all
--copies or substantial portions of the Software.
--
--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--SOFTWARE.

---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter
-- CreationTemplateVersion: 3.3.0
--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************

-- If app property "LuaLoadAllEngineAPI" is FALSE, use this to load and check for required APIs
-- This can improve performance of garbage collection

_G.availableAPIs = require('Application/CameraSetupTemplate/helper/checkAPIs') -- can be used to adjust function scope of the module related on available APIs of the device
-----------------------------------------------------------
-- Logger
_G.logger = Log.SharedLogger.create('ModuleLogger')
_G.logHandle = Log.Handler.create()
_G.logHandle:attachToSharedLogger('ModuleLogger')
_G.logHandle:setConsoleSinkEnabled(false) --> Set to TRUE if CSK_Logger module is not used
_G.logHandle:setLevel("ALL")
_G.logHandle:applyConfig()
-----------------------------------------------------------

--- Function to show UI of this app first
local function setAppAsMainWebpage()
  local defaultWebpage = Parameters.get("AEDefaultWebpage")
  if defaultWebpage == nil then
    _G.logger:warning("Device does not support setting the default webpage.")
  else
    assert(Parameters.set("AEDefaultWebpage", _APPNAME))
  end
end

-- Loading script regarding CameraSetupTemplate_Model
-- Check this script regarding CameraSetupTemplate_Model parameters and functions
_G.cameraSetupTemplate_Model = require('Application/CameraSetupTemplate/CameraSetupTemplate_Model')

--**************************************************************************
--**********************End Global Scope ***********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--- Function to react on startup event of the app
local function main()

  ----------------------------------------------------------------------------------------
  -- INFO: Please check if module will eventually load inital configuration triggered via
  --       event CSK_PersistentData.OnInitialDataLoaded
  --       (see internal variable _G.cameraSetupTemplate_Model.parameterLoadOnReboot)
  --       If so, the app will trigger the "OnDataLoadedOnReboot" event if ready after loading parameters
  --
  -- Can be used e.g. like this
  ----------------------------------------------------------------------------------------

  _G.logger:info("Start the CameraSetup application")
  setAppAsMainWebpage() -- Set UI of this app as default UI.
  CSK_CameraSetupTemplate.pageCalled() -- Update UI

  -- Use following function to start default setup:
  -- Camera powered on S1/S2 and connected to ETH1 / ETH2 with IPs 192.168.1.100 / 192.168.2.100

  -- _G.cameraSetupTemplate_Model.setupDefaultConfig()

end
Script.register("Engine.OnStarted", main)

--OR

-- Call function after persistent data was loaded
--Script.register("CSK_CameraSetupTemplate.OnDataLoadedOnReboot", main)

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************
