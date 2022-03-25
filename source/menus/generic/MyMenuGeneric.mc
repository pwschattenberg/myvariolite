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
using Toybox.WatchUi as Ui;

class MyMenuGeneric extends Ui.Menu {

  //
  // FUNCTIONS: Ui.Menu (override/implement)
  //

  function initialize(_menu as Symbol) {
    Menu.initialize();

    if(_menu == :menuSettings) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettings) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsAltimeter) as String, :menuSettingsAltimeter);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsVariometer) as String, :menuSettingsVariometer);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsSounds) as String, :menuSettingsSounds);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsActivity) as String, :menuSettingsActivity);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsGeneral) as String, :menuSettingsGeneral);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSettingsUnits) as String, :menuSettingsUnits);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAbout) as String, :menuAbout);
    }

    else if(_menu == :menuSettingsAltimeter) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsAltimeter) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCalibration) as String, :menuAltimeterCalibration);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCorrection) as String, :menuAltimeterCorrection);
    }
    else if(_menu == :menuAltimeterCalibration) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAltimeterCalibration) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCalibrationQNH) as String, :menuAltimeterCalibrationQNH);
      if(LangUtils.notNaN($.oMyAltimeter.fAltitudeActual)) {
        Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCalibrationElevation) as String, :menuAltimeterCalibrationElevation);
      }
    }
    else if(_menu == :menuAltimeterCorrection) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAltimeterCorrection) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCorrectionAbsolute) as String, :menuAltimeterCorrectionAbsolute);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleAltimeterCorrectionRelative) as String, :menuAltimeterCorrectionRelative);
    }

    else if(_menu == :menuSettingsVariometer) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsVariometer) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleVariometerRange) as String, :menuVariometerRange);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleVariometerAutoThermal) as String, :menuVariometerAutoThermal);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleVariometerThermalDetect) as String, :menuVariometerThermalDetect);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleVariometerSmoothing) as String, :menuVariometerSmoothing);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleVariometerPlotRange) as String, :menuVariometerPlotRange);
    }

    else if(_menu == :menuSettingsSounds) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsSounds) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleSoundsVariometerTones) as String, :menuSoundsVariometerTones);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleVariometerVibrations) as String, :menuVariometerVibrations);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleMinimumClimb) as String, :menuMinimumClimb);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleMinimumSink) as String, :menuMinimumSink);
    }

    else if(_menu == :menuSettingsActivity) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsActivity) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleActivityAutoStart) as String, :menuActivityAutoStart);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleActivityAutoSpeedStart) as String, :menuActivityAutoSpeedStart);
    }

    else if(_menu == :menuSettingsGeneral) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsGeneral) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleGeneralBackgroundColor) as String, :menuGeneralBackgroundColor);
    }

    else if(_menu == :menuSettingsUnits) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsUnits) as String);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitDistance) as String, :menuUnitDistance);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitElevation) as String, :menuUnitElevation);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitPressure) as String, :menuUnitPressure);
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitDirection) as String, :menuUnitDirection);      
      Menu.addItem(Ui.loadResource(Rez.Strings.titleUnitTimeUTC) as String, :menuUnitTimeUTC);
    }

    else if(_menu == :menuAbout) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleAbout) as String);
      Menu.addItem(format("$1$: $2$", [Ui.loadResource(Rez.Strings.titleVersion), Ui.loadResource(Rez.Strings.AppVersion)]), :aboutVersion);
      Menu.addItem(format("$1$: GPL 3.0", [Ui.loadResource(Rez.Strings.titleLicense)]), :aboutLicense);
      Menu.addItem(format("$1$: Yannick Dutertre", [Ui.loadResource(Rez.Strings.titleAuthor)]), :aboutAuthor);
      Menu.addItem("Based on Glider SK", :aboutGliderSK);
      Menu.addItem(format("$1$: Cédric Dufour", [Ui.loadResource(Rez.Strings.titleAuthor)]), :aboutAuthor);
    }

    else if(_menu == :menuActivity) {
      Menu.setTitle(Ui.loadResource(Rez.Strings.titleActivity) as String);
      if($.oMyActivity != null) {
        if(($.oMyActivity as MyActivity).isRecording()) {
          Menu.addItem(Ui.loadResource(Rez.Strings.titleActivityPause) as String, :menuActivityPause);
        }
        else {
          Menu.addItem(Ui.loadResource(Rez.Strings.titleActivityResume) as String, :menuActivityResume);
        }
        Menu.addItem(Ui.loadResource(Rez.Strings.titleActivitySave) as String, :menuActivitySave);
        Menu.addItem(Ui.loadResource(Rez.Strings.titleActivityDiscard) as String, :menuActivityDiscard);
      }
    }

  }

}

