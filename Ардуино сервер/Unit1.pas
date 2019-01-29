unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IPPeerClient, IPPeerServer,
  System.Actions, Vcl.ActnList, Vcl.StdCtrls, System.Tether.Manager,
  System.Tether.AppProfile, REGISTRY, CPort, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    ServManager: TTetheringManager;
    ServAppProfile: TTetheringAppProfile;
    Label1: TLabel;
    Memo1: TMemo;
    ActionList1: TActionList;
    Action1: TAction;
    ComPort1: TComPort;
    ComDataPacket1: TComDataPacket;
    Timer1: TTimer;
    procedure Action1Execute(Sender: TObject);
    procedure ServManagerRequestManagerPassword(const Sender: TObject;
      const ARemoteIdentifier: string; var Password: string);
    procedure ServManagerPairedFromLocal(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure ServManagerPairedToRemote(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure FormShow(Sender: TObject);
    procedure IsntReceiveingData;
    procedure ComDataPacket1Packet(Sender: TObject; const Str: string);
    procedure Timer1Timer(Sender: TObject);
    procedure ReceiveingData;
    procedure ServManagerEndAutoConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  prevString: string;

implementation

{$R *.dfm}

procedure TForm1.Action1Execute(Sender: TObject);
begin
  Memo1.Lines.Add('asdfadsf')
end;

procedure TForm1.IsntReceiveingData;
begin
  Label1.Caption := 'Не получаю данные';
  Label1.Font.Color := clred;
  if ComPort1.Connected then
  begin
    ComPort1.Close;
  end
  else
  begin
    try
      ComPort1.Open;
    except
    end;
  end;
end;

procedure TForm1.ComDataPacket1Packet(Sender: TObject; const Str: string);
begin
  Timer1.Enabled := false;
  ReceiveingData;
  Timer1.Enabled := true;
  if (length(Str) = 23) and (AnsiCompareStr(str, prevString) <> 0) then
  begin
    ServAppProfile.Resources.FindByName('ArduinoStatus').Value := Str;
    Memo1.Lines.Add(Str);
    prevString := Copy(Str,0, length(str));
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  Reg : TRegistry;
begin
  IsntReceiveingData;
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  If Reg.OpenKeyReadOnly('\SYSTEM\CurrentControlSet\Enum\USB\VID_2341&PID_003D\756333130333512052B1\Device Parameters') Then
  Begin
    If Reg.ValueExists('PortName') then
      begin
        ComPort1.Port := Reg.ReadString('PortName');
        Form1.Caption := 'Ардуино Клиент: подключен к ' + ComPort1.Port;
        if ComPort1.Connected then
        begin
          ComPort1.Close;
        end
        else
        begin
          try
            ComPort1.Open;
          except
          end;
        end;
      end;
    Reg.CloseKey;
  End;
  ServManager.AutoConnect();
end;

procedure TForm1.ServManagerEndAutoConnect(Sender: TObject);
var
  I: Integer;
begin
//  Memo1.Lines.Clear;
  Memo1.Lines.Add('---------------------------------'#13#10'EndAutoConnect'#13#10'Remote Managers:');
  for I := 0 to pred(ServManager.RemoteManagers.Count) do
    begin
      Memo1.Lines.Add('  MANAGER '+i.ToString);
      Memo1.Lines.Add('  Name '+ServManager.RemoteManagers[i].ManagerName);
      Memo1.Lines.Add('  Description '+ServManager.RemoteManagers[i].ManagerText);
      Memo1.Lines.Add('  Identifier '+ServManager.RemoteManagers[i].ManagerIdentifier);
      Memo1.Lines.Add('  Connection string '+ServManager.RemoteManagers[i].ConnectionString);
      Memo1.Lines.Add('-------------');
    end;
  Memo1.Lines.Add('Remote Profiles');
  for I := 0 to Pred(ServManager.RemoteProfiles.Count) do
    begin
      Memo1.Lines.Add('Profile '+i.ToString);
      Memo1.Lines.Add('  Description '+ServManager.RemoteProfiles[i].ProfileText);
      Memo1.Lines.Add('  Manager Identifier '+ServManager.RemoteProfiles[i].ManagerIdentifier);
      Memo1.Lines.Add('  Identifier '+ServManager.RemoteProfiles[i].ProfileIdentifier);
      Memo1.Lines.Add('  Group '+ServManager.RemoteProfiles[i].ProfileGroup);
      Memo1.Lines.Add('  Type '+ServManager.RemoteProfiles[i].ProfileType);
      Memo1.Lines.Add('-------------');
    end;
end;

procedure TForm1.ServManagerPairedFromLocal(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  Memo1.Lines.Add('Клиент подключился ко мне');
end;

procedure TForm1.ServManagerPairedToRemote(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  Memo1.Lines.Add('Я подключился к клиенту');
end;

procedure TForm1.ServManagerRequestManagerPassword(const Sender: TObject;
  const ARemoteIdentifier: string; var Password: string);
begin
  Password := '123456';
end;

procedure TForm1.ReceiveingData;
begin
  Label1.Caption := 'Получаю данные';
  Label1.Font.Color := clgreen;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  IsntReceiveingData;
end;

end.
