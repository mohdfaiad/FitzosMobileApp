unit untStatsForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  untBaseForm, FMX.Objects, FMX.Edit, FMX.ListView.Types, FMX.ListView, untDMDSports,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, FMX.Layouts, FMX.ListBox, FMX.Memo,
  FMX.DateTimeCtrls;

type
  TfrmStats = class(TfrmBase)
    lvStats: TListView;
    tbExisting: TToolBar;
    lblExisting: TLabel;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    btnAdd: TButton;
    pnlAddStat: TPanel;
    cboStats: TComboBox;
    pnlName: TGridPanelLayout;
    lblName: TLabel;
    edtName: TEdit;
    pnlDetails: TGridPanelLayout;
    lblValue: TLabel;
    edtValue: TEdit;
    lblComment: TLabel;
    memContent: TMemo;
    lblDate: TLabel;
    edtDate: TDateEdit;
    btnAddStat: TButton;
    LinkFillControlToField2: TLinkFillControlToField;
    procedure btnAddClick(Sender: TObject);
    procedure btnAddStatClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  untMainForm, untDataModule;

{$R *.fmx}
procedure TfrmStats.btnAddClick(Sender: TObject);
begin
  inherited;
  pnlAddStat.Visible := true;
end;

procedure TfrmStats.btnAddStatClick(Sender: TObject);
begin
  inherited;
  pnlAddStat.Visible := false;
end;

procedure TfrmStats.FormActivate(Sender: TObject);
var
  sResult : String;
begin
  inherited;
  edtDate.Align := TAlignLayout.client;
  with dmdSports do
  begin
    rdsaStatsForSports.Active := false;
    respStatsForSport.Content.Empty;
    reqStatsForSport.ClearBody;
    reqStatsForSport.Params.ParameterByName('id').Value := dmdDataModule.memberId;
//    reqStatsForSport.Params.ParameterByName('signature').Value := dmdDatamodule.signature('getSports');
//    reqStatsForSport.Params.ParameterByName('key').Value := dmdDataModule.getApiKey;
    reqStatsForSport.Execute;
    sResult := getResultString(respStatsForSport.Content);
    if (sResult = 'OK') then
    begin
        rdsaStatsForSports.Response := respStatsForSport;
        rdsaStatsForSports.UpdateDataSet;
        fdmStatsForSport.Open;
    end;

    rdsaSportsStats.Active := false;
    respSportsStats.Content.Empty;
    reqSportsStats.ClearBody;
    reqSportsStats.Params.ParameterByName('id').Value := dmdDataModule.memberId;
//    reqSportsStats.Params.ParameterByName('signature').Value := dmdDatamodule.signature('getSports');
//    reqSportsStats.Params.ParameterByName('key').Value := dmdDataModule.getApiKey;
    reqSportsStats.Execute;
    sResult := getResultString(respSportsStats.Content);
    if (sResult = 'OK') then
    begin
        rdsaSportsStats.Response := respSportsStats;
        rdsaSportsStats.UpdateDataSet;
        fdmSportsStats.Open;
    end;
  end;
end;

initialization
RegisterFMXClasses([TfrmStats]);


end.
