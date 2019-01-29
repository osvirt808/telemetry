unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Layouts, IPPeerClient, IPPeerServer, FMX.Memo,
  System.Actions, FMX.ActnList, System.Tether.Manager, System.Tether.AppProfile,
  Unit4, Unit5, unit2, unit7, System.Math.Vectors, FMX.Media,
  FMX.Controls.Presentation;

type

  TForm3 = class(TForm)
    Layout1: TLayout;
    Rectangle1: TRectangle;
    ClientManager: TTetheringManager;
    ClientAppProfile: TTetheringAppProfile;
    ActionList1: TActionList;
    Subscribe: TAction;
    MediaPlayer1: TMediaPlayer;
    Button1: TButton;
    StyleBook1: TStyleBook;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ClientManagerEndAutoConnect(Sender: TObject);
    procedure ClientManagerPairedFromLocal(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure ClientManagerPairedToRemote(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure ClientManagerRequestManagerPassword(const Sender: TObject;
      const ARemoteIdentifier: string; var Password: string);
    procedure SubsExec;
    procedure ClientAppProfileResourceUpdated(const Sender: TObject;
      const AResource: TRemoteResource);
    procedure SetLineStatus(str: string);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    fider: array of TMyFider;
    Bus: array of TBus;
    MainShield: TShield;
    FMainAlarm: Boolean;
    procedure SetMainAlarm(const Value: boolean);
    { Private declarations }
  public
    { Public declarations }
  published
    property MainAlarm: boolean read FMainAlarm write SetMainAlarm;
  end;


var
  Form3: TForm3;
  ErrorCount: integer = 0;

implementation

{$R *.fmx}

procedure TForm3.Button1Click(Sender: TObject);
begin
  MainAlarm := false;
end;

procedure TForm3.ClientAppProfileResourceUpdated(const Sender: TObject;
  const AResource: TRemoteResource);
begin
  SetLineStatus(AResource.Value.AsString);
end;

procedure TForm3.ClientManagerEndAutoConnect(Sender: TObject);
var
  I: Integer;
begin
  if ClientManager.RemoteProfiles.Count > 0 then
    SubsExec;
end;

procedure TForm3.SetLineStatus(str: string);
var
  i,j: integer;
  ErCount: integer;
  b: boolean;
  fiders, buses, together, mPower, mEarth: set of boolean;
begin
  fiders:=[];
  buses:=[];
  together:=[];
  ErCount := 0;

  for j := 1 to high(fider) do
  begin
    if fider[j].PinKey <> 0 then
    begin
      fider[j].IsOn := not strtobool(str[fider[j].PinKey-1]);
      Include(fiders, fider[j].IsOn);
      if not fider[j].IsOn then inc(ErCount);
    end;
    if fider[j].PinAlarm <> 0 then
    begin
      fider[j].LineIsGood := not strtobool(str[fider[j].PinAlarm-1]);
      Include(fiders, fider[j].LineIsGood);
      if not fider[j].LineIsGood then inc(ErCount);
    end;
  end;

  for j := 1 to high(bus) do
  begin
    if bus[j].PinBus <> 0 then
    begin
      bus[j].BusIsGood := not strtobool(str[bus[j].PinBus-1]);
      Include(buses, bus[j].BusIsGood);
      if not bus[j].BusIsGood then inc(ErCount);
    end;
    if bus[j].PinEarth <> 0 then
    begin
      bus[j].Earth := not strtobool(str[bus[j].PinEarth-1]);
      Include(buses, bus[j].Earth);
      if bus[j].Earth then inc(ErCount);
    end;
    if bus[j].PinLowPower <> 0 then
    begin
      bus[j].LowPower := not strtobool(str[bus[j].PinLowPower-1]);
      Include(buses, bus[j].LowPower);
      if bus[j].LowPower then inc(ErCount);
    end;


    Include(mEarth, bus[j].Earth);
    Include(mPower, bus[j].LowPower);
  end;

  MainShield.Ahtung := not strtobool(str[MainShield.PinAhtung-1]);
  if MainShield.Ahtung then inc(ErCount);

  Include(together, true in fiders);
  Include(together, true in buses);
  Include(together, MainShield.Ahtung);

  MainShield.BusIsGood := not (false in together);
  MainShield.Earth := true in mEarth;
  MainShield.LowPower := true in mPower;

  if ErCount > ErrorCount then MainAlarm := true;
  ErrorCount := ErCount;
end;

procedure TForm3.SetMainAlarm(const Value: boolean);
begin
  Button1.HitTest := Value;
  if Value <> MainAlarm then FMainAlarm := Value;
  Timer1.Enabled := Value;
  Timer2.Enabled := Value;
  if Value then
    MediaPlayer1.Play
  else
    MediaPlayer1.Stop;

  Button1.ApplyTriggerEffect(Self, 'MainAlarm');
  Button1.StartTriggerAnimation(Self, 'MainAlarm');
end;

procedure TForm3.SubsExec;
var
  pInfo:TTetheringProfileInfo;
  rRes:TRemoteResource;
  i: integer;
begin
  pInfo := ClientManager.RemoteProfiles[0];
  rRes := ClientAppProfile.GetRemoteResourceValue(pInfo, 'ArduinoStatus');
  ClientAppProfile.SubscribeToRemoteItem(pInfo,rRes);
  SetLineStatus(rRes.Value.AsString);
end;


procedure TForm3.Timer1Timer(Sender: TObject);
begin
if MediaPlayer1.State = TMediaState.Stopped then
  begin
    MediaPlayer1.CurrentTime := 0;
    MediaPlayer1.Play;
  end;
end;

procedure TForm3.Timer2Timer(Sender: TObject);
begin
  if MediaPlayer1.Media.Duration=MediaPlayer1.CurrentTime then
    MediaPlayer1.CurrentTime :=0;
end;

procedure TForm3.ClientManagerPairedFromLocal(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  ClientManager.UnPairManager(AManagerInfo);
  ClientManager.AutoConnect();
end;

procedure TForm3.ClientManagerPairedToRemote(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
//  Memo1.Lines.Add('Я подключаюсь к серверу');
end;

procedure TForm3.ClientManagerRequestManagerPassword(const Sender: TObject;
  const ARemoteIdentifier: string; var Password: string);
begin
  Password := '123456';
end;

procedure TForm3.FormCreate(Sender: TObject);
var
  i: integer;
begin
  setlength(fider, 17);
  setlength(Bus,3);

  MainShield := TShield.Create(Self);
  with MainShield do begin
    Height := 200;
    Width := 200;
    Position.X := 300;
    Position.Y := 20;
    Align := TAlignLayout.Scale;
    Parent := Layout1;
  end;

  for I := 0 to high(Bus) do
  begin
    bus[i] := TBus.Create(Self);
  end;

  for I := 1 to high(Bus) do
  begin
    with bus[i] do begin
      Height := 5;
      Width := 300;
      Position.X := 400+ round((i-1.5)*2)*240 -150;
      Position.Y := 385;
      Align := TAlignLayout.Scale;
      Parent := Layout1;
    end;
  end;


  for I := 0 to 16 do
  begin
    fider[i] := TMyFider.Create(Self);
    fider[i].PinKey := 0;
    fider[i].PinAlarm := 0;
  end;

  for i := 1 to 5 do
  begin
    with fider[i] do begin
      Height := 163;
      Width := 40;
      Position.X := (i-1)*60+20;
      Position.Y := 390;
      Align := TAlignLayout.Scale;
      Parent := Layout1;
    end;
  end;
  for i := 8 to 12 do
  begin
    fider[i] := TMyFider.Create(Self);
    with fider[i] do begin
      Height := 163;
      Width := 40;
      Position.X := (i-1)*60+80;
      Position.Y := 390;
      Align := TAlignLayout.Scale;
      Parent := Layout1;
    end;
  end;
  for i := 13 to 14 do
  begin
    fider[i] := TMyFider.Create(Self);
    with fider[i] do begin
      Height := 130;
      Width := 40;
      Position.X := (14-i)*400+200;
      Position.Y := 255;
      Align := TAlignLayout.Scale;
      Parent := Layout1;
    end;
  end;
  for i := 15 to 16 do
  begin
    fider[i] := TMyFider.Create(Self);
    with fider[i] do begin
      Height := 150;
      Width := 40;
      Position.X := (16-i)*400+200;
      Position.Y := 125;
      Align := TAlignLayout.Scale;
      Parent := Layout1;
    end;
  end;

end;

procedure TForm3.FormShow(Sender: TObject);
var
  i: byte;
  MyRect: array [0..3] of TRectF;
  image: TImage;
begin
  MainShield.PinAhtung := 12;

  bus[2].PinBus := 17; bus[2].PinEarth := 18; bus[2].PinLowPower := 4;
  bus[1].PinBus := 19; bus[1].PinEarth := 20; bus[1].PinLowPower := 9;

  fider[1].Activity := F6OutOn;   fider[1].PinAlarm := 23;  fider[1].PinKey:= 24;  fider[1].Line := 21;
  fider[2].Activity := F6OutOff;                                                   fider[2].Line := 20;
  fider[3].Activity := F6OutOn;   fider[3].PinAlarm := 21;  fider[3].PinKey:= 22;  fider[3].Line := 19;
  fider[4].Activity := F6OutOff;                                                   fider[4].Line := 18;
  fider[5].Activity := F6OutOff;                                                   fider[5].Line := 16;

  fider[8].Activity := F6OutOff;                                                   fider[8].Line := 14;
  fider[9].Activity := F6OutOff;                                                   fider[9].Line := 12;
  fider[10].Activity :=F6OutOff;                                                   fider[10].Line :=10;
  fider[11].Activity :=F6OutOn;  fider[11].PinAlarm := 13; fider[11].PinKey := 16; fider[11].Line := 9;
  fider[12].Activity :=F6OutOn;  fider[12].PinAlarm := 15; fider[12].PinKey := 14; fider[12].Line := 7;

  fider[13].Activity := F6In;    fider[13].PinAlarm := 10; fider[13].PinKey := 8;  fider[13].Line := 3;
  fider[14].Activity := F6In;    fider[14].PinAlarm := 5;  fider[14].PinKey := 3;  fider[14].Line := 23;
  fider[15].Activity := F35In;   fider[15].PinAlarm := 6;  fider[15].PinKey := 2;
  fider[16].Activity := F35In;   fider[16].PinAlarm := 11; fider[16].PinKey := 7;

  for i := 1 to 5 do
  begin
    with fider[i] do begin
      Section := 2;
    end;
  end;
  for i := 8 to 12 do
  begin
    with fider[i] do begin
      Section := 1;
    end;
  end;
  for i := 13 to 14 do
  begin
    with fider[i] do begin
      Section := i-12;
    end;
  end;
  for i := 15 to 16 do
  begin
    with fider[i] do begin
      Section := i-14;
    end;
  end;

  MainShield.ApplyStyleLookup;

  image := MainShield.FindStyleResource('textarea') as TImage;

  Image.Bitmap.Clear($FFFFFF);
  Image.Bitmap.SetSize(Round(Image.Width), Round(Image.Height));
  // sets the rectangle where the text will be displayed
  MyRect[0] := TRectF.Create(0, 0, 140, 50);
  MyRect[1] := TRectF.Create(0, 50, 140, 100);
  MyRect[2] := TRectF.Create(0, 100, 140, 150);
  MyRect[3] := TRectF.Create(0, 150, 140, 200);
  // fills and draws the text in the specified rectangle area of the canvas
  Image.Bitmap.Canvas.BeginScene;
  Image.Bitmap.Canvas.FillText(MyRect[0], 'Неисправность ТН 6кВ', false, 100, [TFillTextFlag.RightToLeft], TTextAlign.Center, TTextAlign.Center);
  Image.Bitmap.Canvas.FillText(MyRect[1], 'Мин. напряжение', false, 100, [TFillTextFlag.RightToLeft], TTextAlign.Center, TTextAlign.Center);
  Image.Bitmap.Canvas.FillText(MyRect[2], 'Земля в цепи', false, 100, [TFillTextFlag.RightToLeft], TTextAlign.Center, TTextAlign.Center);
  Image.Bitmap.Canvas.FillText(MyRect[3], 'Аварийное отключение', false, 100, [TFillTextFlag.RightToLeft], TTextAlign.Center, TTextAlign.Center);
  Image.Bitmap.Canvas.EndScene;

  ClientManager.AutoConnect('192.168.0.14');
end;

end.

