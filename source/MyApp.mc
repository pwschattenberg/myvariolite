// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// My Vario
// Copyright (C) 2022 Yannick Dutertre <https://yannickd9.wixsite.com/>
//
// My Vario is free software:
// you can redistribute it and/or modify it under the terms of the GNU General
// Public License as published by the Free Software Foundation, Version 3.
//
// My Vario is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// See the GNU General Public License for more details.
//
// SPDX-License-Identifier: GPL-3.0
// License-Filename: LICENSE/GPL-3.0.txt
// My Vario is based on Glider's Swiss Knife (GliderSK) by Cedric Dufour

// Glider's Swiss Knife (GliderSK)
// Copyright (C) 2017-2022 Cedric Dufour <http://cedric.dufour.name>
//
// Glider's Swiss Knife (GliderSK) is free software:
// you can redistribute it and/or modify it under the terms of the GNU General
// Public License as published by the Free Software Foundation, Version 3.
//
// Glider's Swiss Knife (GliderSK) is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// See the GNU General Public License for more details.
//
// SPDX-License-Identifier: GPL-3.0
// License-Filename: LICENSE/GPL-3.0.txt

import Toybox.Lang;
using Toybox.Activity;
using Toybox.Application as App;
using Toybox.Attention as Attn;
using Toybox.Communications as Comm;
using Toybox.Position as Pos;
using Toybox.Sensor;
using Toybox.System as Sys;
using Toybox.Time;
using Toybox.Timer;
using Toybox.WatchUi as Ui;

//
// GLOBALS
//

// Application settings
var oMySettings as MySettings = new MySettings() ;

// (Last) position location/altitude
var oMyPositionLocation as Pos.Location?;
var fMyPositionAltitude as Float = NaN;

// Sensors filter
var oMyKalmanFilter as MyKalmanFilter = new MyKalmanFilter();

// Internal altimeter
var oMyAltimeter as MyAltimeter = new MyAltimeter();

// Processing logic
var oMyProcessing as MyProcessing = new MyProcessing();
var oMyTimeStart as Time.Moment = Time.now();

// Activity session (recording)
var oMyActivity as MyActivity?;

// Current view
var oMyView as MyView?;


//
// CONSTANTS
//

// No-value strings
// NOTE: Those ought to be defined in the MyApp class like other constants but code then fails with an "Invalid Value" error when called upon; BUG?
const MY_NOVALUE_BLANK = "";
const MY_NOVALUE_LEN2 = "--";
const MY_NOVALUE_LEN3 = "---";
const MY_NOVALUE_LEN4 = "----";


//
// CLASS
//

class MyApp extends App.AppBase {

  //
  // CONSTANTS
  //

  // FIT fields (as per resources/fit.xml)
  public const FITFIELD_VERTICALSPEED = 0;
  public const FITFIELD_BAROMETRICALTITUDE = 1;

  //
  // VARIABLES
  //

  // Timers
  // ... UI update
  private var oUpdateTimer as Timer.Timer?;
  private var iUpdateLastEpoch as Number = 0;
  // ... tones
  private var oTonesTimer as Timer.Timer?;
  private var iTonesTick as Number = 1000;
  private var iTonesLastTick as Number = 0;

  // Tones
  private var bTones as Boolean = false;
  private var bVibrations as Boolean = false;
  private var bSinkToneTriggered as Boolean = false;

  // Manager Instances
  private var oActivityManager as MyActivityManager = new MyActivityManager();

  //
  // FUNCTIONS: App.AppBase (override/implement)
  //

  function initialize() {
    AppBase.initialize();

    // Timers
    $.oMyTimeStart = Time.now();
  }

  function onStart(state) {
    //Sys.println("DEBUG: MyApp.onStart()");

    // Load settings
    self.loadSettings();

    // Enable sensor events
    Sensor.setEnabledSensors([] as Array<Sensor.SensorType>);  // ... we need just the acceleration
    Sensor.enableSensorEvents(method(:onSensorEvent));

    // Enable position events
    Pos.enableLocationEvents(Pos.LOCATION_CONTINUOUS, method(:onLocationEvent));

    // Start UI update timer (every multiple of 5 seconds, to save energy)
    // NOTE: in normal circumstances, UI update will be triggered by position events (every ~1 second)
    self.oUpdateTimer = new Timer.Timer();
    var iUpdateTimerDelay = (60-Sys.getClockTime().sec)%5;
    if(iUpdateTimerDelay > 0) {
      (self.oUpdateTimer as Timer.Timer).start(method(:onUpdateTimer_init), 1000*iUpdateTimerDelay, false);
    }
    else {
      (self.oUpdateTimer as Timer.Timer).start(method(:onUpdateTimer), 5000, true);
    }
  }

