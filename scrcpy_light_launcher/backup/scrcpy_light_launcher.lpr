program scrcpy_light_launcher;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, main, about_form, about_pic, help_form
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tform_main, form_main);
  Application.CreateForm(TaboutForm, aboutForm);
  Application.CreateForm(TKronoPic, KronoPic);
  Application.CreateForm(Thelp_form, help_form);
  Application.Run;
end.

