{-------------------------------------------------------------------------------
scrcpy light launcher

by Alvaro 'krono' Gonzalez Ferrer

https://alvarogonzalezferrer.github.io/

Copyright (c) 2021

In loving memory of my father.

Released under the MIT license.

--------------------------------------------------------------------------------
This app is a launcher for:

Scrcpy: Display and control your Android device

Source of scrcpy https://github.com/Genymobile/scrcpy

This application provides display and control of Android devices connected
on USB (or over TCP/IP). It does not require any root access.
--------------------------------------------------------------------------------
To compile:
Source code for Lazarus > https://www.lazarus-ide.org/
-------------------------------------------------------------------------------}
unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  Process, LCLType, ComCtrls, about_form, help_form;

type

  { Tform_main }

  Tform_main = class(TForm)
    btn_launch: TButton;
    bitrate_label: TLabel;
    check_alwas_on_top: TCheckBox;
    check_stay_awake: TCheckBox;
    check_video_orientation: TCheckBox;
    check_max_size_vid: TCheckBox;
    check_max_fps_vid: TCheckBox;
    check_video_recording: TCheckBox;
    check_full_screen: TCheckBox;
    combo_video_orientation: TComboBox;
    combo_max_size_vid: TComboBox;
    combo_max_fps_vid: TComboBox;
    menu_help: TMenuItem;
    select_scrcpy_exe_dialog: TOpenDialog;
    record_filename_video: TEdit;
    groupParameters: TGroupBox;
    menu_main1: TMainMenu;
    menu_menu: TMenuItem;
    menu_config: TMenuItem;
    menu_about: TMenuItem;
    menu_exit: TMenuItem;
    bitrate_bar: TTrackBar;
    video_record_save_dialog: TSaveDialog;
    procedure bitrate_barChange(Sender: TObject);
    procedure btn_launchClick(Sender: TObject);
    procedure check_max_fps_vidChange(Sender: TObject);
    procedure check_max_size_vidChange(Sender: TObject);
    procedure check_video_orientationChange(Sender: TObject);
    procedure check_video_recordingChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure menu_aboutClick(Sender: TObject);
    procedure menu_configClick(Sender: TObject);
    procedure menu_exitClick(Sender: TObject);
    procedure menu_helpClick(Sender: TObject);
    procedure record_filename_videoClick(Sender: TObject);

  private

  public

  end;

var
  form_main: Tform_main;
  // config
  path_to_scrcpy : AnsiString = 'scrcpy.exe';


implementation

{$R *.lfm}

{ Tform_main }

procedure Tform_main.btn_launchClick(Sender: TObject);
var
   s : AnsiString; // string return
   p: array[1..50] of AnsiString; // parameters
   tmp : AnsiString; // save button caption
   i: Integer; // iterator
begin
     // todo init parameters
     for i := 1 to 50 do
         p[i] := '';

     if (bitrate_bar.Position > 0) then
        begin
          p[1] := '--bit-rate';
          p[2] := IntToStr(bitrate_bar.Position) +'M';
        end;

     if (check_max_size_vid.Checked) then
        begin
          p[3] := '--max-size';
          p[4] := combo_max_size_vid.Text;
        end;

     if (check_max_fps_vid.Checked) then
        begin
             p[5] := '--max-fps';
             p[6] := combo_max_fps_vid.Text;
        end;

     if (check_video_orientation.Checked) then
        begin
             p[7] := '--lock-video-orientation';
             p[8] := IntToStr(combo_video_orientation.ItemIndex);
        end;

     if (check_video_recording.Checked) then
        begin
             p[9] := '--record';
             p[10] := record_filename_video.Text;
        end;

     if (check_full_screen.Checked) then
        begin
             p[11] := '--fullscreen';
        end;

     if (check_alwas_on_top.Checked) then
        begin
             p[12] := '--always-on-top';
        end;

     if (check_stay_awake.Checked) then
        begin
             p[13] := '--stay-awake';
        end;

     // message while we wait
     tmp := btn_launch.Caption;
     btn_launch.Caption := 'WAITING!';

     // run the scrcpy show

     // minimize this application window
     Application.Minimize;

     // for some reason the try except is NOT WORKING / DEBUG / FIX THIS / TODO
     try
        RunCommand(path_to_scrcpy, p, s)
     except
           on E: EProcess do
              Application.MessageBox('Failed to lanch. Configure path first!', 'Failure', MB_ICONERROR + MB_OK);
     end;

     // restore window
     Application.Restore;

     // restore caption
     btn_launch.Caption := tmp;
end;

procedure Tform_main.check_max_fps_vidChange(Sender: TObject);
begin
  // enable disable combo box
  combo_max_fps_vid.Enabled := check_max_fps_vid.Checked;
end;

procedure Tform_main.check_max_size_vidChange(Sender: TObject);
begin
  // enable / disable combo box
  combo_max_size_vid.Enabled := check_max_size_vid.Checked;
end;

procedure Tform_main.check_video_orientationChange(Sender: TObject);
begin
  // enable disable combo box
  combo_video_orientation.Enabled := check_video_orientation.Checked;
end;

procedure Tform_main.check_video_recordingChange(Sender: TObject);
begin
  // enable / disable
  record_filename_video.Enabled := check_video_recording.Checked;

  // if enabled, then select file
  if record_filename_video.Enabled then
     record_filename_videoClick(Sender); // fake click
end;

procedure Tform_main.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
   reply : Integer;
begin
     // confirm close // debug annyoing?
     // end app
     reply := Application.MessageBox('Exit, are you sure?', 'Exit', MB_ICONQUESTION + MB_YESNO);
     if reply = IDNO then CloseAction := caNone;
end;

procedure Tform_main.bitrate_barChange(Sender: TObject);

begin
  // video bitrate changed, in megabytes
  // DEBUG 0 deberia ser valor default TODO
  if bitrate_bar.Position > 0 then
     bitrate_label.Caption := 'Bitrate ' + IntToStr(bitrate_bar.Position) + ' Mbps'
  else
      bitrate_label.Caption := 'Bitrate default';

end;

procedure Tform_main.FormCreate(Sender: TObject);
begin
  // TODO debug should load config here
end;

procedure Tform_main.menu_aboutClick(Sender: TObject);
begin
  aboutForm.ShowModal; // about me form
end;

procedure Tform_main.menu_configClick(Sender: TObject);
begin
  // config
  if select_scrcpy_exe_dialog.Execute then
     path_to_scrcpy := select_scrcpy_exe_dialog.FileName;
end;

procedure Tform_main.menu_exitClick(Sender: TObject);
var
   reply: Integer;
begin
     // end app
     reply := Application.MessageBox('Exit, are you sure?', 'Exit', MB_ICONQUESTION + MB_YESNO);
     if reply = IDYES then Application.Terminate;
end;

procedure Tform_main.menu_helpClick(Sender: TObject);
begin
     // show help
     helpForm.Show;
end;

procedure Tform_main.record_filename_videoClick(Sender: TObject);
begin
     // open dialog for file select
     // https://wiki.freepascal.org/Howto_Use_TSaveDialog
     if video_record_save_dialog.Execute then
        record_filename_video.Text := video_record_save_dialog.FileName // take tne file the user selected
     else
         check_video_recording.Checked := False; // cancelled the file selection, uncheck this
end;


end.

