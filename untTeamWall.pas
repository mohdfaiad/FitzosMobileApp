unit untTeamWall;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  untBaseForm, FMX.Objects, FMX.Edit;

type
  TfrmTeamWall = class(TfrmBase)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  untMainForm;

{$R *.fmx}
initialization
RegisterFMXClasses([TfrmTeamWall]);

end.