class MyMenuGenericDelegate extends Ui.MenuInputDelegate {

  //
  // VARIABLES
  //

  private var menu as Symbol = :menuNone;


  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize(_menu as Symbol) {
    MenuInputDelegate.initialize();
    self.menu = _menu;
  }

  function onMenuItem(_item as Symbol) {

    if(self.menu == :menuSettings) {
      if(_item == :menuSettingsAltimeter) {
        Ui.pushView(new MyMenuGeneric(:menuSettingsAltimeter),
                    new MyMenuGenericDelegate(:menuSettingsAltimeter),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsVariometer) {
        Ui.pushView(new MyMenuGeneric(:menuSettingsVariometer),
                    new MyMenuGenericDelegate(:menuSettingsVariometer),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsSounds) {
        Ui.pushView(new MyMenuGeneric(:menuSettingsSounds),
                    new MyMenuGenericDelegate(:menuSettingsSounds),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsActivity) {
        Ui.pushView(new MyMenuGeneric(:menuSettingsActivity),
                    new MyMenuGenericDelegate(:menuSettingsActivity),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsGeneral) {
        Ui.pushView(new MyMenuGeneric(:menuSettingsGeneral),
                    new MyMenuGenericDelegate(:menuSettingsGeneral),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuSettingsUnits) {
        Ui.pushView(new MyMenuGeneric(:menuSettingsUnits),
                    new MyMenuGenericDelegate(:menuSettingsUnits),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuAbout) {
        Ui.pushView(new MyMenuGeneric(:menuAbout),
                    new MyMenuGenericDelegate(:menuAbout),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsAltimeter) {
      if(_item == :menuAltimeterCalibration) {
        Ui.pushView(new MyMenuGeneric(:menuAltimeterCalibration),
                    new MyMenuGenericDelegate(:menuAltimeterCalibration),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuAltimeterCorrection) {
        Ui.pushView(new MyMenuGeneric(:menuAltimeterCorrection),
                    new MyMenuGenericDelegate(:menuAltimeterCorrection),
                    Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuAltimeterCalibration) {
      if(_item == :menuAltimeterCalibrationQNH) {
        Ui.pushView(new MyPickerGenericPressure(:contextSettings, :itemAltimeterCalibration),
                    new MyPickerGenericPressureDelegate(:contextSettings, :itemAltimeterCalibration),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuAltimeterCalibrationElevation) {
        Ui.pushView(new MyPickerGenericElevation(:contextSettings, :itemAltimeterCalibration),
                    new MyPickerGenericElevationDelegate(:contextSettings, :itemAltimeterCalibration),
                    Ui.SLIDE_IMMEDIATE);
      }
    }
    else if(self.menu == :menuAltimeterCorrection) {
      if(_item == :menuAltimeterCorrectionAbsolute) {
        Ui.pushView(new MyPickerGenericPressure(:contextSettings, :itemAltimeterCorrection),
                    new MyPickerGenericPressureDelegate(:contextSettings, :itemAltimeterCorrection),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuAltimeterCorrectionRelative) {
        Ui.pushView(new MyPickerAltimeterCorrectionRelative(),
                    new MyPickerAltimeterCorrectionRelativeDelegate(),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsVariometer) {
      if(_item == :menuVariometerRange) {
        Ui.pushView(new MyPickerGenericSettings(:contextVariometer, :itemRange),
                    new MyPickerGenericSettingsDelegate(:contextVariometer, :itemRange),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuVariometerAutoThermal) {
        Ui.pushView(new MyPickerGenericOnOff(:contextVariometer, :itemAutoThermal),
                    new MyPickerGenericOnOffDelegate(:contextVariometer, :itemAutoThermal),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuVariometerThermalDetect) {
        Ui.pushView(new MyPickerGenericOnOff(:contextVariometer, :itemThermalDetect),
                    new MyPickerGenericOnOffDelegate(:contextVariometer, :itemThermalDetect),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuVariometerPlotRange) {
        Ui.pushView(new MyPickerGenericSettings(:contextVariometer, :itemPlotRange),
                    new MyPickerGenericSettingsDelegate(:contextVariometer, :itemPlotRange),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuVariometerSmoothing) {
        Ui.pushView(new MyPickerGenericSettings(:contextVariometer, :itemSmoothing),
                    new MyPickerGenericSettingsDelegate(:contextVariometer, :itemSmoothing),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsSounds) {
      if(_item == :menuSoundsVariometerTones) {
        Ui.pushView(new MyPickerGenericOnOff(:contextSettings, :itemSoundsVariometerTones),
                    new MyPickerGenericOnOffDelegate(:contextSettings, :itemSoundsVariometerTones),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuVariometerVibrations) {
        Ui.pushView(new MyPickerGenericOnOff(:contextSettings, :itemVariometerVibrations),
                    new MyPickerGenericOnOffDelegate(:contextSettings, :itemVariometerVibrations),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuMinimumClimb) {
        Ui.pushView(new MyPickerGenericSettings(:contextSettings, :itemMinimumClimb),
                    new MyPickerGenericSettingsDelegate(:contextSettings, :itemMinimumClimb),
                    Ui.SLIDE_IMMEDIATE); 
      }
      else if(_item == :menuMinimumSink) {
        Ui.pushView(new MyPickerGenericSettings(:contextSettings, :itemMinimumSink),
                    new MyPickerGenericSettingsDelegate(:contextSettings, :itemMinimumSink),
                    Ui.SLIDE_IMMEDIATE); 
      }
    }

    else if(self.menu == :menuSettingsActivity) {
      if(_item == :menuActivityAutoStart) {
        Ui.pushView(new MyPickerGenericOnOff(:contextSettings, :itemActivityAutoStart),
                    new MyPickerGenericOnOffDelegate(:contextSettings, :itemActivityAutoStart),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuActivityAutoSpeedStart) {
        Ui.pushView(new MyPickerGenericSpeed(:contextSettings, :itemActivityAutoSpeedStart),
                    new MyPickerGenericSpeedDelegate(:contextSettings, :itemActivityAutoSpeedStart),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsGeneral) {
      if(_item == :menuGeneralBackgroundColor) {
        Ui.pushView(new MyPickerGenericSettings(:contextGeneral, :itemBackgroundColor),
                    new MyPickerGenericSettingsDelegate(:contextGeneral, :itemBackgroundColor),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    else if(self.menu == :menuSettingsUnits) {
      if(_item == :menuUnitDistance) {
        Ui.pushView(new MyPickerGenericSettings(:contextUnit, :itemDistance),
                    new MyPickerGenericSettingsDelegate(:contextUnit, :itemDistance),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuUnitElevation) {
        Ui.pushView(new MyPickerGenericSettings(:contextUnit, :itemElevation),
                    new MyPickerGenericSettingsDelegate(:contextUnit, :itemElevation),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuUnitPressure) {
        Ui.pushView(new MyPickerGenericSettings(:contextUnit, :itemPressure),
                    new MyPickerGenericSettingsDelegate(:contextUnit, :itemPressure),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuUnitDirection) {
        Ui.pushView(new MyPickerGenericSettings(:contextUnit, :itemDirection),
                    new MyPickerGenericSettingsDelegate(:contextUnit, :itemDirection),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuUnitTimeUTC) {
        Ui.pushView(new MyPickerGenericSettings(:contextUnit, :itemTimeUTC),
                    new MyPickerGenericSettingsDelegate(:contextUnit, :itemTimeUTC),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

    //else if(self.menu == :menuAbout) {
    //  // Nothing to do here
    //}

    else if(self.menu == :menuActivity) {
      if(_item == :menuActivityResume) {
        if($.oMyActivity != null) {
          ($.oMyActivity as MyActivity).resume();
        }
      }
      else if(_item == :menuActivityPause) {
        if($.oMyActivity != null) {
          ($.oMyActivity as MyActivity).pause();
        }
      }
      else if(_item == :menuActivitySave) {
        Ui.pushView(new MyMenuGenericConfirm(:contextActivity, :actionSave),
                    new MyMenuGenericConfirmDelegate(:contextActivity, :actionSave, true),
                    Ui.SLIDE_IMMEDIATE);
      }
      else if(_item == :menuActivityDiscard) {
        Ui.pushView(new MyMenuGenericConfirm(:contextActivity, :actionDiscard),
                    new MyMenuGenericConfirmDelegate(:contextActivity, :actionDiscard, true),
                    Ui.SLIDE_IMMEDIATE);
      }
    }

  }

}