  function onStop(state) {
    //Sys.println("DEBUG: MyApp.onStop()");

    // Stop timers
    // ... UI update
    if(self.oUpdateTimer != null) {
      (self.oUpdateTimer as Timer.Timer).stop();
      self.oUpdateTimer = null;
    }
    // ... tones
    if(self.oTonesTimer != null) {
      (self.oTonesTimer as Timer.Timer).stop();
      self.oTonesTimer = null;
    }

    // Disable position events
    Pos.enableLocationEvents(Pos.LOCATION_DISABLE, method(:onLocationEvent));

    // Disable sensor events
    Sensor.enableSensorEvents(null);
  }

  function getInitialView() {
    //Sys.println("DEBUG: MyApp.getInitialView()");

    return [new MyViewGeneral(), new MyViewGeneralDelegate()];
  }

  function onSettingsChanged() {
    //Sys.println("DEBUG: MyApp.onSettingsChanged()");
    self.loadSettings();
    self.updateUi(Time.now().value());
  }


  //
  // FUNCTIONS: self
  //

  function loadSettings() as Void {
    //Sys.println("DEBUG: MyApp.loadSettings()");

    // Load settings
    $.oMySettings.load();

    // Apply settings

    $.oMyAltimeter.importSettings();

    // ... tones
    self.muteTones();
  }

  function onSensorEvent(_oInfo as Sensor.Info) as Void {
    //Sys.println("DEBUG: MyApp.onSensorEvent());

    // Process altimeter data
    var oActivityInfo = Activity.getActivityInfo();  // ... we need *raw ambient* pressure
    if(oActivityInfo != null) {
      if(oActivityInfo has :rawAmbientPressure and oActivityInfo.rawAmbientPressure != null) {
        $.oMyAltimeter.setQFE(oActivityInfo.rawAmbientPressure as Float);
        //Sys.println(format("First altimeter run $1$", [$.oMyAltimeter.bFirstRun]));        
        //Initial automated calibration based on watch altitude
        if($.oMyAltimeter.bFirstRun && _oInfo has :altitude && _oInfo.altitude != null) {
          $.oMyAltimeter.bFirstRun = false;
          $.oMyAltimeter.setAltitudeActual(_oInfo.altitude);
          $.oMySettings.saveAltimeterCalibrationQNH($.oMyAltimeter.fQNH);
        }
      }
    }

    // Process sensor data
    $.oMyProcessing.processSensorInfo(_oInfo, Time.now().value());

    // Save FIT fields
    if($.oMyActivity != null) {
      ($.oMyActivity as MyActivity).setBarometricAltitude($.oMyProcessing.fAltitude);
      ($.oMyActivity as MyActivity).setVerticalSpeed($.oMyProcessing.fVariometer);
    }
  }

  function onLocationEvent(_oInfo as Pos.Info) as Void {
    //Sys.println("DEBUG: MyApp.onLocationEvent()");
    var oTimeNow = Time.now();
    var iEpoch = oTimeNow.value();

    // Save location
    if(_oInfo has :position) {
      $.oMyPositionLocation = _oInfo.position;
    }

    // Save altitude
    if(_oInfo has :altitude and _oInfo.altitude != null) {
      $.fMyPositionAltitude = _oInfo.altitude as Float;
    }

    // Process position data
    $.oMyProcessing.processPositionInfo(_oInfo, iEpoch);
    if($.oMyActivity != null) {
      ($.oMyActivity as MyActivity).processPositionInfo(_oInfo, iEpoch, oTimeNow);
    }

    // Automatic Activity recording
    self.oActivityManager.checkAutoStart();

    // UI update
    self.updateUi(iEpoch);
  }

  function onUpdateTimer_init() as Void {
    //Sys.println("DEBUG: MyApp.onUpdateTimer_init()");
    self.onUpdateTimer();
    self.oUpdateTimer = new Timer.Timer();
    (self.oUpdateTimer as Timer.Timer).start(method(:onUpdateTimer), 5000, true);
  }

