unit untSignUpForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.ListBox, FMX.Edit,untDmdSignup, Data.Bind.Components,
  System.Rtti, FMX.Layouts, FMX.Controls.Presentation, FMX.Notification,
  FMX.AndroidLike.Toast, FMX.Memo, FGX.ProgressDialog;

type
  TfrmSignup = class(TForm)
    imgLogo: TImageControl;
    txtWelcomeMessage: TText;
    cboType: TComboBox;
    edtName: TEdit;
    edtEmail: TEdit;
    edtPassword: TEdit;
    btnSignup: TButton;
    StyleBook1: TStyleBook;
    pnlForm: TGridPanelLayout;
    lblMemberType: TLabel;
    lblName: TLabel;
    lblEmail: TLabel;
    lblPassword: TLabel;
    saveMessage: TToast;
    Notifications: TNotificationCenter;
    fgActivityDialog: TfgActivityDialog;
    procedure btnSignupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    dmdSignup: TdmdSignup;
    procedure showmessage(mesg : String);
    procedure showActivityDialog(Title, Mesg: String);
    function getSelectedValue(AObject: TObject): TValue;
  public
    { Public declarations }
  end;

implementation

uses
  untJsonFunctions,untFormRegistry, FMX.Styles, untDataModule;

{$R *.fmx}
procedure TfrmSignup.btnSignupClick(Sender: TObject);
var
  sResult : String;
  bExists : Boolean;
  lValue : TValue;
  sType : String;
begin
  showActivityDialog('Creating account','Please Wait');
  // ok lets check to see if the user exists already
  with dmdSignup do
  begin
      fgActivityDialog.Title :='Checking if email already in use!';
      respCheckExists.Content.Empty;
      reqCheckExists.ClearBody;
      reqCheckExists.Params.ParameterByName('email').Value := edtEmail.Text;
      reqCheckExists.Execute;
      sResult := getResultString(respCheckExists.Content);
      if (sResult = 'OK') then
      begin
        // if here then they exist already
        bExists := getResultBoolean(respCheckExists.Content,'Result');
        if bExists then
        begin
          savemessage.now('That email address is already in use!');
        end
        else
        begin
        end;
      end
      else
      begin
          fgActivityDialog.Title :='Creating account!';
          // ok we can process the call
          respCreateMember.content.Empty;
          reqCreateMember.ClearBody;
          reqCreateMember.Params.Clear;
          reqCreateMember.Params.AddItem('name',edtName.Text);
          reqCreateMember.Params.AddItem('password',edtPassword.Text);
          reqCreateMember.Params.AddItem('choice','Athlete');
          reqCreateMember.Params.AddItem('email',edtEmail.Text);
          reqCreateMember.Params.AddItem('key',dmdDataModule.sessionKey);
          reqCreateMember.Execute;
          sResult := getResultString(respCreateMember.Content);
          fgActivityDialog.hide();
          if (sResult = 'OK') then
          begin
            showmessage('Membership created. Please check your email for an activation link.');
          end
          else
          begin
            savemessage.now('There was an error creating the account.');
          end;
          close;
      end;
  end;
end;

procedure TfrmSignup.FormCreate(Sender: TObject);
var
    Style: TFMXObject;
begin
  dmdSignup := TdmdSignup.Create(self);
    {$IFDEF MSWINDOWS}
        Style := TStyleStreaming.LoadFromResource(HInstance, 'OrangeStyle', RT_RCDATA);
    {$ENDIF}
    {$IFDEF Android}
        Style := TStyleStreaming.LoadFromResource(HInstance, 'OrangeStyle', RT_RCDATA);
    {$ENDIF}
    {$IFDEF iOS}
        Style := TStyleManager.LoadFromResource(HInstance, 'OrangeStyle', RT_RCDATA);
    {$ENDIF}
    if Style<> nil then
        TStyleManager.SetStyle(Style);
end;

procedure TfrmSignup.FormDestroy(Sender: TObject);
begin
  dmdSignup.Free;
end;

function TfrmSignup.getSelectedValue(AObject: TObject): TValue;
var
  LEditor : IBindListEditorCommon;
begin
  LEditor := GetBindEditor(AObject, IBindListEditorCommon) as IBindListEditorCommon;
  Result := Leditor.SelectedValue;
end;

procedure TfrmSignup.showActivityDialog(Title, Mesg: String);
begin
  fgActivityDialog.Title := title;
  fgActivityDialog.Message := Mesg;
  fgActivityDialog.Show;
end;

procedure TfrmSignup.showmessage(mesg: String);
var
  MyNotification: TNotification;
begin
  MyNotification := Notifications.CreateNotification;
  try
    MyNotification.Name := 'MyNotification';
    MyNotification.AlertBody := mesg;
    MyNotification.EnableSound := False;
    Notifications.PresentNotification(MyNotification);
  finally
    MyNotification.DisposeOf;
  end;
end;

initialization
RegisterFMXClasses([TfrmSignup]);

end.
