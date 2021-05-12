unit about_pic;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TKronoPic }

  TKronoPic = class(TForm)
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private

  public

  end;

var
  KronoPic: TKronoPic;

implementation

{$R *.lfm}

{ TKronoPic }

procedure TKronoPic.Image1Click(Sender: TObject);
begin
  Close;
end;



end.

