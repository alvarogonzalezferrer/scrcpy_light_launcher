{-------------------------------------------------------------------------------
scrcpy light launcher

by Alvaro 'krono' Gonzalez Ferrer

https://alvarogonzalezferrer.github.io/

Copyright (c) 2021-2026

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
  Process, LCLType, ComCtrls, IniFiles, about_form, help_form;

type

  { Tform_main }

  Tform_main = class(TForm)
    btn_launch: TButton;
    bitrate_label: TLabel;
    check_alwas_on_top: TCheckBox;
    check_UHID_keyboard: TCheckBox;
    check_turn_screen_off: TCheckBox;
    check_stay_awake: TCheckBox;
    check_audio: TCheckBox;
    check_power_off: TCheckBox;
    check_UHID_mouse: TCheckBox;
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
   args : TStringList;
   proc : TProcess;
   tmp : AnsiString;
   i : Integer;
begin
     args := TStringList.Create;
     try
        if (bitrate_bar.Position > 0) then
           begin
             args.Add('-b');
             args.Add(IntToStr(bitrate_bar.Position) + 'M');
           end;

        if (check_max_size_vid.Checked) then
           begin
             args.Add('--max-size');
             args.Add(combo_max_size_vid.Text);
           end;

        if (check_max_fps_vid.Checked) then
           begin
             args.Add('--max-fps');
             args.Add(combo_max_fps_vid.Text);
           end;

        if (check_video_orientation.Checked) then
           args.Add('--lock-video-orientation=' + IntToStr(combo_video_orientation.ItemIndex));

        if (check_video_recording.Checked) then
           begin
             args.Add('--record');
             args.Add(record_filename_video.Text);
           end;

        if (check_full_screen.Checked) then
           args.Add('--fullscreen');

        if (check_alwas_on_top.Checked) then
           args.Add('--always-on-top');

        if (check_stay_awake.Checked) then
           args.Add('--stay-awake');

        if not (check_audio.Checked) then
           args.Add('--no-audio');

        if (check_turn_screen_off.Checked) then
           args.Add('--turn-screen-off');

        if (check_power_off.Checked) then
           args.Add('--power-off-on-close');

        if (check_UHID_keyboard.Checked) then
           args.Add('-K');

        if (check_UHID_mouse.Checked) then
           args.Add('-M');

        tmp := btn_launch.Caption;
        btn_launch.Caption := 'WAITING!';
        btn_launch.Enabled := False;
        Application.ProcessMessages;

        Application.Minimize;

        proc := TProcess.Create(nil);
        try
           proc.Executable := path_to_scrcpy;
           for i := 0 to args.Count - 1 do
               proc.Parameters.Add(args[i]);

           proc.Options := [poNoConsole, poWaitOnExit];
           proc.ShowWindow := swoHIDE;

           try
              proc.Execute;

              if proc.ExitStatus <> 0 then
                 Application.MessageBox(
                    PChar('scrcpy finalizó con error (código ' + IntToStr(proc.ExitStatus) + ').'),
                    'Aviso', MB_ICONWARNING + MB_OK);
              // ExitStatus = 0 -> todo salió bien, no hace falta avisar

           except
                 on E: Exception do
                    Application.MessageBox(
                       PChar('Failed to launch. Configure path first!' + sLineBreak + E.Message),
                       'Failure', MB_ICONERROR + MB_OK);
           end;

        finally
           proc.Free;
        end;

        Application.Restore;
        btn_launch.Caption := tmp;
        btn_launch.Enabled := True;

     finally
        args.Free;
     end;
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
var
   ini : TIniFile;
begin
     // carga config guardada, si existe
     ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
     try
        path_to_scrcpy := ini.ReadString('config', 'path_to_scrcpy', path_to_scrcpy);
     finally
        ini.Free;
     end;
end;

procedure Tform_main.menu_aboutClick(Sender: TObject);
begin
  aboutForm.ShowModal; // about me form
end;

procedure Tform_main.menu_configClick(Sender: TObject);
var
   ini : TIniFile;
begin
  // config
  if select_scrcpy_exe_dialog.Execute then
     begin
       path_to_scrcpy := select_scrcpy_exe_dialog.FileName;

       // guarda config para la proxima sesion
       ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
       try
          ini.WriteString('config', 'path_to_scrcpy', path_to_scrcpy);
       finally
          ini.Free;
       end;
     end;
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

