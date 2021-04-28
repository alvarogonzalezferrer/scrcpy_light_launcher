unit about_form;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLIntf,
  ExtCtrls, about_pic;

type

  { TaboutForm }

  TaboutForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
  private

  public

  end;

var
  aboutForm: TaboutForm;

implementation

{$R *.lfm}

{ TaboutForm }

procedure TaboutForm.Label2Click(Sender: TObject);
begin
  // launch my website
  OpenURL('https://alvarogonzalezferrer.github.io/');
end;

procedure TaboutForm.Label3Click(Sender: TObject);
begin
  // launch scrcpy website
  OpenURL('https://github.com/Genymobile/scrcpy');
end;

procedure TaboutForm.FormCreate(Sender: TObject);
begin

end;

procedure TaboutForm.Image1Click(Sender: TObject);
begin
  KronoPic.ShowModal;
end;

procedure TaboutForm.Label1Click(Sender: TObject);
begin
  Close
end;

procedure TaboutForm.FormClick(Sender: TObject);
begin
  Close;
end;

end.