  function onUpdateTimer() as Void {
    //Sys.println("DEBUG: MyApp.onUpdateTimer()");
    var iEpoch = Time.now().value();
    if(iEpoch-self.iUpdateLastEpoch > 1) {
      self.updateUi(iEpoch);
    }
  }

  function onTonesTimer() as Void {
    //Sys.println("DEBUG: MyApp.onTonesTimer()");
    self.playTones();
    self.iTonesTick++;
  }

  function updateUi(_iEpoch as Number) as Void {
    //Sys.println("DEBUG: MyApp.updateUi()");

    // Check sensor data age
    if($.oMyProcessing.iSensorEpoch >= 0 and _iEpoch-$.oMyProcessing.iSensorEpoch > 10) {
      $.oMyProcessing.resetSensorData();
      $.oMyAltimeter.reset();
    }

    // Check position data age
    if($.oMyProcessing.iPositionEpoch >= 0 and _iEpoch-$.oMyProcessing.iPositionEpoch > 10) {
      $.oMyProcessing.resetPositionData();
    }

    // Update UI
    if($.oMyView != null) {
      ($.oMyView as MyView).updateUi();
      self.iUpdateLastEpoch = _iEpoch;
    }
  }

  function muteTones() as Void {
    // Stop tones timers
    if(self.oTonesTimer != null) {
      (self.oTonesTimer as Timer.Timer).stop();
      self.oTonesTimer = null;
    }
  }

  function unmuteTones() as Void {
    // Enable tones
    self.bTones = false;
    if(Toybox.Attention has :playTone) {
      if($.oMySettings.bSoundsVariometerTones) {
        self.bTones = true;
      }
    }

    self.bVibrations = false;
    if(Toybox.Attention has :vibrate) {
      if($.oMySettings.bVariometerVibrations) {
        self.bVibrations = true;
      }
    }

    // Start tones timer
    // NOTE: For variometer tones, we need a 10Hz <-> 100ms resolution;
    if(self.bTones || self.bVibrations) {
      self.iTonesTick = 1000;
      self.iTonesLastTick = 0;
      self.oTonesTimer = new Timer.Timer();
      self.oTonesTimer.start(method(:onTonesTimer), 100, true);
    }
  }

  function playTones() as Void {
    //Sys.println(format("DEBUG: MyApp.playTones() @ $1$", [self.iTonesTick]));
    // Variometer
    // ALGO: Tones "tick" is 100ms; I try to do a curve that is similar to the Skybean vario
    // Medium curve in terms of tone length, pause, and one frequency.
    // Tones need to be more frequent than in GliderSK even at low climb rates to be able to
    // properly map thermals (especially broken up thermals)
    if(self.bTones || self.bVibrations) {
      var fValue = $.oMyProcessing.fVariometer_filtered;
      var iDeltaTick = (self.iTonesTick-self.iTonesLastTick) > 8 ? 8 : self.iTonesTick-self.iTonesLastTick;
      if(fValue >= $.oMySettings.fMinimumClimb && iDeltaTick >= 8.0f - fValue) {
        //Sys.println(format("DEBUG: playTone: variometer @ $1$", [self.iTonesTick]));
        var iToneLength = (iDeltaTick > 2) ? iDeltaTick * 50 - 100: 50;
        if(self.bTones) {
          var iToneFrequency = (400 + fValue * 100) > 1100 ? 1100 : (400 + fValue * 100).toNumber();
          var toneProfile = [new Attn.ToneProfile(iToneFrequency, iToneLength)]; //contrary to Garmin API Doc, first parameter seems to be frequency, and second length
          Attn.playTone({:toneProfile=>toneProfile});
        }
        if(self.bVibrations) {
          var vibeData = [new Attn.VibeProfile(100, (iToneLength > 200) ? iToneLength / 2 : 50)]; //Keeping vibration length shorter than tone for battery and wrist!
          Attn.vibrate(vibeData);
        }
        self.iTonesLastTick = self.iTonesTick;
        return;
      }
      else if(fValue <= $.oMySettings.fMinimumSink && !self.bSinkToneTriggered && self.bTones) {
        var toneProfile = [new Attn.ToneProfile(220, 2000)];
        Attn.playTone({:toneProfile=>toneProfile});
        self.bSinkToneTriggered = true;
      }
      //Reset minimum sink tone if we get significantly above it
      if(fValue >= $.oMySettings.fMinimumSink + 1.0f && self.bSinkToneTriggered) {
        self.bSinkToneTriggered = false;
      }
    }
  }

}
